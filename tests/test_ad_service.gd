extends TestCase

const P := "user://t_ads.json"
const CFG := {
	"double_coins": {"enabled": true, "reward": {"coin_multiplier": 2}},
	"food_boost": {"enabled": true},
	"bonus_capsule": {"enabled": false},
}

var now := 1000.0

func _clean() -> void:
	for p in [P, "user://t_ads.bak.json", P + ".tmp", "user://t_ads_copy.json"]:
		if FileAccess.file_exists(p):
			DirAccess.remove_absolute(p)

class Rig:
	var provider := MockAdProvider.new()
	var save: SaveService
	var analytics := MockAnalyticsProvider.new()
	var ads: AdService
	var granted: Array = []

func _rig(stage_cleared := 5, fresh := true, clock_ref: Callable = Callable()) -> Rig:
	if fresh:
		_clean()
	var r := Rig.new()
	r.save = SaveService.new(P)
	r.save.load_profile()
	if fresh:
		r.save.profile["progress"]["highest_stage_cleared"]["1"] = stage_cleared
	var clk := clock_ref if clock_ref.is_valid() else func(): return now
	r.ads = AdService.new(r.provider, r.save, CFG, 3, AnalyticsService.new(r.analytics), clk)
	var granted := r.granted   # capture the array, not the rig (avoids a reference cycle)
	r.ads.reward_granted.connect(func(p, rw): granted.append([p, rw]))
	r.ads.start(true)
	return r

func test_reward_once_and_persisted_before_signal() -> void:
	var r := _rig()
	assert_true(r.provider.initialized and r.provider.consent_known)
	assert_true(r.ads.is_available("double_coins"), "preloaded at start")
	# check the disk state at the moment the UI signal fires
	var on_disk := []
	r.ads.reward_granted.connect(func(_p, _rw):
		var s := SaveService.new(P)
		s.load_profile()
		on_disk.append(s.profile["pending_rewards"].size()))
	assert_true(r.ads.show_ad("double_coins"))
	assert_eq(r.granted.size(), 1)
	assert_eq(r.granted[0], ["double_coins", {"coin_multiplier": 2}])
	assert_eq(on_disk, [1], "reward was already on disk (pending) when reward_granted fired")
	assert_eq(r.save.profile["pending_rewards"].size(), 0, "claimed afterwards")
	assert_eq(r.analytics.count("ad_rewarded"), 1)
	_clean()

func test_duplicate_rewarded_signal_grants_once() -> void:
	var r := _rig()
	r.provider.duplicate_rewarded = true
	r.ads.show_ad("double_coins")
	assert_eq(r.granted.size(), 1)
	r.provider.rewarded.emit("double_coins")   # a late stray callback
	assert_eq(r.granted.size(), 1)
	_clean()

func test_no_reward_when_ad_fails() -> void:
	var r := _rig()
	r.provider.force_fail = true
	var failures := []
	r.ads.ad_failed.connect(func(p, why): failures.append([p, why]))
	r.ads.show_ad("double_coins")
	assert_eq(r.granted.size(), 0)
	assert_eq(failures.size(), 1)
	assert_eq(r.save.profile["pending_rewards"].size(), 0)
	# failure mid-show in manual mode
	r.provider.force_fail = false
	r.provider.manual = true
	r.provider.set_ready("double_coins", true)
	assert_true(r.ads.show_ad("double_coins"))
	r.provider.fail_now("render_error")
	assert_eq(r.granted.size(), 0)
	r.provider.rewarded.emit("double_coins")   # nothing is being shown: ignored
	assert_eq(r.granted.size(), 0)
	_clean()

func test_closed_without_reward_grants_nothing() -> void:
	var r := _rig()
	r.provider.manual = true
	r.ads.show_ad("food_boost")
	r.provider.close_ad()   # user skipped
	assert_eq(r.granted.size(), 0)
	_clean()

func test_kill_after_callback_redelivers_once() -> void:
	var r := _rig()
	# Simulate the process dying right after the callback: when reward_granted fires, snapshot the file as it
	# is on disk (pending reward persisted, not yet claimed) and later restore that snapshot.
	r.ads.reward_granted.connect(func(_p, _rw):
		DirAccess.copy_absolute(P, "user://t_ads_copy.json"))
	r.provider.simulate_kill_after_callback = true
	r.ads.show_ad("double_coins")
	r.ads.shutdown()
	DirAccess.copy_absolute("user://t_ads_copy.json", P)   # the "kill": disk state = pending, undelivered
	var r2 := _rig(5, false)
	assert_eq(r2.granted.size(), 1, "re-delivered on next start")
	assert_eq(r2.granted[0][0], "double_coins")
	assert_eq(r2.save.profile["pending_rewards"].size(), 0)
	r2.ads.shutdown()
	var r3 := _rig(5, false)
	assert_eq(r3.granted.size(), 0, "claimed once, not re-delivered again")
	_clean()

func test_ads_blocked_before_stage_3() -> void:
	var r := _rig(2)
	assert_true(not r.ads.ads_unlocked())
	assert_true(not r.ads.is_available("double_coins"))
	assert_true(not r.ads.show_ad("double_coins"))
	assert_eq(r.provider.preload_calls.get("double_coins", 0), 0, "no ad requests either")
	assert_eq(r.provider.show_calls.get("double_coins", 0), 0)
	r.save.profile["progress"]["highest_stage_cleared"]["1"] = 3
	r.ads.update()
	assert_true(r.ads.is_available("double_coins"))
	_clean()

func test_disabled_placement_and_unknown() -> void:
	var r := _rig()
	assert_true(not r.ads.is_available("bonus_capsule"))
	assert_true(not r.ads.show_ad("bonus_capsule"))
	assert_true(not r.ads.show_ad("nope"))
	assert_eq(r.provider.preload_calls.get("bonus_capsule", 0), 0)
	_clean()

func test_no_ad_ready_never_blocks() -> void:
	var r := _rig()
	r.provider.ready_placements["double_coins"] = false
	assert_true(not r.ads.is_available("double_coins"))
	assert_true(not r.ads.show_ad("double_coins"))
	assert_eq(r.granted.size(), 0)
	_clean()

func test_preload_after_close_and_backoff() -> void:
	var t := [1000.0]
	var r := _rig(5, true, func(): return t[0])
	assert_eq(r.provider.preload_calls["double_coins"], 1, "start preloads")
	r.ads.show_ad("double_coins")   # shown, closed -> next one preloaded right away
	assert_eq(r.provider.preload_calls["double_coins"], 2)
	# now preloads start failing: exponential backoff 2, 4, 8 ...
	r.provider.fail_preload = true
	r.provider.ready_placements["double_coins"] = false
	r.ads.update()
	var calls: int = r.provider.preload_calls["double_coins"]
	assert_eq(calls, 2, "next call not due yet (in-flight guard)")
	t[0] += 31.0
	r.ads.update()   # fails -> 1st failure, delay 2
	assert_eq(r.provider.preload_calls["double_coins"], 3)
	t[0] += 1.0
	r.ads.update()
	assert_eq(r.provider.preload_calls["double_coins"], 3, "still backing off")
	t[0] += 1.5
	r.ads.update()   # fails again -> delay 4
	assert_eq(r.provider.preload_calls["double_coins"], 4)
	t[0] += 3.0
	r.ads.update()
	assert_eq(r.provider.preload_calls["double_coins"], 4)
	t[0] += 1.5
	r.provider.fail_preload = false
	r.ads.update()
	assert_eq(r.provider.preload_calls["double_coins"], 5)
	assert_true(r.ads.is_available("double_coins"), "recovered")
	assert_near(r.ads.backoff_delay(1), 2.0)
	assert_near(r.ads.backoff_delay(4), 16.0)
	assert_near(r.ads.backoff_delay(30), AdService.BACKOFF_MAX)
	_clean()
