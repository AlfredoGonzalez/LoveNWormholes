extends TestCase
## CapsuleScreen and RelicsScreen against an isolated profile (see test_upgrades_settings.gd for the Game-autoload note).

const P := "user://test_capscr_save.json"

func _clean() -> void:
	for p in [P, "user://test_capscr_save.bak.json", P + ".tmp"]:
		if FileAccess.file_exists(p):
			DirAccess.remove_absolute(p)

var G: Node

func _have_game() -> bool:
	var ml = Engine.get_main_loop()
	G = ml.root.get_node_or_null("Game") if ml != null else null
	if G == null:
		print("       (skipped: Game autoload not available in this runner)")
	return G != null

func _show(script_path: String):
	_clean()
	G.boot(P)
	var s = load(script_path).new()
	s.setup({})
	if "animate" in s:
		s.animate = false
	Engine.get_main_loop().root.add_child(s)
	s.ensure_built()
	return s

func test_routes_registered() -> void:
	assert_true(Navigator.SCREENS.has("capsules") and Navigator.SCREENS.has("relics"))

func test_capsule_screen_shows_odds_pity_and_opens() -> void:
	if not _have_game():
		return
	var s = _show("res://src/meta/capsule_screen.gd")
	assert_true(s.odds_label.text.contains("70") and s.odds_label.text.contains("25") and s.odds_label.text.contains("5"), "odds visible: " + s.odds_label.text)
	assert_true(s.pity_rare_bar != null and s.pity_epic_bar != null, "pity visible")
	assert_true(s.open_button.disabled, "no capsules yet")
	G.economy.add("capsules", 11)
	s.refresh()
	assert_true(not s.open_button.disabled and not s.open_many_button.disabled)
	var res: Array = s.open(1)
	assert_eq(res.size(), 1)
	assert_eq(G.economy.get_amount("capsules"), 10)
	assert_eq(s._results.get_child_count() >= 2, true, "revealed result rows")
	assert_eq(s.open(10).size(), 10)
	assert_eq(G.economy.get_amount("capsules"), 0)
	s.queue_free()

func test_relics_screen_equip_and_craft() -> void:
	if not _have_game():
		return
	var s = _show("res://src/meta/relics_screen.gd")
	assert_eq(s.buttons.size(), DataDB.relic_ids().size(), "a craft button per relic, no equip buttons yet")
	G.economy.add("chrono_dust", 30)
	s.refresh()
	assert_true(s.craft("sticky_seed"), "craft with dust")
	assert_true(Relics.is_equipped(G.save.profile, "sticky_seed"), "auto-equipped")
	assert_true(s.buttons.has("equip:sticky_seed"))
	assert_true(s.toggle_equip("sticky_seed"))
	assert_true(not Relics.is_equipped(G.save.profile, "sticky_seed"))
	assert_true(not s.craft("golden_dewdrop"), "not enough dust")
	s.queue_free()
