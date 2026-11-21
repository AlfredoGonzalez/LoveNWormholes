extends TestCase
## UpgradesScreen and SettingsScreen against an isolated profile (G.boot with a temp save path).
## NOTE: the `Game` autoload only exists once the SceneTree is initialized. tools/run_tests.gd runs tests from
## `_init`, where it does not exist yet, so these tests skip themselves there (see _have_game) and do their
## work when the runner uses `_initialize`. The screens and Game are reached without compile-time references to
## `Game` / the screen class names so this file always compiles.

const P := "user://test_upg_save.json"

func _clean() -> void:
	for p in [P, "user://test_upg_save.bak.json", P + ".tmp"]:
		if FileAccess.file_exists(p):
			DirAccess.remove_absolute(p)

func _root() -> Node:
	return Engine.get_main_loop().root

var G: Node

func _have_game() -> bool:
	var ml = Engine.get_main_loop()
	G = ml.root.get_node_or_null("Game") if ml != null else null
	if G == null:
		print("       (skipped: Game autoload not available in this runner)")
	return G != null

func _fresh() -> void:
	_clean()
	G.boot(P)

func _show(script_path: String, params := {}):
	var s = load(script_path).new()
	s.setup(params)
	_root().add_child(s)
	s.ensure_built()   # _ready may not have run yet when the tree is still initializing
	return s

func test_upgrades_builds_all_tabs() -> void:
	if not _have_game():
		return
	_fresh()
	var s = _show("res://src/meta/upgrades_screen.gd")
	for t in ["units", "burrow", "base", "powers"]:
		s.select_tab(t)
		assert_true(not s.upgrade_buttons.is_empty(), "tab %s has upgrade buttons" % t)
	s.select_tab("units")
	assert_eq(s.upgrade_buttons.size(), DataDB.units_of_era(1).size(), "era 1 units only at the start")
	s.select_tab("powers")
	assert_true(s.upgrade_buttons.has("power:squirm_slam") and s.upgrade_buttons.has("power:apple_rain"))
	s.queue_free()
	_clean()

func test_unaffordable_disabled_then_upgrade_spends_cost() -> void:
	if not _have_game():
		return
	_fresh()
	var s = _show("res://src/meta/upgrades_screen.gd")
	var key := "unit:p1_club_worm"
	assert_true(s.upgrade_buttons[key].disabled, "0 coins: disabled")
	var cost: int = G.economy.unit_upgrade_cost(2)
	G.economy.add("coins", cost + 5)
	s.refresh()
	var btn = s.upgrade_buttons[key]
	assert_true(not btn.disabled, "affordable")
	btn.pressed.emit()
	assert_eq(G.economy.unit_level("p1_club_worm"), 2)
	assert_eq(G.economy.get_amount("coins"), 5, "spent exactly the cost")
	assert_true(s.upgrade_buttons[key].disabled, "next level not affordable")
	G.economy.add("coins", 100000)
	s.select_tab("burrow")
	var c0: int = G.economy.get_amount("coins")
	var c: int = G.economy.burrow_cost(2)
	s.upgrade_buttons["burrow"].pressed.emit()
	assert_eq(G.economy.burrow_level(), 2)
	assert_eq(G.economy.get_amount("coins"), c0 - c)
	s.select_tab("base")
	s.upgrade_buttons["base"].pressed.emit()
	assert_eq(G.economy.base_level(), 2)
	s.select_tab("powers")
	s.upgrade_buttons["power:squirm_slam"].pressed.emit()
	assert_eq(G.economy.power_level("squirm_slam"), 2)
	s.queue_free()
	_clean()

func test_max_level_disabled() -> void:
	if not _have_game():
		return
	_fresh()
	G.save.profile["upgrades"]["base"] = G.economy.base_max_level()
	G.economy.add("coins", 1000000)
	var s = _show("res://src/meta/upgrades_screen.gd")
	s.select_tab("base")
	assert_true(s.upgrade_buttons["base"].disabled, "max level disabled even when rich")
	s.upgrade_buttons["base"].pressed.emit()   # guarded: nothing happens
	assert_eq(G.economy.base_level(), G.economy.base_max_level())
	s.queue_free()
	_clean()

func test_settings_persist_across_reload() -> void:
	if not _have_game():
		return
	_fresh()
	var s = _show("res://src/meta/settings_screen.gd", {"from": "levels"})
	s.set_music(0.3)
	s.set_sfx(0.55)
	s.set_muted(true)
	s.set_vibration(false)
	s.set_text_size(1.25)
	s.set_language("es")
	s.set_consent("accepted")
	assert_eq(G.t("ui.back"), "Atrás")
	var re := SaveService.new(P)
	re.load_profile()
	var st: Dictionary = re.profile["settings"]
	assert_near(float(st["music"]), 0.3)
	assert_near(float(st["sfx"]), 0.55)
	assert_eq(st["muted"], true)
	assert_eq(st["vibration"], false)
	assert_near(float(st["text_size"]), 1.25)
	assert_eq(st["language"], "es")
	assert_eq(re.profile["consent"]["state"], "accepted")
	assert_near(G.audio.music_volume, 0.3)
	assert_true(G.audio.muted)
	s.set_language("en")
	s.queue_free()
	_clean()

func test_delete_all_resets_progress() -> void:
	if not _have_game():
		return
	_fresh()
	G.economy.add("coins", 500)
	G.economy.settle_battle(1, 1, true, 3)
	var s = _show("res://src/meta/settings_screen.gd")
	s.set_music(0.2)
	s.delete_local_data()
	assert_eq(G.economy.get_amount("coins"), 0)
	assert_eq(G.economy.get_amount("gems"), 0)
	assert_eq(Progress.highest_stage_number(G.save.profile), 0)
	assert_near(float(G.save.profile["settings"]["music"]), 0.7, 0.0001, "defaults back")
	s.queue_free()
	_clean()
