extends TestCase
## Menu-flow screens (title, levels, prebattle, result) with an isolated profile.

const SAVE := "user://test_meta_save.json"


class RecNav extends Navigator:
	var calls: Array = []
	func can_go(_n: String) -> bool:
		return true
	func go(screen_name: String, p: Dictionary = {}) -> bool:
		calls.append([screen_name, p])
		return true


## Autoloads are not registered while tools/run_tests.gd runs inside _init(), so without them these tests
## skip themselves (they compile anywhere and run when the runner starts after the autoloads exist).
func _g():
	var ml := Engine.get_main_loop()
	if ml == null or not (ml is SceneTree) or (ml as SceneTree).root == null:
		return null
	return (ml as SceneTree).root.get_node_or_null("Game")


func _skip() -> bool:
	return _g() == null


func _root() -> Node:
	return Engine.get_main_loop().root


func _fresh():
	for f in [SAVE, SAVE.get_basename() + ".bak.json", SAVE + ".tmp"]:
		DirAccess.remove_absolute(ProjectSettings.globalize_path(f))
	_g().boot(SAVE)
	Localization.set_language("en")
	var n = RecNav.new()
	_g().nav = n
	return n


## Clears stage `n` (era 1) in the profile, as if the player had won it.
func _clear(upto: int) -> void:
	for s in range(1, upto + 1):
		_g().economy.settle_battle(1, s, true, 2, 1)


func _make(script_path: String, params := {}):
	var s = (load(script_path) as GDScript).new()
	s.setup(params)
	_root().add_child(s)
	return s


func _drop(s) -> void:
	_root().remove_child(s)
	s.free()


func _ready_ads(placement := "food_boost") -> void:
	_g().ads.start(true)
	for p in ["food_boost", "double_coins", "second_wind"]:
		_g()._mock_ads.set_ready(p, true)


func test_title_builds_and_navigates() -> void:
	if _skip():
		return
	var nav = _fresh()
	var s = _make("res://src/meta/title_screen.gd")
	assert_true(s.play_button != null and s.lang_button != null and s.settings_button != null)
	assert_true(s.play_button.size.y >= 0.0 and s.play_button.custom_minimum_size.y >= 48.0)
	s.settings_button.pressed.emit()
	assert_eq(nav.calls[0][0], "settings")
	# language toggle persists
	var before = Localization.get_language()
	s.lang_button.pressed.emit()
	assert_true(Localization.get_language() != before)
	assert_eq(_g().save.profile["settings"]["language"], Localization.get_language())
	Localization.set_language("en")
	_drop(s)


func test_title_consent_once() -> void:
	if _skip():
		return
	var nav = _fresh()
	var s = _make("res://src/meta/title_screen.gd")
	assert_eq(_g().save.profile["consent"]["state"], "unknown")
	s.play_button.pressed.emit()
	assert_eq(nav.calls[0][0], "consent", "unknown consent routes to the consent screen first")
	assert_eq(nav.calls[0][1]["next"], "story", "first run: the intro comic comes after consent")
	assert_eq(nav.calls[0][1]["next_params"]["seq"], "intro")
	_g().consent.set_choice(true)
	assert_eq(_g().save.profile["consent"]["state"], "accepted")
	Story.mark_seen(_g().save.profile, "intro")
	s.play_button.pressed.emit()
	assert_eq(nav.calls[1][0], "home", "consent is asked only once")
	_drop(s)


func test_levels_fresh_profile() -> void:
	if _skip():
		return
	var nav = _fresh()
	var s = _make("res://src/meta/level_select_screen.gd")
	assert_eq(s.selected_era, 1)
	assert_eq(s.stage_buttons.size(), 10)
	assert_true(not (s.stage_buttons[1] as Button).disabled)
	assert_true((s.stage_buttons[2] as Button).disabled, "stage 2 locked at start")
	s.back_button.pressed.emit()
	assert_eq(nav.calls[-1][0], "home")
	s.stage_buttons[1].pressed.emit()
	assert_eq(nav.calls[-1], ["prebattle", {"era": 1, "stage": 1}])
	# era 2 tab is locked and says why
	s.era_buttons[2].pressed.emit()
	assert_true(s.find_child("era_locked_note", true, false) != null)
	assert_eq((s.find_child("era_locked_note", true, false) as Label).text, _g().t("map.locked_era", [1]))
	assert_eq(s.stage_buttons.size(), 0)
	_drop(s)


func test_levels_progress_unlocks() -> void:
	if _skip():
		return
	var nav = _fresh()
	var up = Progress.feature_unlock_stage("upgrades")
	_clear(up)
	_g().economy.settle_battle(1, 1, true, 3, 1)
	var s = _make("res://src/meta/level_select_screen.gd")
	var p: Dictionary = _g().save.profile
	for i in range(1, 11):
		var expect_open = Progress.is_stage_unlocked(p, 1, i)
		assert_eq(not (s.stage_buttons[i] as Button).disabled, expect_open, "stage %d" % i)
	s.stage_buttons[2].pressed.emit()
	assert_eq(nav.calls[-1], ["prebattle", {"era": 1, "stage": 2}])
	_drop(s)


func test_prebattle_builds_and_starts() -> void:
	if _skip():
		return
	var nav = _fresh()
	var s = _make("res://src/meta/pre_battle_screen.gd", {"era": 1, "stage": 3})
	assert_eq(s.squad.size(), 3, "fresh profile: the Era-1 trio (no other unit is unlocked)")
	assert_eq(s.squad, Squad.active(_g().save.profile))
	assert_eq(s.powers, ["squirm_slam", "apple_rain"])
	assert_eq(s.slot_notes.size(), 2, "locked squad slot 5 and the locked third power slot")
	assert_eq((s.slot_notes[0] as Label).text, _g().t("ui.unlocks_boss", [2]))
	assert_eq((s.slot_notes[1] as Label).text, _g().t("ui.unlocks_boss", [3]))
	assert_eq(s.empty_slots.size(), 1, "slot 4 is open but empty")
	var mix = (load("res://src/meta/pre_battle_screen.gd") as GDScript).scout_mix(DataDB.stage(1, 3))
	var expected := {}
	for w in DataDB.stage(1, 3)["waves"]:
		var role := str(DataDB.enemy(str(w["enemy"]))["role"])
		expected[role] = int(expected.get(role, 0)) + int(w["count"])
	for role in expected:
		assert_eq(mix.get(role, 0), expected[role], "scout report counts %s from the waves" % role)
	assert_true(s.boost_button.disabled, "no ads before stage 3 is cleared")
	assert_true(s.boost_button.text.contains(_g().t("ui.not_available")))
	s.start_button.pressed.emit()
	var c: Array = nav.calls[-1]
	assert_eq(c[0], "battle")
	assert_eq(c[1]["era"], 1)
	assert_eq(c[1]["stage"], 3)
	assert_eq(c[1]["food_boost"], false)
	assert_eq(c[1]["squad"].size(), 3)
	s.back_button.pressed.emit()
	assert_eq(nav.calls[-1][0], "home")
	_drop(s)


func test_prebattle_boss_name_and_food_boost_ad() -> void:
	if _skip():
		return
	var nav = _fresh()
	_clear(3)
	_ready_ads()
	var s = _make("res://src/meta/pre_battle_screen.gd", {"era": 1, "stage": 10})
	var bn: Label = s.find_child("boss_name", true, false)
	assert_true(bn != null and bn.text.contains("Rexy"), "boss stage shows the boss name")
	assert_true(not s.boost_button.disabled, "ad available after stage 3")
	assert_true(s.boost_button.text.contains("30%"), "reward stated before the tap")
	assert_true(not s.food_boost)
	s.boost_button.pressed.emit()
	assert_true(s.food_boost, "flipped from reward_granted")
	assert_true(s.boost_button.disabled)
	s.start_button.pressed.emit()
	assert_eq(nav.calls[-1][1]["food_boost"], true)
	_drop(s)


func test_result_win_settles_once() -> void:
	if _skip():
		return
	var nav = _fresh()
	var coins0 = _g().economy.get_amount("coins")
	var gems0 = _g().economy.get_amount("gems")
	var params = {"result": "win", "era": 1, "stage": 1, "stats": {}, "time": 75.0, "base_hp_fraction": 0.9}
	var s = _make("res://src/meta/result_screen.gd", params)
	var expected = _g().economy.win_reward(1) * 2
	assert_eq(_g().economy.get_amount("coins"), coins0 + expected)
	assert_eq(_g().economy.get_amount("gems"), gems0 + 5)
	assert_eq(s.stars, 3)
	assert_eq(Progress.stage_stars(_g().save.profile, 1, 1), 3)
	assert_true(s.find_child("first_clear_note", true, false) != null)
	_drop(s)
	# re-created with the same params: no second payment
	var s2 = _make("res://src/meta/result_screen.gd", params)
	assert_eq(_g().economy.get_amount("coins"), coins0 + expected, "re-created screen does not pay again")
	s2.home_button.pressed.emit()
	assert_eq(nav.calls[-1][0], "home")
	s2.next_button.pressed.emit()
	assert_eq(nav.calls[-1], ["prebattle", {"era": 1, "stage": 2}])
	assert_eq(_g().economy.get_amount("coins"), coins0 + expected, "buttons never pay")
	_drop(s2)


func test_result_double_coins_once() -> void:
	if _skip():
		return
	_fresh()
	_clear(3)
	_ready_ads()
	var coins0 = _g().economy.get_amount("coins")
	var s = _make("res://src/meta/result_screen.gd",
			{"result": "win", "era": 1, "stage": 3, "time": 10.0, "base_hp_fraction": 0.6})
	var base = _g().economy.win_reward(3)
	assert_eq(_g().economy.get_amount("coins"), coins0 + base, "repeat clear pays the plain win reward")
	assert_eq(s.stars, 2)
	assert_true(not s.double_button.disabled)
	s.double_button.pressed.emit()
	assert_eq(_g().economy.get_amount("coins"), coins0 + base * 2)
	assert_eq(s.coins_shown, base * 2)
	s.double_button.pressed.emit()
	assert_eq(_g().economy.get_amount("coins"), coins0 + base * 2, "double coins pays once")
	_drop(s)


func test_result_defeat_underdog_and_second_wind() -> void:
	if _skip():
		return
	var nav = _fresh()
	_clear(3)
	_ready_ads()
	var coins0 = _g().economy.get_amount("coins")
	var squad = ["p1_club_worm", "p1_slinger_worm"]
	var params = {"result": "lose", "era": 1, "stage": 4, "time": 50.0, "base_hp_fraction": 0.0,
			"squad": squad, "powers": ["squirm_slam"]}
	# Underdog (spec 6.4, literal reading): the first stack exists after the 3rd consecutive loss,
	# so two losses are settled here and the result screen settles the third.
	_g().economy.settle_battle(1, 4, false)
	_g().economy.settle_battle(1, 4, false)
	var s = _make("res://src/meta/result_screen.gd", params)
	assert_eq(_g().economy.get_amount("coins"), coins0 + _g().economy.loss_reward(4) * 3)
	assert_eq(_g().economy.loss_streak(1, 4), 3)
	assert_eq(s.stars, 0)
	assert_true(_g().economy.underdog(1, 4)["stacks"] >= 1)
	assert_true(s.find_child("underdog_panel", true, false) != null)
	assert_true(not s.wind_button.disabled and s.wind_button.text.contains("25%"))
	s.retry_button.pressed.emit()
	assert_eq(nav.calls[-1][0], "battle")
	assert_eq(nav.calls[-1][1]["squad"], squad)
	assert_true(not nav.calls[-1][1].has("resume"))
	s.change_squad_button.pressed.emit()
	assert_eq(nav.calls[-1], ["prebattle", {"era": 1, "stage": 4}])
	s.wind_button.pressed.emit()
	assert_eq(nav.calls[-1][0], "battle")
	assert_eq(nav.calls[-1][1]["resume"], true)
	assert_eq(nav.calls[-1][1]["powers"], ["squirm_slam"])
	var n = nav.calls.size()
	s.wind_button.pressed.emit()
	assert_eq(nav.calls.size(), n, "second wind only once per battle")
	assert_eq(_g().economy.loss_streak(1, 4), 2, "second wind took this defeat's streak back")
	assert_eq(_g().economy.get_amount("coins"), coins0 + _g().economy.loss_reward(4) * 2, "and its mercy coins")
	_drop(s)


func test_second_wind_pays_once_then_the_final_result() -> void:
	if _skip():
		return
	var nav = _fresh()
	_clear(3)
	_ready_ads()
	var coins0 = _g().economy.get_amount("coins")
	var params = {"result": "lose", "era": 1, "stage": 4, "time": 50.0, "base_hp_fraction": 0.0,
			"stats": {"kills": 7, "units_spawned": 9, "powers_used": 2}}
	var s = _make("res://src/meta/result_screen.gd", params)
	assert_eq(_g().economy.get_amount("coins"), coins0 + _g().economy.loss_reward(4))
	assert_true(s.stats_row != null and s.stats_row.get_child_count() == 4, "kills, units, powers, time")
	s.wind_button.pressed.emit()
	assert_eq(_g().economy.get_amount("coins"), coins0, "loss settlement undone")
	assert_eq(_g().economy.loss_streak(1, 4), 0)
	# Re-entering the same result screen must not revert (or pay) again.
	_drop(s)
	var s_again = _make("res://src/meta/result_screen.gd", params)
	assert_true(s_again.wind_button.disabled, "second wind spent")
	s_again.wind_button.pressed.emit()
	assert_eq(_g().economy.get_amount("coins"), coins0, "no second revert, no payment")
	_drop(s_again)
	# The resumed battle is won: only the win pays.
	var win = {"result": "win", "era": 1, "stage": 4, "time": 90.0, "base_hp_fraction": 0.5, "second_wind_used": true}
	var w = _make("res://src/meta/result_screen.gd", win)
	assert_eq(_g().economy.get_amount("coins"), coins0 + _g().economy.win_reward(4) * 2, "first clear win paid once")
	_drop(w)
	# A resumed battle that is lost again offers no second Second Wind.
	var lose2 = {"result": "lose", "era": 1, "stage": 5, "second_wind_used": true}
	var l = _make("res://src/meta/result_screen.gd", lose2)
	assert_true(l.wind_button.disabled)
	_drop(l)


func test_result_chips_follow_double_coins() -> void:
	if _skip():
		return
	_fresh()
	_clear(3)
	_ready_ads()
	var s = _make("res://src/meta/result_screen.gd", {"result": "win", "era": 1, "stage": 3, "time": 10.0, "base_hp_fraction": 0.6})
	var before = _g().economy.get_amount("coins")
	s.double_button.pressed.emit()
	var chip = s.find_child("chip_coins", true, false)
	assert_true(chip != null)
	var txt := ""
	for c in chip.get_children():
		if c is Label:
			txt = c.text
	assert_true(txt.contains(str(_g().economy.get_amount("coins"))), "chip shows the new wallet: " + txt)
	assert_true(_g().economy.get_amount("coins") > before)
	_drop(s)


func test_result_defeat_without_ads_never_blocks() -> void:
	if _skip():
		return
	var nav = _fresh()
	var s = _make("res://src/meta/result_screen.gd", {"result": "lose", "era": 1, "stage": 1})
	assert_true(s.wind_button.disabled)
	assert_true(s.wind_button.text.contains(_g().t("ui.not_available")))
	s.retry_button.pressed.emit()
	assert_eq(nav.calls[-1][1]["squad"].size(), 3, "defaults when no squad given")
	_drop(s)


func test_spanish_builds() -> void:
	if _skip():
		return
	_fresh()
	Localization.set_language("es")
	for path in ["res://src/meta/title_screen.gd", "res://src/meta/level_select_screen.gd"]:
		var s = _make(path)
		assert_true(s.get_child_count() > 0)
		_drop(s)
	var p = _make("res://src/meta/pre_battle_screen.gd", {"era": 1, "stage": 1})
	_drop(p)
	var r = _make("res://src/meta/result_screen.gd", {"result": "lose", "era": 1, "stage": 1})
	_drop(r)
	Localization.set_language("en")
