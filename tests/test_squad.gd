extends TestCase
## Squad rules (spec 4.3, 4.5, 5.1): unlocked units, slots, presets, powers, validation and persistence.

const SAVE := "user://test_squad_rules_save.json"
const ERA1 := ["p1_club_worm", "p1_slinger_worm", "p1_dino_rider_worm"]


func _profile() -> Dictionary:
	return SaveService.new(SAVE).default_profile()


func _clear(p: Dictionary, era: int, upto := 10) -> void:
	p["progress"]["highest_stage_cleared"][str(era)] = upto


func test_unlocked_units_follow_eras() -> void:
	var p := _profile()
	assert_eq(Squad.unlocked_units(p).size(), 3)
	for id in ERA1:
		assert_true(id in Squad.unlocked_units(p))
	_clear(p, 1)
	var u := Squad.unlocked_units(p)
	assert_eq(u.size(), 6, "era 2 adds its 3 units")
	for x in u:
		assert_true(int(DataDB.unit(x)["era"]) <= 2)
	assert_eq(u.slice(0, 3), ERA1, "data order")
	_clear(p, 2, 9)
	assert_eq(Squad.unlocked_units(p).size(), 6, "era 3 needs the era 2 boss")
	_clear(p, 2)
	_clear(p, 3)
	_clear(p, 4)
	assert_eq(Squad.unlocked_units(p).size(), DataDB.unit_ids().size())


func test_slots_fifth_after_era2_boss() -> void:
	var p := _profile()
	assert_eq(Squad.slots(p), 4)
	_clear(p, 1)
	assert_eq(Squad.slots(p), 4, "era 1 boss does not give slot 5")
	_clear(p, 2, 9)
	assert_eq(Squad.slots(p), 4)
	_clear(p, 2)
	assert_eq(Squad.slots(p), 5)
	assert_eq(Squad.slot_unlock_era(), 2)


func test_defaults_and_active() -> void:
	var p := _profile()
	assert_eq(Squad.active(p), ERA1, "empty preset: the era-1 trio")
	_clear(p, 1)
	var a := Squad.active(p)
	assert_eq(a.size(), 4, "trio plus the best newly unlocked unit")
	assert_eq(a.slice(0, 3), ERA1)
	assert_eq(int(DataDB.unit(a[3])["era"]), 2)
	_clear(p, 2)
	assert_eq(Squad.active(p).size(), 5)


func test_set_preset_validation() -> void:
	var p := _profile()
	assert_true(Squad.set_preset(p, 0, ["p1_slinger_worm", "p1_club_worm"]))
	assert_eq(Squad.active(p), ["p1_slinger_worm", "p1_club_worm"])
	assert_true(not Squad.set_preset(p, 0, []), "empty rejected")
	assert_true(not Squad.set_preset(p, 0, ["p1_club_worm", "p1_club_worm"]), "duplicates rejected")
	assert_true(not Squad.set_preset(p, 0, ["p2_bow_worm"]), "locked unit rejected")
	assert_true(not Squad.set_preset(p, 0, ["nope"]), "unknown unit rejected")
	assert_true(not Squad.set_preset(p, 5, ERA1), "bad index rejected")
	assert_true(not Squad.set_preset(p, 2, ERA1), "third preset not bought")
	assert_eq(Squad.active(p), ["p1_slinger_worm", "p1_club_worm"], "failed calls change nothing")
	_clear(p, 1)
	assert_true(Squad.set_preset(p, 0, ERA1 + ["p2_bow_worm"]))
	assert_true(not Squad.set_preset(p, 0, ERA1 + ["p2_bow_worm", "p2_shield_bearer_worm"]), "5 units need slot 5")
	assert_true(Squad.set_preset(p, 1, ["p2_bow_worm"]))
	assert_eq(Squad.preset(p, 0).size(), 4)
	assert_eq(Squad.preset_count(p), 2)
	assert_eq(Squad.preset_max(), 3)


func test_stored_garbage_is_sanitized() -> void:
	var p := _profile()
	p["loadout"]["squad_presets"][0] = ["p3_knight_worm", "p1_club_worm", "p1_club_worm", "bogus", "p1_slinger_worm"]
	assert_eq(Squad.active(p), ["p1_club_worm", "p1_slinger_worm"], "locked, duplicate and unknown dropped")
	p["loadout"]["squad_presets"][0] = ["p3_knight_worm"]
	assert_eq(Squad.active(p), ERA1, "nothing valid left: defaults")
	p["loadout"]["squad_presets"][0] = ERA1 + ["p1_club_worm"]
	_clear(p, 1)
	p["loadout"]["squad_presets"][0] = ERA1 + ["p2_bow_worm", "p2_shield_bearer_worm", "p2_cobra_charmer_worm"]
	assert_eq(Squad.active(p).size(), 4, "trimmed to the slots")
	p["loadout"]["active_preset"] = 9
	assert_eq(Squad.active_index(p), 1, "active index clamped")


func test_active_preset_switch() -> void:
	var p := _profile()
	Squad.set_preset(p, 1, ["p1_dino_rider_worm"])
	assert_true(Squad.set_active_index(p, 1))
	assert_eq(Squad.active(p), ["p1_dino_rider_worm"])
	assert_true(not Squad.set_active_index(p, 2))
	assert_eq(Squad.active_index(p), 1)


func test_power_unlocks_and_slots() -> void:
	var p := _profile()
	assert_eq(Squad.unlocked_powers(p), ["squirm_slam", "apple_rain"] as Array[String])
	assert_eq(Squad.power_slots(p), 2)
	_clear(p, 1)
	assert_true("time_freeze" in Squad.unlocked_powers(p))
	assert_true(not ("rewind" in Squad.unlocked_powers(p)))
	_clear(p, 2)
	assert_true("rewind" in Squad.unlocked_powers(p))
	assert_eq(Squad.power_slots(p), 2)
	_clear(p, 3)
	assert_true("dirt_shield" in Squad.unlocked_powers(p))
	assert_eq(Squad.power_slots(p), 3, "third power slot after the era 3 boss")
	assert_eq(Squad.power_slot_unlock_era(), 3)


func test_equipped_powers_validation() -> void:
	var p := _profile()
	assert_eq(Squad.equipped_powers(p), ["squirm_slam", "apple_rain"], "defaults")
	assert_true(not Squad.set_equipped_powers(p, ["time_freeze"]), "locked")
	assert_true(not Squad.set_equipped_powers(p, []))
	assert_true(not Squad.set_equipped_powers(p, ["squirm_slam", "squirm_slam"]))
	assert_true(not Squad.set_equipped_powers(p, ["squirm_slam", "apple_rain", "apple_rain"]))
	assert_true(Squad.set_equipped_powers(p, ["apple_rain"]))
	assert_eq(Squad.equipped_powers(p), ["apple_rain"])
	p["loadout"]["equipped_powers"] = ["rewind", "squirm_slam", "apple_rain", "squirm_slam"]
	assert_eq(Squad.equipped_powers(p), ["squirm_slam", "apple_rain"], "locked and duplicates dropped, trimmed")
	assert_eq(Squad.power_with_slot(["squirm_slam", "apple_rain"], 0, "apple_rain"), ["apple_rain", "squirm_slam"])
	assert_eq(Squad.power_with_slot(["squirm_slam"], 1, "apple_rain"), ["squirm_slam", "apple_rain"])


func test_persistence_round_trip() -> void:
	for f in [SAVE, SAVE.get_basename() + ".bak.json", SAVE + ".tmp"]:
		DirAccess.remove_absolute(ProjectSettings.globalize_path(f))
	var svc := SaveService.new(SAVE)
	svc.profile["progress"]["highest_stage_cleared"]["1"] = 10
	svc.profile["units"]["p1_club_worm"] = 4
	assert_true(Squad.set_preset_and_save(svc, 1, ["p2_bow_worm", "p1_club_worm"]))
	assert_true(Squad.set_active_index(svc.profile, 1))
	assert_true(Squad.set_equipped_powers_and_save(svc, ["time_freeze", "squirm_slam"]))
	assert_true(not Squad.set_preset_and_save(svc, 0, ["p3_knight_worm"]))
	var again := SaveService.new(SAVE)
	again.load_profile()
	assert_eq(Squad.active(again.profile), ["p2_bow_worm", "p1_club_worm"])
	assert_eq(Squad.equipped_powers(again.profile), ["time_freeze", "squirm_slam"])
	assert_eq(Squad.unit_level(again.profile, "p1_club_worm"), 4)
	for f in [SAVE, SAVE.get_basename() + ".bak.json", SAVE + ".tmp"]:
		DirAccess.remove_absolute(ProjectSettings.globalize_path(f))
