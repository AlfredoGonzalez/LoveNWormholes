extends TestCase
## Golden Pass (spec R11): every rewarded bonus is claimed without an ad through Game.claim_bonus; analytics for
## capsule_open and iap_view; Home navigates to the real Shop and Capsules screens (no can_go override).

const SAVE := "user://test_golden_save.json"


func _g():
	var ml := Engine.get_main_loop()
	if ml == null or not (ml is SceneTree) or (ml as SceneTree).root == null:
		return null
	return (ml as SceneTree).root.get_node_or_null("Game")


func _root() -> Node:
	return Engine.get_main_loop().root


func _now() -> float:
	return Time.get_unix_time_from_system()


func _fresh() -> void:
	for f in [SAVE, SAVE.get_basename() + ".bak.json", SAVE + ".tmp"]:
		DirAccess.remove_absolute(ProjectSettings.globalize_path(f))
	_g().boot(SAVE)
	Localization.set_language("en")


func _golden() -> void:
	_g()._mock_billing.owned_non_consumables = ["golden_pass"]
	_g().billing.restore()
	assert_true(_g().shop.golden_pass_active())


func _clear(upto: int) -> void:
	for s in range(1, upto + 1):
		_g().economy.settle_battle(1, s, true, 2, 1)


func _screen(script_path: String, params := {}):
	var s = (load(script_path) as GDScript).new()
	s.setup(params)
	_root().add_child(s)
	return s


func _drop(s) -> void:
	_root().remove_child(s)
	s.free()


func test_claim_bonus_without_pass_needs_an_ad() -> void:
	if _g() == null:
		return
	_fresh()
	assert_true(not _g().claim_bonus("bonus_capsule", {"capsules": 1}), "no ad ready and no pass: nothing happens")
	assert_eq(_g().economy.get_amount("capsules"), 0)


func test_claim_bonus_with_pass_grants_every_placement_once() -> void:
	if _g() == null:
		return
	_fresh()
	_golden()
	var eco: Economy = _g().economy
	var caps := eco.get_amount("capsules")
	assert_true(_g().claim_bonus("bonus_capsule", {"capsules": 1}))
	assert_eq(eco.get_amount("capsules"), caps + 1)
	assert_eq(_g().save.profile["pending_rewards"].size(), 0, "claimed and cleared")
	assert_true(not _g().quests.bonus_capsule_available(), "counted for the day")
	var coins := eco.get_amount("coins")
	assert_true(_g().claim_bonus("double_coins", {"coins": 30}))
	assert_eq(eco.get_amount("coins"), coins + 30, "double coins via the global listener")
	assert_true(not _g().claim_bonus("not_a_placement"))
	assert_eq(_g().ads.rewards_today("bonus_capsule"), 0, "no ad shown: ad caps untouched")


func test_result_and_prebattle_buttons_claim_with_pass() -> void:
	if _g() == null:
		return
	_fresh()
	_golden()
	var r = _screen("res://src/meta/result_screen.gd", {"result": "win", "era": 1, "stage": 1, "time": 90.0,
			"base_hp_fraction": 0.7, "squad": ["p1_club_worm"], "powers": []})
	assert_true(r.double_button != null and not r.double_button.disabled, "enabled although no ad is loaded")
	var coins: int = _g().economy.get_amount("coins")
	var extra: int = r._double_amount()
	r.double_button.pressed.emit()
	assert_eq(_g().economy.get_amount("coins"), coins + extra, "doubled once, no ad")
	assert_true(r._doubled)
	_drop(r)
	var l = _screen("res://src/meta/result_screen.gd", {"result": "lose", "era": 1, "stage": 2, "time": 60.0,
			"base_hp_fraction": 0.0, "squad": ["p1_club_worm"], "powers": []})
	assert_true(l.wind_button != null and not l.wind_button.disabled)
	_drop(l)
	var p = _screen("res://src/meta/pre_battle_screen.gd", {"era": 1, "stage": 1})
	assert_true(not p.boost_button.disabled)
	p.boost_button.pressed.emit()
	assert_true(p.food_boost, "food boost applied without an ad")
	_drop(p)


func test_offline_double_farm_with_pass_uses_the_extra_hours() -> void:
	if _g() == null:
		return
	_fresh()
	_golden()
	_clear(3)
	_g().save.profile["timestamps"]["offline_farm"] = _now() - 40.0 * 3600.0   # far past any cap
	var eco: Economy = _g().economy
	var extra_h: float = _g().shop.offline_extra_hours()
	assert_true(extra_h > 0.0)
	var pending := eco.offline_pending(_now(), extra_h)
	assert_true(pending > eco.offline_pending(_now()), "the pass raises the cap")
	var h = _screen("res://src/meta/home_screen.gd")
	assert_true(h.offline_popup != null)
	assert_true(not h.offline_double_button.disabled)
	var coins := eco.get_amount("coins")
	h.offline_double_button.pressed.emit()
	var paid: int = eco.get_amount("coins") - coins
	assert_true(absi(paid - pending * 2) <= pending / 100 + 2, "paid x2 of the capped amount incl. the pass hours (%d vs %d)" % [paid, pending * 2])
	_drop(h)


func test_double_farm_reward_extra_hours_in_quests() -> void:
	if _g() == null:
		return
	_fresh()
	var eco: Economy = _g().economy
	var now := _now()
	_g().save.profile["timestamps"]["offline_farm"] = now - 40.0 * 3600.0
	var pending := eco.offline_pending(now, 5.0)
	var coins := eco.get_amount("coins")
	_g().quests.apply_reward("double_farm", {"coins": pending, "multiplier": 2, "extra_hours": 5.0}, now)
	assert_eq(eco.get_amount("coins"), coins + pending * 2)


func test_capsule_open_logs_analytics() -> void:
	if _g() == null:
		return
	_fresh()
	var mock := MockAnalyticsProvider.new()
	_g().analytics.provider = mock
	_g().economy.add("capsules", 3)
	var s = _screen("res://src/meta/capsule_screen.gd")
	s.animate = false
	s.ensure_built()
	s.open(1)
	assert_eq(mock.count("capsule_open"), 1)
	s.open(2)
	assert_eq(mock.count("capsule_open"), 3, "one event per capsule")
	assert_true(mock.events[0]["params"].has("rarity") and mock.events[0]["params"].has("pity"))
	_drop(s)


func test_shop_open_logs_iap_view_not_purchase() -> void:
	if _g() == null:
		return
	_fresh()
	var mock := MockAnalyticsProvider.new()
	_g().analytics.provider = mock
	var s = _screen("res://src/meta/shop_screen.gd")
	assert_true(mock.count("iap_view") >= 1, "opening the Shop logs iap_view")
	assert_eq(mock.count("iap_view"), s.buy_buttons.size(), "one per product shown")
	var n := mock.count("iap_view")
	s.refresh()
	assert_eq(mock.count("iap_view"), n, "refreshing does not repeat it")
	_drop(s)


func test_home_navigates_to_real_shop_and_capsules() -> void:
	if _g() == null:
		return
	_fresh()
	_clear(10)
	var host := Control.new()
	_root().add_child(host)
	_g().nav.host = host   # the real Navigator, real routes: no can_go override
	var h = _screen("res://src/meta/home_screen.gd")
	for target in [["shop", "shop"], ["capsules", "capsules"]]:
		var b: Button = h.nav_buttons[target[0]]
		assert_true(not b.disabled, "%s unlocked and routable" % target[0])
		b.pressed.emit()
		assert_eq(_g().nav.current_name, target[1])
		assert_true(_g().nav.current != null and is_instance_valid(_g().nav.current))
		assert_true(_g().nav.current.get_script().get_global_name() in ["ShopScreen", "CapsuleScreen"])
		assert_true(_g().nav.go("home"), "and back")
	_drop(h)
	_root().remove_child(host)
	host.free()
