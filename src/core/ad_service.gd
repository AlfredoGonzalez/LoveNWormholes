class_name AdService
extends RefCounted
## Rewarded ads (spec 7.1). Rules enforced here:
##  - the reward is granted ONLY from the provider's `rewarded` signal, once per shown ad;
##  - it is persisted FIRST (profile.pending_rewards + save), only then `reward_granted` is emitted;
##  - pending rewards that were never delivered (app killed after the callback) are re-delivered by start()
##    and claimed once;
##  - placements and `enabled` flags come from a config dictionary (config/ads.json shape:
##    placement id -> {"enabled": bool, "reward": {...optional default reward}});
##  - no ads before the player cleared stage `min_stage_for_ads` (stage number 1..50, default 3);
##  - the next ad is preloaded after one finishes/fails, with exponential backoff (driven by update() and an
##    injectable clock, so it is testable); the player is never blocked or penalized when no ad is ready.
##
## Exactly-once on the effect side: a listener of `reward_granted` should apply the reward through the same
## profile (Economy.add*/settle persist it). The pending entry is removed from the in-memory profile BEFORE
## the signal, and the save that follows (the listener's or ours) writes the grant and the removal together.

signal reward_granted(placement: String, reward: Dictionary)
signal ad_failed(placement: String, reason: String)
signal availability_changed(placement: String)

const BACKOFF_BASE := 2.0
const BACKOFF_MAX := 300.0
const INFLIGHT_GUARD := 30.0

var provider: AdProvider
var save_service: SaveService
var config: Dictionary
var analytics: AnalyticsService
var min_stage_for_ads: int
var clock: Callable

var _showing := {}      # placement -> reward Dictionary requested for the ad on screen
var _fails := {}        # placement -> consecutive failures
var _next_at := {}      # placement -> earliest clock time for the next preload call
var _started := false
var _connected := false

func _init(p_provider: AdProvider, p_save: SaveService, p_config: Dictionary, p_min_stage_for_ads := 3,
		p_analytics: AnalyticsService = null, p_clock: Callable = Callable()) -> void:
	provider = p_provider
	save_service = p_save
	config = p_config
	min_stage_for_ads = p_min_stage_for_ads
	analytics = p_analytics
	clock = p_clock if p_clock.is_valid() else Callable(self, "_system_clock")
	provider.rewarded.connect(_on_rewarded)
	provider.closed.connect(_on_closed)
	provider.failed.connect(_on_failed)
	provider.ready_changed.connect(_on_ready_changed)
	_connected = true

func _system_clock() -> float:
	return Time.get_unix_time_from_system()

func shutdown() -> void:
	if _connected:
		provider.rewarded.disconnect(_on_rewarded)
		provider.closed.disconnect(_on_closed)
		provider.failed.disconnect(_on_failed)
		provider.ready_changed.disconnect(_on_ready_changed)
		_connected = false

## Call once at app start, after the consent state is known. Re-delivers undelivered rewards.
func start(consent_known: bool) -> void:
	_started = true
	provider.initialize(consent_known)
	deliver_pending()
	update()

# ---------------------------------------------------------------- queries

func highest_stage_cleared() -> int:
	var best := 0
	var hs: Dictionary = save_service.profile["progress"]["highest_stage_cleared"]
	for e in hs:
		var s := int(hs[e])
		if s > 0:
			best = maxi(best, (int(e) - 1) * 10 + s)
	return best

func ads_unlocked() -> bool:
	return highest_stage_cleared() >= min_stage_for_ads

func placement_enabled(placement: String) -> bool:
	var c = config.get(placement)
	return typeof(c) == TYPE_DICTIONARY and bool(c.get("enabled", false))

## True when the UI should show an active ad button for this placement.
func is_available(placement: String) -> bool:
	return placement_enabled(placement) and ads_unlocked() and not _showing.has(placement) and provider.is_ready(placement)

# ---------------------------------------------------------------- show

## Requests the ad; returns false (and does nothing) if it is not available. `reward` overrides the
## placement's configured default reward.
func show_ad(placement: String, reward := {}) -> bool:
	if not is_available(placement) or not _showing.is_empty():
		return false
	var r: Dictionary = reward if not reward.is_empty() else config[placement].get("reward", {})
	_showing[placement] = r.duplicate(true)
	_log("ad_started", {"placement": placement})
	provider.show(placement)
	return true

func _on_rewarded(placement: String) -> void:
	if not _showing.has(placement):
		return   # duplicate or unsolicited callback: never grants
	var reward: Dictionary = _showing[placement]
	_showing.erase(placement)
	var p := save_service.profile
	p["reward_seq"] = int(p["reward_seq"]) + 1
	var entry := {"id": p["reward_seq"], "placement": placement, "reward": reward}
	p["pending_rewards"].append(entry)
	save_service.save()   # persisted first
	_log("ad_rewarded", {"placement": placement})
	_deliver(entry)

func _on_closed(placement: String) -> void:
	_showing.erase(placement)
	_fails[placement] = 0
	_preload_now(placement)

func _on_failed(placement: String, reason: String) -> void:
	var was_showing := _showing.has(placement)
	_showing.erase(placement)
	_fails[placement] = int(_fails.get(placement, 0)) + 1
	_next_at[placement] = float(clock.call()) + backoff_delay(int(_fails[placement]))
	if was_showing:
		ad_failed.emit(placement, reason)   # no reward, nothing penalized
		_log("ad_failed", {"placement": placement, "reason": reason})

func _on_ready_changed(placement: String, is_ready: bool) -> void:
	if is_ready:
		_fails[placement] = 0
	availability_changed.emit(placement)

## Delivers every pending reward once (used on start, after a kill between callback and delivery).
func deliver_pending() -> void:
	for entry in save_service.profile["pending_rewards"].duplicate():
		_deliver(entry)

func _deliver(entry: Dictionary) -> void:
	var pending: Array = save_service.profile["pending_rewards"]
	var idx := -1
	for i in pending.size():
		if pending[i]["id"] == entry["id"]:
			idx = i
	if idx < 0:
		return   # already claimed
	pending.remove_at(idx)
	reward_granted.emit(entry["placement"], entry["reward"])
	save_service.save()   # claim is persisted together with whatever the listener changed

# ---------------------------------------------------------------- preload with backoff

func backoff_delay(failures: int) -> float:
	return minf(BACKOFF_BASE * pow(2.0, maxi(failures - 1, 0)), BACKOFF_MAX)

func _wants_preload(placement: String) -> bool:
	return _started and placement_enabled(placement) and ads_unlocked() and not _showing.has(placement) \
		and not provider.is_ready(placement)

func _preload_now(placement: String) -> void:
	if not _wants_preload(placement):
		return
	_next_at[placement] = float(clock.call()) + INFLIGHT_GUARD
	provider.preload_ad(placement)

## Drive from a timer (e.g. once a second) and after stage clears: preloads placements that are not ready,
## respecting the backoff schedule.
func update() -> void:
	var now := float(clock.call())
	for placement in config:
		if _wants_preload(placement) and now >= float(_next_at.get(placement, 0.0)):
			_preload_now(placement)

func _log(event_name: String, params: Dictionary) -> void:
	if analytics != null:
		analytics.log_event(event_name, params)
