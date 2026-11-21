extends TestCase
## The 5 rewarded placements (spec 7.1) end to end with mock services: limits, offered/started/rewarded events,
## reward only after the earned callback, recovery after a kill, never forced ads.

const P := "user://t_placements.json"
const PLACEMENTS := ["double_coins", "food_boost", "second_wind", "bonus_capsule", "double_farm"]

func _g():
	var ml := Engine.get_main_loop()
	if ml == null or not (ml is SceneTree) or (ml as SceneTree).root == null:
		return null
	return (ml as SceneTree).root.get_node_or_null("Game")

func _clean() -> void:
	for p in [P, "user://t_placements.bak.json", P + ".tmp"]:
		if FileAccess.file_exists(p):
			DirAccess.remove_absolute(p)

class RecNav extends Navigator:
	func can_go(_n: String) -> bool:
		return true
	func go(_s: String, _p: Dictionary = {}) -> bool:
		return true

## A booted Game with consent resolved, stage 5 cleared and every placement ready.
func _game():
	var g = _g()
	if g == null:
		return null
	_clean()
	g.boot(P)
	g.nav = RecNav.new()
	g.save.profile["progress"]["highest_stage_cleared"]["1"] = 5
	g.start_services()
	g.consent.set_choice(true)
	return g

func test_config_has_exactly_the_five_rewarded_placements() -> void:
	var ids: Array = []
	for p in DataDB.ads_config().get("placements", []):
		ids.append(str(p["id"]))
	ids.sort()
	var want := PLACEMENTS.duplicate()
	want.sort()
	assert_eq(ids, want)
	assert_true(bool(DataDB.ads_config().get("rewarded_only", false)), "rewarded only: no interstitial/banner")
	# the provider interface only knows rewarded ads
	var methods := AdProvider.new().get_method_list().map(func(m): return str(m["name"]))
	for m in methods:
		assert_true(not (str(m).contains("interstitial") or str(m).contains("banner")), "AdProvider has no %s" % m)

func test_test_ids_are_googles_official_samples() -> void:
	var t: Dictionary = DataDB.ads_config().get("debug_test_ids", {})
	assert_true(str(t.get("app_id_android", "")).begins_with("ca-app-pub-3940256099942544~"))
	assert_true(str(t.get("rewarded_android", "")).begins_with("ca-app-pub-3940256099942544/"))
	var prov := AdMobAdProvider.new()
	for p in PLACEMENTS:
		assert_true(prov.unit_id_for(p).begins_with("ca-app-pub-3940256099942544/"), "test unit id for %s" % p)

func test_every_placement_button_follows_availability_and_reward_needs_earned() -> void:
	var g = _game()
	if g == null:
		return
	for p in PLACEMENTS:
		assert_true(g.ads.placement_enabled(p), "%s enabled by config" % p)
		g._mock_ads.set_ready(p, true)
		var b := MetaUI.ad_button(p, "reward text")
		assert_true(not b.disabled and b.text.find("reward text") >= 0, "%s button live when ready" % p)
		b.free()
		g._mock_ads.set_ready(p, false)
		var b2 := MetaUI.ad_button(p, "reward text")
		assert_true(b2.disabled, "%s button disabled when no ad is loaded" % p)
		assert_true(b2.text.find(g.t("ui.not_available")) >= 0)
		b2.free()
	# reward only after the earned callback
	var granted := []
	g.ads.reward_granted.connect(func(pl, rw): granted.append(pl))
	g._mock_ads.manual = true
	g._mock_ads.set_ready("food_boost", true)
	assert_true(g.ads.show_ad("food_boost", {"food_fraction": 0.3}))
	assert_eq(granted.size(), 0, "ad on screen, nothing granted yet")
	g._mock_ads.close_ad()   # closed WITHOUT earning
	assert_eq(granted.size(), 0, "dismissed early: no reward")
	g._mock_ads.set_ready("food_boost", true)
	g.ads.show_ad("food_boost", {"food_fraction": 0.3})
	g._mock_ads.finish_reward()
	g._mock_ads.close_ad()
	assert_eq(granted, ["food_boost"], "granted exactly once after earned")
	g.boot(P)
	_clean()

func test_ad_offered_started_rewarded_events_once() -> void:
	var g = _game()
	if g == null:
		return
	g._mock_ads.set_ready("double_coins", true)
	var ev: MockAnalyticsProvider = g.analytics.provider
	MetaUI.ad_button("double_coins", "x").free()
	MetaUI.ad_button("double_coins", "x").free()   # screen rebuilds do not re-log the offer
	assert_eq(ev.count("ad_offered"), 1)
	g.ads.show_ad("double_coins", {"coins": 10})
	assert_eq(ev.count("ad_started"), 1)
	assert_eq(ev.count("ad_rewarded"), 1)
	var e: Dictionary = ev.events.filter(func(x): return x["name"] == "ad_rewarded")[0]
	assert_eq(e["params"], {"placement": "double_coins"})
	g.boot(P)
	_clean()

func test_bonus_capsule_daily_cap_from_balance() -> void:
	var g = _game()
	if g == null:
		return
	g._mock_ads.set_ready("bonus_capsule", true)
	assert_true(g.ads.is_available("bonus_capsule"))
	g.ads.show_ad("bonus_capsule", {"capsules": 1})
	assert_eq(g.ads.rewards_today("bonus_capsule"), 1)
	g._mock_ads.set_ready("bonus_capsule", true)
	assert_true(not g.ads.is_available("bonus_capsule"), "cap of %d per day reached" % DataDB.bal_i("ads.bonus_capsule_per_day", 1))
	assert_true(not g.ads.show_ad("bonus_capsule"))
	# next UTC day: available again
	var counters: Dictionary = g.save.profile["seen"]["ad_limits"]["bonus_capsule"]
	counters["day"] = int(counters["day"]) - 1
	g.ads.global_cooldown_s = 0.0
	assert_true(g.ads.is_available("bonus_capsule"))
	g.boot(P)
	_clean()

func test_cooldowns_with_injected_clock() -> void:
	_clean()
	var save := SaveService.new(P)
	save.load_profile()
	save.profile["progress"]["highest_stage_cleared"]["1"] = 5
	var prov := MockAdProvider.new()
	var t := [1000000.0]
	var cfg := {"double_farm": {"enabled": true, "cooldown_s": 60.0}, "food_boost": {"enabled": true}}
	var ads := AdService.new(prov, save, cfg, 3, null, func(): return t[0])
	ads.global_cooldown_s = 10.0
	ads.start(true)
	assert_true(ads.show_ad("double_farm", {"coins": 1}))
	assert_true(not ads.is_available("food_boost"), "global gap right after any ad")
	t[0] += 11.0
	assert_true(ads.is_available("food_boost"))
	assert_true(not ads.is_available("double_farm"), "placement cooldown (60 s) still running")
	t[0] += 50.0
	assert_true(ads.is_available("double_farm"))
	ads.shutdown()
	_clean()

func test_no_ads_without_consent_known() -> void:
	_clean()
	var save := SaveService.new(P)
	save.load_profile()
	save.profile["progress"]["highest_stage_cleared"]["1"] = 5
	var prov := MockAdProvider.new()
	var ads := AdService.new(prov, save, {"double_coins": {"enabled": true}}, 3)
	ads.start(false)
	ads.update()
	assert_true(not prov.initialized, "SDK not initialized")
	assert_eq(prov.preload_calls.size(), 0, "no ad request")
	assert_true(not ads.is_available("double_coins"))
	ads.shutdown()
	_clean()

func test_kill_during_ad_before_reward_leaves_nothing_pending() -> void:
	_clean()
	var save := SaveService.new(P)
	save.load_profile()
	save.profile["progress"]["highest_stage_cleared"]["1"] = 5
	var prov := MockAdProvider.new()
	prov.manual = true
	var ads := AdService.new(prov, save, {"double_coins": {"enabled": true}}, 3)
	ads.start(true)
	assert_true(ads.show_ad("double_coins", {"coins": 50}))
	ads.shutdown()   # the app dies with the ad on screen, before the earned callback
	var save2 := SaveService.new(P)
	save2.load_profile()
	assert_eq(save2.profile["pending_rewards"].size(), 0, "no reward without the earned callback")
	var got := []
	var ads2 := AdService.new(MockAdProvider.new(), save2, {"double_coins": {"enabled": true}}, 3)
	ads2.reward_granted.connect(func(p, r): got.append(p))
	ads2.start(true)
	assert_eq(got.size(), 0)
	ads2.shutdown()
	_clean()

func test_pending_reward_redelivered_through_game_listener() -> void:
	var g = _g()
	if g == null:
		return
	_clean()
	g.boot(P)
	g.nav = RecNav.new()
	g.save.profile["progress"]["highest_stage_cleared"]["1"] = 5
	# a bonus capsule earned right before the kill: persisted as pending, never delivered
	g.save.profile["reward_seq"] = 1
	g.save.profile["pending_rewards"].append({"id": 1, "placement": "bonus_capsule", "reward": {"capsules": 1}})
	g.save.save()
	var before: int = g.economy.get_amount("capsules")
	g.boot(P)   # "restart"
	g.nav = RecNav.new()
	g.save.profile["progress"]["highest_stage_cleared"]["1"] = 5
	g.start_services()
	g.consent.set_choice(true)   # ads start after consent: pending is delivered then
	assert_eq(g.economy.get_amount("capsules"), before + 1, "granted once after restart")
	assert_eq(g.save.profile["pending_rewards"].size(), 0)
	g.boot(P)
	assert_eq(g.economy.get_amount("capsules"), before + 1, "and never twice")
	g.boot(P)
	_clean()
