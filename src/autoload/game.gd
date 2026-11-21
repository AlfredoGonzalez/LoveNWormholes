extends Node
## Autoload "Game": owns the services and the profile for the whole app (spec 8.3).
## Services use the MOCK providers on desktop/tests and the native adapters (src/platform/android) on Android
## builds when the `native_services` flag is on (PlatformFactory).
## Tests can call Game.boot(<temp save path>) to get a clean, isolated instance.

signal booted

var save: SaveService
var economy: Economy
var ads: AdService
var billing: BillingService
var analytics: AnalyticsService
var consent: ConsentService
var audio: AudioService
var quests: Quests
var nav: Navigator
var last_sim: BattleSim            # the battle that just ended (Second Wind resumes it)
var _ad_timer := 0.0
var _mock_ads: MockAdProvider
var _mock_billing: MockBillingProvider
var _billing_provider: BillingProvider
var _ads_started := false
var _unlocked_eras: Array = []
var booted_ok := false
var offline_popup_shown := false   # the offline Worm Farm popup shows once per app session (spec 6.5: claimed on app open)


func _ready() -> void:
	boot()


func boot(save_path := "user://save.json") -> void:
	DataDB.ensure_loaded()
	Localization.ensure_loaded()
	save = SaveService.new(save_path)
	save.load_profile()
	economy = Economy.new(DataDB.balance(), save)
	if _billing_provider is PlayBillingProvider:
		(_billing_provider as PlayBillingProvider).dispose()
	analytics = AnalyticsService.new(PlatformFactory.analytics_provider())
	analytics.enabled = DataDB.feature_enabled("analytics")
	consent = ConsentService.new(PlatformFactory.consent_provider(), save, analytics, DataDB.feature_enabled("consent_flow"))
	consent.resolved.connect(_try_start_ads)
	consent.changed.connect(_on_consent_changed)
	var ad_provider := PlatformFactory.ad_provider()
	_mock_ads = ad_provider as MockAdProvider
	var ads_on := DataDB.feature_enabled("ads")
	var placements := {}
	for p in DataDB.ads_config().get("placements", []):
		var cap := int(p.get("daily_cap", 0))
		if p.has("daily_cap_from_balance"):
			cap = DataDB.bal_i(str(p["daily_cap_from_balance"]), cap)
		placements[str(p["id"])] = {"enabled": ads_on and bool(p.get("enabled", true)), "daily_cap": cap,
				"cooldown_s": float(p.get("cooldown_s", 0.0))}
	ads = AdService.new(ad_provider, save, placements, DataDB.bal_i("ads.first_ad_after_stage_cleared", 3), analytics)
	ads.global_cooldown_s = float(DataDB.ads_config().get("global_cooldown_s", 0.0))
	_ads_started = false
	var products := {}
	var product_ids: Array = []
	var consumables: Array = []
	for pr in DataDB.shop().get("products", []):
		products[str(pr["id"])] = {"type": str(pr["type"]), "grants": pr.get("contents", {})}
		product_ids.append(str(pr["id"]))
		if str(pr["type"]) == "consumable":
			consumables.append(str(pr["id"]))
	_billing_provider = PlatformFactory.billing_provider(self, product_ids, consumables)
	_mock_billing = _billing_provider as MockBillingProvider
	billing = BillingService.new(_billing_provider, save, products, analytics)
	if audio == null:
		audio = AudioService.new()
		add_child(audio)
	audio.apply_settings(save.profile["settings"])
	var lang: String = str(save.profile["settings"].get("language", ""))
	Localization.set_language(lang if lang in ["en", "es"] else Localization.detect_device_language())
	if quests != null:
		quests.shutdown()
	quests = Quests.new(save, economy)
	ads.reward_granted.connect(_on_reward_granted)
	_connect_analytics()
	nav = Navigator.new()
	offline_popup_shown = false
	booted_ok = true
	booted.emit()


func start_services() -> void:
	## Called by Main at app start. Billing starts at once; ads start only when the consent state is resolved
	## (immediately for a returning player, after the consent screen for a new one).
	mark_seen()
	var first_session := int(save.profile["stats"].get("battles_played", 0)) == 0
	analytics.set_collection_allowed(consent.personalized())
	analytics.session_start(first_session, Localization.get_language())
	consent.start()
	billing.start()
	_try_start_ads()


func _try_start_ads(_state := "") -> void:
	if _ads_started or ads == null or not consent.is_resolved():
		return
	_ads_started = true
	ads.start(true, consent.personalized())


func _on_consent_changed(state: String) -> void:
	ads.set_personalized(state == "accepted")
	analytics.set_collection_allowed(state == "accepted")


## Analytics hooks that no screen owns (docs/ANALYTICS.md): upgrades, era unlocks, daily and offline claims.
func _connect_analytics() -> void:
	_unlocked_eras = _eras_unlocked()
	economy.unit_upgraded.connect(func(id, lvl): analytics.unit_upgrade("unit", str(id), int(lvl)))
	economy.upgrade_purchased.connect(func(kind, id, lvl): analytics.unit_upgrade(str(kind), str(id), int(lvl)))
	economy.daily_claimed.connect(func(r): analytics.log_event("daily_claim", {"streak": int(r.get("streak", 0))}))
	economy.offline_claimed.connect(func(coins): analytics.log_event("offline_claim", {"coins": int(coins)}))
	economy.battle_settled.connect(func(_r):
		var now := _eras_unlocked()
		for e in now:
			if not _unlocked_eras.has(e):
				analytics.era_unlocked(int(e))
		_unlocked_eras = now)


func _eras_unlocked() -> Array:
	var out: Array = []
	for e in range(2, 7):
		if Progress.is_era_unlocked(save.profile, e):
			out.append(e)
	return out


func _process(delta: float) -> void:
	if ads == null:
		return
	_ad_timer += delta
	if _ad_timer >= 1.0:
		_ad_timer = 0.0
		ads.update()


## Shorthand used by every screen: translated text for a key.
func t(key: String, args: Array = []) -> String:
	return Localization.tr_key(key, args)


func set_language(lang: String) -> void:
	Localization.set_language(lang)
	save.profile["settings"]["language"] = lang
	save.save()


## App open / close bookkeeping: timestamps.last_seen, and the Worm Farm timer starts the first time the app opens.
func mark_seen(now := -1.0) -> void:
	var t := Time.get_unix_time_from_system() if now < 0.0 else now
	var ts: Dictionary = save.profile["timestamps"]
	ts["last_seen"] = t
	if float(ts.get("offline_farm", 0)) <= 0.0:
		ts["offline_farm"] = t
	save.save()


func _notification(what: int) -> void:
	if booted_ok and (what == NOTIFICATION_APPLICATION_PAUSED or what == NOTIFICATION_WM_CLOSE_REQUEST):
		mark_seen()


## Global listener for ad rewards that no screen owns (Double Farm, Bonus Capsule, and a Double Coins reward
## re-delivered after an app kill). AdService emits each reward exactly once. When a ResultScreen is listening,
## it applies Double Coins itself, so this skips it then (a reward is never applied twice).
func _on_reward_granted(placement: String, reward: Dictionary) -> void:
	if placement == "double_coins":
		for c in ads.reward_granted.get_connections():
			var o = (c["callable"] as Callable).get_object()
			if o != null and o != self and o is Screen and o.get_script() != null \
					and str(o.get_script().get_global_name()) == "ResultScreen":
				return
	quests.apply_reward(placement, reward)
