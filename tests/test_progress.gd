extends TestCase

func _profile() -> Dictionary:
	return SaveService.new("user://test_progress_save.json").default_profile()


func test_fresh_profile_unlocks_only_first_stage() -> void:
	var p := _profile()
	assert_true(Progress.is_stage_unlocked(p, 1, 1))
	assert_true(not Progress.is_stage_unlocked(p, 1, 2))
	assert_true(not Progress.is_era_unlocked(p, 2))
	assert_eq(Progress.next_stage(p), {"era": 1, "stage": 1})


func test_clearing_unlocks_next_and_advances_play() -> void:
	var p := _profile()
	p["progress"]["highest_stage_cleared"]["1"] = 3
	assert_true(Progress.is_stage_unlocked(p, 1, 4))
	assert_true(not Progress.is_stage_unlocked(p, 1, 5))
	assert_eq(Progress.next_stage(p), {"era": 1, "stage": 4})
	assert_eq(Progress.highest_stage_number(p), 3)


func test_feature_unlocks_follow_spec() -> void:
	var p := _profile()
	assert_true(not Progress.feature_unlocked(p, "upgrades"))
	p["progress"]["highest_stage_cleared"]["1"] = 2
	assert_true(Progress.feature_unlocked(p, "upgrades"))
	assert_true(not Progress.feature_unlocked(p, "squad"))
	p["progress"]["highest_stage_cleared"]["1"] = 5
	for f in ["squad", "shop", "capsules"]:
		assert_true(Progress.feature_unlocked(p, f), f)


func test_era_unlock_needs_boss() -> void:
	var p := _profile()
	p["progress"]["highest_stage_cleared"]["1"] = 10
	assert_true(Progress.is_era_unlocked(p, 2))


func test_stars_rule() -> void:
	assert_eq(Progress.stars_for_win(1.0), 3)
	assert_eq(Progress.stars_for_win(0.6), 2)
	assert_eq(Progress.stars_for_win(0.1), 1)
