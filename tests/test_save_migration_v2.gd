extends TestCase
## Phase 2 gate: a real v1 save migrates to v2 without losing anything.

const PATH := "user://test_migration_v2.json"


func _cleanup() -> void:
	for p in [PATH, PATH.get_basename() + ".bak.json", PATH + ".tmp"]:
		if FileAccess.file_exists(p):
			DirAccess.remove_absolute(ProjectSettings.globalize_path(p))


func test_v1_save_migrates_to_v2() -> void:
	_cleanup()
	var old := SaveService.new(PATH, {}, 1)   # a v1 app writing its profile
	old.profile["currencies"]["coins"] = 777
	old.profile["progress"]["highest_stage_cleared"]["1"] = 6
	old.profile["units"]["p1_club_worm"] = 4
	old.profile["loadout"]["squad_presets"] = [["p1_club_worm"]]
	old.profile.erase("quests")
	old.profile.erase("stats")
	old.profile.erase("seen")
	assert_true(old.save())
	var now := SaveService.new(PATH)
	now.load_profile()
	assert_eq(now.load_source, "main")
	assert_eq(int(now.profile["schema_version"]), SaveService.CURRENT_VERSION)
	assert_eq(SaveService.CURRENT_VERSION, 2)
	assert_eq(now.profile["currencies"]["coins"], 777, "nothing lost")
	assert_eq(now.profile["progress"]["highest_stage_cleared"]["1"], 6)
	assert_eq(now.profile["units"]["p1_club_worm"], 4)
	assert_true(now.profile.has("quests") and now.profile.has("stats") and now.profile.has("seen"))
	assert_eq(now.profile["loadout"]["squad_presets"].size(), 2, "two presets at launch")
	assert_eq(now.profile["loadout"]["squad_presets"][0], ["p1_club_worm"], "existing preset kept")
	# the migrated profile was persisted at v2
	var again := SaveService.new(PATH)
	again.load_profile()
	assert_eq(int(again.profile["schema_version"]), 2)
	_cleanup()


func test_fresh_profile_is_v2() -> void:
	var s := SaveService.new("user://test_migration_v2_fresh.json")
	assert_eq(int(s.profile["schema_version"]), 2)
	assert_eq(s.profile["loadout"]["squad_presets"].size(), 2)
