extends TestCase
## Home, World Map, offline Worm Farm popup, Daily overlay and the global ad-reward listener, with an isolated profile.
## Uses the real clock; the offline tests stay away 10 h (past the 3-8 h cap) so the pending amount is exact.

const SAVE := "user://test_home_save.json"


class RecNav extends Navigator:
	var calls: Array = []
	func can_go(n: String) -> bool:
		return n != "capsules" and n != "shop"
	func go(screen_name: String, p: Dictionary = {}) -> bool:
		calls.append([screen_name, p])
		return true


func _g():
	var ml := Engine.get_main_loop()
	if ml == null or not (ml is SceneTree) or (ml as SceneTree).root == null:
		return null
	return (ml as SceneTree).root.get_node_or_null("Game")


func _skip() -> bool:
	return _g() == null


func _root() -> Node:
	return Engine.get_main_loop().root


func _now() -> float:
	return Time.get_unix_time_from_system()


func _fresh():
	for f in [SAVE, SAVE.get_basename() + ".bak.json", SAVE + ".tmp"]:
		DirAccess.remove_absolute(ProjectSettings.globalize_path(f))
	_g().boot(SAVE)
	Localization.set_language("en")
	var n = RecNav.new()
	_g().nav = n
	return n


func _make(script_path: String, params := {}):
	var s = (load(script_path) as GDScript).new()
	s.setup(params)
	_root().add_child(s)
	return s


func _home():
	return _make("res://src/meta/home_screen.gd")


func _drop(s) -> void:
	_root().remove_child(s)
	s.free()


func _clear(upto: int) -> void:
	for s in range(1, upto + 1):
		_g().economy.settle_battle(1, s, true, 2, 1)


func _ads_ready() -> void:
	_g().ads.start(true)
	for p in ["double_farm", "bonus_capsule", "double_coins"]:
		_g()._mock_ads.set_ready(p, true)


func _away(hours := 10.0) -> void:
	_g().save.profile["timestamps"]["offline_farm"] = _now() - hours * 3600.0


func test_home_builds_and_play_goes_to_next_stage() -> void:
	if _skip():
		return
	var nav = _fresh()
	var s = _home()
	assert_true(s.play_button != null and s.settings_button != null and s.daily_button != null)
	assert_true(s.play_button.custom_minimum_size.y >= 48.0)
	assert_true(s.find_child("squirmy", true, false) != null)
	assert_true(s.find_child("shards_chip", true, false) != null)
	assert_true(s.role_chips.size() > 0, "enemy role chips")
	assert_true(s.offline_popup == null, "nothing pending on a fresh profile")
	s.play_button.pressed.emit()
	assert_eq(nav.calls[-1], ["prebattle", {"era": 1, "stage": 1}])
	_drop(s)
	_clear(3)
	var s2 = _home()
	assert_eq(int(Progress.next_stage(_g().save.profile)["stage"]), 4)
	s2.play_button.pressed.emit()
	assert_eq(nav.calls[-1], ["prebattle", {"era": 1, "stage": 4}])
	s2.settings_button.pressed.emit()
	assert_eq(nav.calls[-1][0], "settings")
	_drop(s2)


func test_nav_locked_unlocked_and_coming_soon() -> void:
	if _skip():
		return
	var nav = _fresh()
	var s = _home()
	for f in ["squad", "upgrades", "capsules", "shop"]:
		assert_true((s.nav_buttons[f] as Button).disabled, f)
		assert_eq((s.nav_notes[f] as Label).text, _g().t("ui.level_short", [Progress.feature_unlock_stage(f)]), f)
	assert_true(not (s.nav_buttons["map"] as Button).disabled)
	s.nav_buttons["map"].pressed.emit()
	assert_eq(nav.calls[-1][0], "levels")
	_drop(s)
	_clear(10)
	_g().economy.settle_battle(1, 10, true, 3, 1)
	# unlock everything by pretending later eras were cleared
	for era in range(2, 6):
		_g().save.profile["progress"]["highest_stage_cleared"][str(era)] = 10
	var s2 = _home()
	for f in ["squad", "upgrades"]:
		assert_true(not (s2.nav_buttons[f] as Button).disabled, f)
	s2.nav_buttons["squad"].pressed.emit()
	assert_eq(nav.calls[-1][0], "squad")
	s2.nav_buttons["upgrades"].pressed.emit()
	assert_eq(nav.calls[-1][0], "upgrades")
	for f in ["capsules", "shop"]:
		assert_true((s2.nav_buttons[f] as Button).disabled, f)
		assert_eq((s2.nav_notes[f] as Label).text, _g().t("meta.coming_soon"), f)
	_drop(s2)


func test_alert_dots() -> void:
	if _skip():
		return
	_fresh()
	_clear(Progress.feature_unlock_stage("upgrades"))
	_g().save.profile["currencies"]["coins"] = 0
	var s = _home()
	assert_true(not s.has_alert("upgrades"), "no coins to upgrade")
	assert_true(s.daily_badge.visible, "daily claimable")
	_drop(s)
	_g().economy.add("coins", 100000)
	var s2 = _home()
	assert_true(s2.has_alert("upgrades"), "affordable upgrade")
	_drop(s2)


func test_offline_popup_only_with_pending_and_claim_pays_once() -> void:
	if _skip():
		return
	_fresh()
	var s0 = _home()
	assert_true(s0.offline_popup == null)
	_drop(s0)
	var t0 := _now()
	_away()
	var eco: Economy = _g().economy
	var pending := eco.offline_pending(_now())
	assert_true(pending > 0)
	var s = _home()
	assert_true(s.offline_popup != null, "popup shown")
	assert_true(s.offline_claim_button.text.contains(str(pending)))
	var coins := eco.get_amount("coins")
	s.offline_claim_button.pressed.emit()
	assert_eq(eco.get_amount("coins"), coins + pending, "paid exactly once")
	assert_true(s.offline_popup == null, "popup closed")
	assert_eq(eco.offline_pending(_now()), 0)
	_drop(s)
	var s2 = _home()
	assert_true(s2.offline_popup == null, "nothing pending right after claiming")
	assert_true(float(_g().save.profile["timestamps"]["last_seen"]) >= t0, "last_seen updated")
	_drop(s2)


func test_double_farm_pays_once_and_never_blocks() -> void:
	if _skip():
		return
	_fresh()
	_clear(3)   # ads unlock after stage 3
	_away()
	var eco: Economy = _g().economy
	var pending := eco.offline_pending(_now())
	var s = _home()
	# no ad ready: disabled with "not available", Claim still works
	assert_true((s.offline_double_button as Button).disabled)
	assert_true(s.offline_double_button.text.contains(_g().t("ui.not_available")))
	assert_true(not s.offline_claim_button.disabled)
	_ads_ready()
	_g()._mock_ads.manual = true
	_g().ads.availability_changed.emit("double_farm")
	assert_true(not (s.offline_double_button as Button).disabled)
	var coins := eco.get_amount("coins")
	s.offline_double_button.pressed.emit()
	assert_eq(eco.get_amount("coins"), coins, "no reward before the ad finishes")
	_g()._mock_ads.finish_reward()
	assert_eq(eco.get_amount("coins"), coins + pending * 2, "double paid once")
	assert_true(s.offline_popup == null)
	_g()._mock_ads.close_ad()
	assert_eq(eco.get_amount("coins"), coins + pending * 2, "still once")
	assert_eq(_g().save.profile["pending_rewards"].size(), 0)
	_drop(s)


func test_double_farm_redelivered_after_kill_is_applied_once() -> void:
	if _skip():
		return
	_fresh()
	_clear(3)
	_ads_ready()
	var coins: int = _g().economy.get_amount("coins")
	# the app died between the reward callback and delivery: the entry is pending in the save
	_g().save.profile["reward_seq"] = 1
	_g().save.profile["pending_rewards"].append({"id": 1, "placement": "double_farm", "reward": {"coins": 40, "multiplier": 2}})
	_g().ads.deliver_pending()
	_g().ads.deliver_pending()
	assert_eq(_g().economy.get_amount("coins"), coins + 40, "no farm pending: only the extra is paid, once")


func test_double_coins_redelivery_not_doubled_by_result_screen() -> void:
	if _skip():
		return
	_fresh()
	_clear(3)
	_ads_ready()
	var eco: Economy = _g().economy
	# no result screen open: the global listener applies the re-delivered reward once
	var coins := eco.get_amount("coins")
	_g().save.profile["reward_seq"] = 1
	_g().save.profile["pending_rewards"].append({"id": 1, "placement": "double_coins", "reward": {"coins": 25, "multiplier": 2}})
	_g().ads.deliver_pending()
	assert_eq(eco.get_amount("coins"), coins + 25)
	# a result screen is listening: it applies it, the global listener stays out
	var r = _make("res://src/meta/result_screen.gd", {"result": "win", "era": 1, "stage": 4, "stats": {"units_spawned": 3, "powers_used": 1}})
	var after_settle := eco.get_amount("coins")
	_g().save.profile["reward_seq"] = 2
	_g().save.profile["pending_rewards"].append({"id": 2, "placement": "double_coins", "reward": {"coins": 25, "multiplier": 2}})
	_g().ads.deliver_pending()
	assert_eq(eco.get_amount("coins"), after_settle + 25, "applied once, by the screen")
	assert_eq(int(_g().save.profile["stats"]["units_spawned"]), 3, "result hook records battle stats once")
	_drop(r)


func test_daily_overlay_claims_login_and_quests_once() -> void:
	if _skip():
		return
	_fresh()
	var eco: Economy = _g().economy
	var s = _home()
	assert_true(s.daily_overlay == null)
	s.daily_button.pressed.emit()
	assert_true(s.daily_overlay != null)
	assert_true(s.login_claim_button != null and not s.login_claim_button.disabled)
	var caps := eco.get_amount("capsules")
	var gems := eco.get_amount("gems")
	s.login_claim_button.pressed.emit()
	s.login_claim_button.pressed.emit()
	assert_eq(eco.get_amount("capsules"), caps + DataDB.bal_i("daily.login_capsules", 1))
	assert_eq(eco.get_amount("gems"), gems + DataDB.bal_i("daily.login_gems", 10))
	assert_true(not eco.can_claim_daily(_now()))
	s._rebuild_daily()   # normally a deferred call
	assert_true(s.login_claim_button == null, "login button gone after claiming")
	# quests: 3 shown, claim disabled until complete
	assert_eq(s.quest_claim_buttons.size(), mini(3, DataDB.quests().size()))
	for id in s.quest_claim_buttons:
		assert_true((s.quest_claim_buttons[id] as Button).disabled, id)
	var id0 := str(s.quest_claim_buttons.keys()[0])
	var def := Quests.quest_def(id0)
	_g().quests.record(str(def["event"]), int(def["target"]))
	assert_true(not (s.quest_claim_buttons[id0] as Button).disabled)
	var coins := eco.get_amount("coins")
	s.quest_claim_buttons[id0].pressed.emit()
	assert_eq(eco.get_amount("coins"), coins + int(def["reward"]["coins"]))
	assert_true((s.quest_claim_buttons[id0] as Button).disabled, "claimed")
	s.quest_claim_buttons[id0].pressed.emit()
	assert_eq(eco.get_amount("coins"), coins + int(def["reward"]["coins"]), "claimed once")
	s.close_daily()
	assert_true(s.daily_overlay == null)
	_drop(s)


func test_bonus_capsule_once_per_day() -> void:
	if _skip():
		return
	_fresh()
	_clear(3)
	_ads_ready()
	var eco: Economy = _g().economy
	var s = _home()
	s.open_daily()
	assert_true(not (s.bonus_button as Button).disabled)
	var caps := eco.get_amount("capsules")
	s.bonus_button.pressed.emit()
	assert_eq(eco.get_amount("capsules"), caps + 1)
	assert_true((s.bonus_button as Button).disabled, "max 1 per day")
	assert_true(not _g().quests.bonus_capsule_available())
	_drop(s)


func test_world_map_era_locking_and_texts() -> void:
	if _skip():
		return
	var nav = _fresh()
	var s = _make("res://src/meta/level_select_screen.gd")
	assert_true(s.back_button != null)
	s.back_button.pressed.emit()
	assert_eq(nav.calls[-1][0], "home")
	assert_eq(s.era_buttons.size(), 5)
	assert_true(s.echo_hint != null)
	assert_true(s.find_child("echo_marker", true, false) != null, "echo marker on stage 5")
	s.era_buttons[2].pressed.emit()
	assert_true(s.find_child("era_locked_note", true, false) != null, "era 2 locked at start")
	assert_eq(s.stage_buttons.size(), 0)
	_drop(s)
	_clear(10)   # Era 1 boss cleared: Era 2 unlocks (an empty note if its stage data is not there yet)
	var s2 = _make("res://src/meta/level_select_screen.gd")
	s2.era_buttons[2].pressed.emit()
	assert_true(s2.find_child("era_locked_note", true, false) == null, "era 2 unlocked")
	if DataDB.stages_of_era(2).is_empty():
		assert_true(s2.find_child("era_empty_note", true, false) != null)
		assert_eq((s2.find_child("era_empty_note", true, false) as Label).text, _g().t("map.era_empty"))
	else:
		assert_eq(s2.stage_buttons.size(), DataDB.stages_of_era(2).size())
	s2.era_buttons[3].pressed.emit()
	assert_true(s2.find_child("era_locked_note", true, false) != null, "era 3 still locked")
	s2.era_buttons[1].pressed.emit()
	assert_eq(s2.stage_buttons.size(), 10)
	_drop(s2)


func test_title_goes_home_and_spanish_builds() -> void:
	if _skip():
		return
	var nav = _fresh()
	_g().save.profile["consent"]["state"] = "granted"
	Story.mark_seen(_g().save.profile, "intro")   # the intro comic plays once before Home (test_story covers it)
	var t = _make("res://src/meta/title_screen.gd")
	t.play_button.pressed.emit()
	assert_eq(nav.calls[-1][0], "home")
	_drop(t)
	Localization.set_language("es")
	_clear(3)
	_away()
	var s = _home()
	assert_true(s.offline_popup != null)
	s.open_daily()
	assert_true(s.daily_overlay != null)
	_drop(s)
	_drop(_make("res://src/meta/level_select_screen.gd"))
	Localization.set_language("en")


# ------------------------------------------------------------------ sliding Home (camera, parallax, fallback)

func test_camera_limits_and_layer_factors() -> void:
	var c := HomeCamera.new(1000.0, 60.0)
	c.begin_drag()
	c.drag_move(-5000.0)            # finger far left: camera pushed to the right limit (+ overscroll)
	assert_true(c.x <= 1000.0 + 60.0 + 0.001 and c.x > 1000.0)
	c.end_drag()
	for i in 240:
		c.step(1.0 / 60.0)
	assert_near(c.x, 1000.0, 0.01, "springs back to the right edge")
	c.x = 400.0
	assert_near(c.layer_x(1.0), -460.0)
	assert_near(c.layer_x(0.5), -230.0)
	assert_near(c.layer_x(0.1), -46.0)
	assert_true(c.layer_x(0.1) > c.layer_x(0.25) and c.layer_x(0.25) > c.layer_x(0.5) and c.layer_x(0.5) > c.layer_x(1.0), "far layers move less")


func test_camera_inertia_is_deterministic_and_stops() -> void:
	var runs := []
	for k in 2:
		var c := HomeCamera.new(2000.0, 60.0)
		c.x = 500.0
		c.begin_drag()
		for i in 6:
			c.drag_move(-10.0)       # 600 px/s to the right, at 60 Hz
			c.step(1.0 / 60.0)
		c.end_drag()
		var v0 := c.vel
		assert_true(v0 > 300.0, "release velocity")
		var prev := c.x
		for i in 600:
			c.step(1.0 / 60.0)
		assert_true(c.x > prev + 20.0, "kept moving after release")
		assert_eq(c.vel, 0.0, "inertia decays to a stop")
		runs.append(c.x)
	assert_eq(runs[0], runs[1], "same input, same result")


func test_home_parallax_scene_layers_and_drag() -> void:
	if _skip():
		return
	_fresh()
	var s = _home()
	if s.cam == null:
		_drop(s)
		return   # art missing in this checkout: the fallback test covers it
	assert_true(s.world_width >= 3.0 * 540.0 * 0.95, "world is about 3 screens wide")
	assert_near(s.cam.max_x, s.world_width - 540.0, 0.01)
	for id in s.LAYER_IDS:
		var r: Control = s.layers[id]
		var f: float = s.LAYER_FACTORS[id]
		# no gaps at either extreme of the camera (overscroll included)
		for cx in [-s.OVERSCROLL, s.cam.max_x + s.OVERSCROLL]:
			s.cam.x = cx
			s.apply_camera()
			assert_true(r.position.x <= 0.01 and r.position.x + r.size.x >= 540.0 - 0.01, "%s covers the screen at cam %s" % [id, cx])
		assert_true(r.size.y >= 960.0 - 0.01 and f > 0.0)
	s.cam.x = 200.0
	s.apply_camera()
	assert_near(s.layers["home_ground"].position.x, -(200.0 + s.OVERSCROLL), 0.01)
	assert_near(s.layers["home_far"].position.x, -(200.0 + s.OVERSCROLL) * 0.25, 0.01)
	assert_true(s.layers["home_ground"].find_child("squirmy", false, false) != null, "Squirmy rides the ground layer")
	assert_true(s.layers["home_ground"].find_child("burrow", false, false) != null)
	var root: Node = s.layers["home_front"].get_parent()
	assert_true(root.get_child_count() > 0 and root.get_child(root.get_child_count() - 1) == s.layers["home_front"], "front is drawn last")
	# drag: below the threshold nothing moves; above it the world follows the finger
	s._hint_done = true
	s.cam.x = 300.0
	var press := InputEventMouseButton.new()
	press.button_index = MOUSE_BUTTON_LEFT
	press.pressed = true
	press.position = Vector2(200, 300)
	s._on_drag_input(press)
	var mv := InputEventMouseMotion.new()
	mv.position = Vector2(204, 300)
	mv.relative = Vector2(4, 0)
	s._on_drag_input(mv)
	assert_true(not s.cam.dragging and s.cam.x == 300.0, "under the threshold is a tap")
	mv = InputEventMouseMotion.new()
	mv.position = Vector2(230, 300)
	mv.relative = Vector2(26, 0)
	s._on_drag_input(mv)
	assert_true(s.cam.dragging)
	assert_near(s.cam.x, 270.0, 0.01, "finger right 30 px -> camera left 30 px")
	var rel := InputEventMouseButton.new()
	rel.button_index = MOUSE_BUTTON_LEFT
	rel.pressed = false
	s._on_drag_input(rel)
	assert_true(not s.cam.dragging)
	s._process(1.0 / 60.0)
	_drop(s)


func test_home_fallback_without_layer_art() -> void:
	if _skip():
		return
	_fresh()
	var entries := {}
	for id in SpriteManifest.ids():
		if id != "home_ground":
			entries[id] = SpriteManifest.get_entry(id)
	SpriteManifest.set_entries(entries)
	var s = _home()
	assert_true(s.cam == null and s.layers.is_empty(), "no parallax without the art")
	assert_true(s.find_child("squirmy", true, false) != null and s.find_child("burrow", true, false) != null, "legacy scene kept")
	assert_true(s.play_button != null)
	s._process(0.016)   # must not fail
	_drop(s)
	SpriteManifest.reset()
