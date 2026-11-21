extends TestCase
## Battle polish: shield dome size, boss bar, rule layer (sand patches), card names, tap areas.

const SAVE := "user://test_battle_polish_save.json"
const SQUAD := ["p1_club_worm", "p1_slinger_worm"]
const POWERS := ["squirm_slam", "apple_rain"]


class FakeSim extends RefCounted:
	var rule = {}
	var patches = []


func _tree_root() -> Node:
	var loop := Engine.get_main_loop()
	if loop is SceneTree:
		return (loop as SceneTree).root
	return null


func _game() -> Node:
	var r := _tree_root()
	return r.get_node_or_null("Game") if r != null else null


func _env_ok() -> bool:
	return _game() != null


func _fresh_game() -> void:
	var g = _game()
	g.boot(SAVE)
	g.save.delete_all()
	g.boot(SAVE)
	g.last_sim = null
	Localization.set_language("en")


func _make(extra := {}):
	var p := {"era": 1, "stage": 1, "squad": SQUAD, "powers": POWERS, "food_boost": false, "resume": false}
	p.merge(extra, true)
	var s = (load("res://src/battle/battle_screen.gd") as GDScript).new()
	s.setup(p)
	_tree_root().add_child(s)
	return s


func _drop(s) -> void:
	if s.get_parent() != null:
		s.get_parent().remove_child(s)
	s.free()


func test_shield_dome_uses_sim_shield_max() -> void:
	if not _env_ok():
		return
	_fresh_game()
	var s = _make()
	s.sim.player_shield_max = 400.0
	s.sim.player_shield = 100.0
	s._update_visuals(0.0)
	assert_near(s._player_base.shield_frac, 0.25, 0.01, "dome = shield / player_shield_max")
	_drop(s)


func test_boss_bar_hidden_without_boss_and_rule_layer_empty() -> void:
	if not _env_ok():
		return
	_fresh_game()
	var s = _make()
	s.step(0.1)
	assert_true(not s.hud.boss_bar.visible, "no boss on the field, no boss bar")
	assert_true(s.rule_layer != null, "rule layer exists")
	assert_true(s.rule_layer.zones.is_empty(), "no rule, no zones")
	_drop(s)


func test_boss_bar_shows_boss_name() -> void:
	if not _env_ok():
		return
	_fresh_game()
	var s = _make({"era": 1, "stage": 10})
	var seen := false
	for _i in 2400:
		s.step(0.25)
		if s.hud.boss_bar.visible:
			seen = true
			assert_true(s.hud.boss_text.text.contains(_game().t("boss.b1_rexy.name")), s.hud.boss_text.text)
			break
		if s.finished:
			break
	assert_true(seen, "boss bar appears when the boss spawns")
	_drop(s)


func test_rule_layer_parses_patches_and_unknown_types() -> void:
	var fake := FakeSim.new()
	fake.rule = {"type": "sand_patch"}
	fake.patches = [{"x": 100.0, "w": 80.0}, {"bad": 1}, {"x": 300.0, "w": 0.0}]
	assert_eq(RuleLayer.patches_of(fake).size(), 1, "malformed entries dropped")
	assert_true(RuleLayer.on_patch(RuleLayer.patches_of(fake), 150.0))
	assert_true(not RuleLayer.on_patch(RuleLayer.patches_of(fake), 200.0))
	var layer := RuleLayer.new()
	layer.setup(70.0, 0.4, 557.0)
	layer.sync(fake)
	assert_eq(layer.zones.size(), 1)
	fake.rule = {"type": "mystery", "walls": [{"x": 50.0}], "gravity_wells": [{"x": 10.0, "w": 20.0}], "junk": 3}
	fake.patches = null
	layer.sync(fake)
	assert_eq(layer.zones.size(), 2, "walls and wells drawn, unknown type ignored")
	layer.sync(null)
	layer.free()
	assert_eq(RuleLayer.rule_of(RefCounted.new()), {}, "object without a rule field")


func test_slow_icon_flag() -> void:
	if not _env_ok():
		return
	_fresh_game()
	var s = _make()
	s.press_card(0)
	s.step(0.1)
	var v = s.unit_views[s.sim.units[0].uid]
	assert_true(not v.slowed)
	v.set_slowed(true)
	assert_true(v.slowed)
	_drop(s)


func test_card_names_fit_in_spanish_and_tap_height() -> void:
	if not _env_ok():
		return
	_fresh_game()
	Localization.set_language("es")
	var s = _make({"squad": ["p1_club_worm", "p1_slinger_worm", "p1_dino_rider_worm", "p1_club_worm", "p1_slinger_worm"]})
	for c in s.hud.cards:
		assert_true(c.size.y >= 64.0 and c.size.x >= 48.0, "tap area")
		assert_true(c.title_font_size() >= CardButton.NAME_SIZE_MIN and c.title_font_size() <= CardButton.NAME_SIZE)
	var long_btn := CardButton.new("Jinete de Dinosaurio Gigante Supremo", "30", UI.BLUE, Vector2(96, 116))
	long_btn.fit_title()
	assert_true(long_btn.title_font_size() < CardButton.NAME_SIZE, "a long Spanish name shrinks")
	long_btn.free()
	Localization.set_language("en")
	_drop(s)
