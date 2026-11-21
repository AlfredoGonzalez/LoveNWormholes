extends TestCase
## Squad screen and the pre-battle squad/powers selector, with an isolated profile.

const SAVE := "user://test_squad_save.json"


class RecNav extends Navigator:
	var calls: Array = []
	func can_go(_n: String) -> bool:
		return true
	func go(screen_name: String, p: Dictionary = {}) -> bool:
		calls.append([screen_name, p])
		return true


func _g():
	var ml := Engine.get_main_loop()
	if ml == null or not (ml is SceneTree) or (ml as SceneTree).root == null:
		return null
	return (ml as SceneTree).root.get_node_or_null("Game")


func _fresh():
	for f in [SAVE, SAVE.get_basename() + ".bak.json", SAVE + ".tmp"]:
		DirAccess.remove_absolute(ProjectSettings.globalize_path(f))
	_g().boot(SAVE)
	Localization.set_language("en")
	var n = RecNav.new()
	_g().nav = n
	return n


func _make(path: String, params := {}):
	var s = (load(path) as GDScript).new()
	s.setup(params)
	Engine.get_main_loop().root.add_child(s)
	return s


func _drop(s) -> void:
	Engine.get_main_loop().root.remove_child(s)
	s.free()


func _clear_era(era: int) -> void:
	_g().save.profile["progress"]["highest_stage_cleared"][str(era)] = 10


func test_squad_screen_cards_and_locks() -> void:
	if _g() == null:
		return
	_fresh()
	var s = _make("res://src/meta/squad_screen.gd")
	assert_eq(s.unit_cards.size(), 15, "all 15 units shown")
	assert_true(not (s.unit_cards["p1_club_worm"] as Button).disabled)
	assert_true((s.unit_cards["p2_bow_worm"] as Button).disabled, "era 2 locked on a fresh profile")
	var note: Label = (s.unit_cards["p2_bow_worm"] as Button).find_child("locked_note", true, false)
	assert_eq(note.text, _g().t("squad.locked_era", [2]))
	assert_true(note.text.contains("Era 2"))
	assert_true(s.find_child("chip_coins", true, false) != null, "currency chips")
	assert_eq(s.era_chips.size(), 6)
	s.set_filter(3)
	assert_eq(s.unit_cards.size(), 3)
	assert_true(s.unit_cards.has("p3_knight_worm"))
	s.set_filter(0)
	assert_eq(s.unit_cards.size(), 15)
	assert_eq(s.slot_notes.size(), 1, "slot 5 locked")
	assert_eq((s.slot_notes[0] as Label).text, _g().t("ui.unlocks_boss", [2]))
	assert_eq(s.slot_buttons.size(), 4, "4 open slots")
	assert_true(s.find_child("counter_fighter_shooter", true, false) != null)
	assert_true(s.find_child("counter_shooter_heavy", true, false) != null)
	assert_true(s.find_child("counter_heavy_fighter", true, false) != null)
	for b in s.preset_tabs:
		assert_true((b as Button).custom_minimum_size.y >= 48.0)
	assert_eq(s.preset_tabs.size(), 2)
	_drop(s)


func test_squad_screen_tap_adds_removes_and_persists() -> void:
	if _g() == null:
		return
	_fresh()
	_clear_era(1)
	var prof: Dictionary = _g().save.profile
	var s = _make("res://src/meta/squad_screen.gd")
	assert_eq(Squad.active(prof).size(), 4, "defaults: trio + best new unit")
	assert_true(not (s.unit_cards["p2_bow_worm"] as Button).disabled)
	for id in Squad.active(prof).duplicate():
		if id != "p1_club_worm":
			assert_true(s.toggle_unit(id))
	assert_eq(Squad.active(prof), ["p1_club_worm"])
	assert_true(not s.toggle_unit("p1_club_worm"), "last unit cannot be removed")
	assert_eq(s.status_label.text, _g().t("squad.keep_one"))
	for id in ["p1_slinger_worm", "p1_dino_rider_worm", "p2_bow_worm"]:
		assert_true(s.toggle_unit(id), id)
	assert_eq(Squad.active(prof).size(), 4)
	assert_true(not s.toggle_unit("p2_shield_bearer_worm"), "slot limit")
	assert_eq(s.status_label.text, _g().t("squad.full"))
	assert_eq(Squad.active(prof).size(), 4)
	assert_eq(s.slot_notes.size(), 1)
	(s.unit_cards["p2_bow_worm"] as Button).pressed.emit()
	assert_eq(Squad.active(prof).size(), 3, "tap removes")
	assert_true(not ("p2_bow_worm" in Squad.active(prof)))
	assert_eq(s.selected_unit, "p2_bow_worm")
	var dn: Label = s.find_child("detail_name", true, false)
	assert_eq(dn.text, _g().t("unit.p2_bow_worm.name"))
	assert_true(s.find_child("detail_ability", true, false) != null)
	var again := SaveService.new(SAVE)
	again.load_profile()
	assert_eq(Squad.active(again.profile), Squad.active(prof))
	s.select_preset(1)
	assert_eq(Squad.active_index(prof), 1)
	assert_eq(Squad.active(prof), Squad.default_squad(prof))
	_drop(s)


func test_squad_screen_slot5_after_era2_boss() -> void:
	if _g() == null:
		return
	_fresh()
	_clear_era(1)
	_clear_era(2)
	var s = _make("res://src/meta/squad_screen.gd")
	assert_eq(s.slot_buttons.size(), 5)
	assert_eq(s.slot_notes.size(), 0, "no locked slot any more")
	assert_eq(Squad.active(_g().save.profile).size(), 5)
	assert_true(not (s.unit_cards["p3_knight_worm"] as Button).disabled)
	_drop(s)


func test_squad_screen_back_routes() -> void:
	if _g() == null:
		return
	var nav = _fresh()
	var s = _make("res://src/meta/squad_screen.gd")
	s.back_button.pressed.emit()
	assert_eq(nav.calls[-1][0], "home")
	_drop(s)
	var s2 = _make("res://src/meta/squad_screen.gd", {"from": "prebattle", "era": 1, "stage": 4})
	s2.back_button.pressed.emit()
	assert_eq(nav.calls[-1][0], "prebattle")
	assert_eq(nav.calls[-1][1]["era"], 1)
	assert_eq(nav.calls[-1][1]["stage"], 4)
	_drop(s2)


func test_squad_screen_spanish_builds() -> void:
	if _g() == null:
		return
	_fresh()
	Localization.set_language("es")
	var s = _make("res://src/meta/squad_screen.gd")
	assert_eq(s.unit_cards.size(), 15)
	s.toggle_unit("p1_slinger_worm")
	_drop(s)
	var p = _make("res://src/meta/pre_battle_screen.gd", {"era": 1, "stage": 1})
	_drop(p)
	Localization.set_language("en")


func test_prebattle_uses_active_squad_and_powers() -> void:
	if _g() == null:
		return
	var nav = _fresh()
	_clear_era(1)
	var prof: Dictionary = _g().save.profile
	Squad.set_preset(prof, 0, ["p2_bow_worm", "p1_club_worm"])
	Squad.set_preset(prof, 1, ["p1_dino_rider_worm"])
	var s = _make("res://src/meta/pre_battle_screen.gd", {"era": 2, "stage": 1})
	assert_eq(s.squad, ["p2_bow_worm", "p1_club_worm"])
	assert_true(s.unit_cards.has("p2_bow_worm"))
	assert_eq(s.empty_slots.size(), 2, "slots 3 and 4 are open but empty")
	assert_eq(s.slot_notes.size(), 2, "locked slot 5 and locked third power")
	assert_eq((s.slot_notes[0] as Label).text, _g().t("ui.unlocks_boss", [2]))
	assert_eq(s.power_buttons.size(), 2)
	assert_eq(s.powers, ["squirm_slam", "apple_rain"])
	(s.unit_cards["p2_bow_worm"] as Button).pressed.emit()
	assert_eq(nav.calls[-1], ["squad", {"from": "prebattle", "era": 2, "stage": 1}])
	(s.preset_tabs[1] as Button).pressed.emit()
	assert_eq(s.squad, ["p1_dino_rider_worm"])
	assert_eq(Squad.active_index(prof), 1)
	(s.power_buttons[1] as Button).pressed.emit()
	assert_eq(s.powers, ["squirm_slam", "time_freeze"])
	assert_eq(Squad.equipped_powers(prof), ["squirm_slam", "time_freeze"])
	s.start_button.pressed.emit()
	var c: Array = nav.calls[-1]
	assert_eq(c[0], "battle")
	assert_eq(c[1]["squad"], ["p1_dino_rider_worm"])
	assert_eq(c[1]["powers"], ["squirm_slam", "time_freeze"])
	assert_eq(c[1]["era"], 2)
	_drop(s)


func test_prebattle_third_power_slot_and_fifth_unit() -> void:
	if _g() == null:
		return
	_fresh()
	for e in [1, 2, 3]:
		_clear_era(e)
	var s = _make("res://src/meta/pre_battle_screen.gd", {"era": 4, "stage": 1})
	assert_eq(s.squad.size(), 5)
	assert_eq(s.slot_notes.size(), 0)
	assert_eq(s.power_buttons.size(), 3)
	_g().save.profile["loadout"]["equipped_powers"] = ["rewind"]
	s.select_preset(0)
	assert_eq(s.powers, ["rewind"])
	(s.power_buttons[1] as Button).pressed.emit()
	assert_eq(s.powers, ["rewind", "squirm_slam"])
	_drop(s)
