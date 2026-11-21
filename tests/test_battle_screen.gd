extends TestCase
## BattleScreen: layout, fixed-timestep driving, pause, a whole scripted stage 1, Second Wind.
## The screen is added to the real tree but driven through step(), no frame loop is needed.

const SAVE := "user://test_battle_save.json"
const SQUAD := ["p1_club_worm", "p1_slinger_worm"]
const POWERS := ["squirm_slam", "apple_rain"]

## NOTE: these tests need the `Game` autoload and a live SceneTree. Autoload names do not exist yet while
## tools/run_tests.gd runs in SceneTree._init(), so everything here is looked up at run time (no static
## `Game` / `BattleScreen` identifiers) and the tests skip themselves (with a printed note) when the
## environment is not there. They run for real once the runner executes from _initialize().

var _skip_noted := false


func _tree_root() -> Node:
	var loop := Engine.get_main_loop()
	if loop is SceneTree:
		return (loop as SceneTree).root
	return null


func _game() -> Node:
	var r := _tree_root()
	return r.get_node_or_null("Game") if r != null else null


func _env_ok() -> bool:
	if _game() != null:
		return true
	if not _skip_noted:
		_skip_noted = true
		print("       (test_battle_screen skipped: no Game autoload / SceneTree yet, run the runner from _initialize)")
	return false


func _fresh_game() -> void:
	var g = _game()
	g.boot(SAVE)
	g.save.delete_all()   # main file, backup and tmp: always start from the default profile
	g.boot(SAVE)
	g.last_sim = null


func _make(extra := {}):
	var p := {"era": 1, "stage": 1, "squad": SQUAD, "powers": POWERS, "food_boost": false, "resume": false}
	p.merge(extra, true)
	var script: GDScript = load("res://src/battle/battle_screen.gd")
	var s = script.new()
	s.setup(p)
	_tree_root().add_child(s)
	return s


func _drop(s) -> void:
	if s.get_parent() != null:
		s.get_parent().remove_child(s)
	s.free()


func _events() -> Array:
	return (_game().analytics.provider as MockAnalyticsProvider).names()


func test_layout_and_touch_targets() -> void:
	if not _env_ok():
		return
	_fresh_game()
	var s = _make()
	assert_true(s.sim != null)
	assert_eq(s.hud.cards.size(), 2, "one card per squad unit")
	assert_eq(s.hud.power_buttons.size(), 2)
	var all: Array = []
	all.append_array(s.hud.cards)
	all.append_array(s.hud.power_buttons)
	all.append(s.hud.pause_button)
	all.append(s.hud.speed_button)
	for b in all:
		assert_true(b.size.x >= 48.0 and b.size.y >= 48.0, "touch target >= 48 px: %s" % b.name)
	var lane_bottom: float = s.LANE_Y
	assert_true(absf(lane_bottom / s.SCREEN_H - 0.58) < 0.01, "lane at ~58% of the height")
	for c in s.hud.cards:
		assert_true(c.position.y >= s.SCREEN_H * 0.7 - 1.0, "cards in the bottom 30%")
	assert_true(s.hud.power_buttons[0].position.x < 100.0, "left power in the lower left corner")
	assert_true(s.hud.power_buttons[1].position.x + s.hud.power_buttons[1].size.x > 440.0, "right power in the lower right corner")
	assert_eq(_events().count("stage_start"), 1)
	_drop(s)


func test_fixed_timestep_and_speed() -> void:
	if not _env_ok():
		return
	_fresh_game()
	var s = _make()
	var dt: float = s.sim.dt
	s.step(dt * 3.0 + 0.001)
	assert_eq(s.sim.tick_count, 3, "three ticks for three dt")
	s.step(1.0)   # clamped to 0.25 s and to max_catchup_ticks per frame
	assert_true(s.sim.tick_count <= 3 + DataDB.bal_i("sim.max_catchup_ticks"), "catch-up guard")
	var t0: int = s.sim.tick_count
	s.speed = 2
	s.step(dt * 2.0 + 0.001)
	assert_eq(s.sim.tick_count - t0, 4, "x2 speed doubles the ticks")
	s.toggle_speed()
	assert_eq(s.speed, 1)
	assert_eq(int(_game().save.profile["settings"]["battle_speed"]), 1, "speed saved in the profile")
	s.toggle_speed()
	_drop(s)
	var s2 = _make()
	assert_eq(s2.speed, 2, "speed remembered between battles")
	_drop(s2)


func test_cards_and_powers() -> void:
	if not _env_ok():
		return
	_fresh_game()
	var s = _make()
	s.step(0.1)
	var food0: float = s.sim.food
	assert_true(s.press_card(0), "spawn card 0")
	assert_true(s.sim.food < food0)
	assert_eq(s.unit_views.size(), 1, "a view per sim unit")
	assert_true(not s.press_card(0), "cooling down")
	assert_eq(s.hud.cards[0].current_state(), "wait")
	assert_true(not s.press_power(0), "squirm slam needs a target")
	assert_true(s.press_power(1), "apple rain works anywhere")
	assert_eq(s.hud.power_buttons[1].current_state(), "wait")
	assert_eq(_events().count("power_used"), 1)
	assert_true(s.effects.count() > 0 or s.effects._rain_t > 0.0, "power visuals")
	_drop(s)


func test_pause_stops_time() -> void:
	if not _env_ok():
		return
	_fresh_game()
	var s = _make()
	s.step(0.5)
	var t: float = s.sim.time
	s.pause()
	assert_true(s.is_paused())
	assert_true(s.overlay != null and s.overlay.is_inside_tree())
	s.step(1.0)
	s.step(1.0)
	assert_near(s.sim.time, t, 0.00001, "no time while paused")
	assert_true(not s.press_card(0), "no input while paused")
	s.resume_play()
	assert_true(not s.is_paused())
	s.step(0.2)
	assert_true(s.sim.time > t, "time flows again")
	s.pause()
	s.overlay.music_button.pressed.emit()
	assert_true(not s.overlay.music_on(), "music toggle")
	s.overlay.music_button.pressed.emit()
	assert_true(s.overlay.music_on())
	_drop(s)


func _play_stage(s, seconds: float) -> void:
	var frame := 1.0 / 60.0
	var t := 0.0
	var n := 0
	while t < seconds and not s.finished:
		for i in s.sim.cards.size():
			s.press_card(i)
		for i in s.sim.powers.size():
			if s.sim.power_ready(i) and s.sim.time > 20.0:
				s.press_power(i)
		s.step(frame)
		t += frame
		n += 1
		if n % 30 == 0:
			assert_true(s.unit_views.size() <= s.sim.units.size() + 1, "views follow the sim")


func test_whole_stage_one_scripted() -> void:
	if not _env_ok():
		return
	_fresh_game()
	var s = _make()
	s.speed = 2
	var got: Array = []
	s.battle_finished.connect(func(p): got.append(p))
	_play_stage(s, 400.0)
	assert_true(s.finished, "battle ended on its own")
	assert_eq(got.size(), 1, "exactly one result")
	if got.size() == 1:
		var p: Dictionary = got[0]
		assert_true(p["result"] == "win" or p["result"] == "lose")
		assert_eq(p["result"], "win", "scripted player beats stage 1")
		assert_eq(int(p["era"]), 1)
		assert_eq(int(p["stage"]), 1)
		assert_true(p.has("stats") and p.has("time") and p.has("base_hp_fraction"))
		assert_true(float(p["base_hp_fraction"]) > 0.0)
	assert_true(_game().last_sim == s.sim, "sim stored for the result / Second Wind")
	assert_eq(_game().economy.get_amount("coins"), 0, "the battle never pays")
	var ev: Array = _events()
	assert_eq(ev.count("stage_end"), 1)
	assert_true(ev.count("stage_start") == 1 and ev.count("power_used") >= 1, "analytics events: %s" % str(ev))
	assert_true((_game().analytics.rejected as Array).is_empty(), "only known analytics events")
	_drop(s)


func test_second_wind_resumes_last_sim() -> void:
	if not _env_ok():
		return
	_fresh_game()
	var s = _make()
	s.press_card(0)
	s.step(0.2)
	s.sim.player_base_hp = 0.0
	s.sim.tick()   # the sim decides the result
	assert_eq(s.sim.result, "lose")
	s.step(0.1)
	assert_true(s.ending)
	for _i in 6:
		s.step(0.25)   # frames are clamped to 0.25 s
	assert_true(s.finished)
	var old = _game().last_sim
	assert_true(old == s.sim)
	_drop(s)
	var s2 = _make({"resume": true})
	assert_true(s2.sim == old, "continues the same sim")
	assert_eq(s2.sim.result, "")
	assert_near(s2.sim.player_base_hp, s2.sim.player_base_max * DataDB.bal_f("ads.second_wind_base_hp_fraction"), 0.01)
	assert_eq(s2.unit_views.size(), s2.sim.units.size(), "views rebuilt from the sim")
	assert_eq(s2.hud.cards.size(), 2)
	s2.step(0.5)
	assert_true(not s2.finished and not s2.ending)
	_drop(s2)


func test_quit_is_a_loss_without_pay() -> void:
	if not _env_ok():
		return
	_fresh_game()
	var s = _make()
	var kinds: Array = []
	s.battle_left.connect(func(k): kinds.append(k))
	s.step(0.3)
	s.quit_to_levels()
	assert_eq(kinds, ["quit"])
	assert_true(s.finished)
	assert_eq(_game().economy.get_amount("coins"), 0)
	var ends: Array = (_game().analytics.provider as MockAnalyticsProvider).events.filter(func(e): return e["name"] == "stage_end")
	assert_eq(ends.size(), 1)
	assert_eq(ends[0]["params"]["result"], "lose")
	s.step(1.0)
	_drop(s)
