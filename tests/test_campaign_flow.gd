extends TestCase
## End-to-end campaign economy without UI: Economy + Progress + SaveService.

const P := "user://t_campaign.json"

func _clean() -> void:
	for p in [P, "user://t_campaign.bak.json", P + ".tmp"]:
		if FileAccess.file_exists(p):
			DirAccess.remove_absolute(p)

func test_campaign_flow() -> void:
	_clean()
	DataDB.ensure_loaded()
	var save := SaveService.new(P)
	var eco := Economy.new(DataDB.balance(), save)
	var prof := save.profile
	assert_true(Progress.is_stage_unlocked(prof, 1, 1))
	assert_true(not Progress.is_stage_unlocked(prof, 1, 2), "stage 2 locked at start")

	# win stage 1: first clear pays x2 coins + 5 gems
	var r := eco.settle_battle(1, 1, true, 3)
	assert_eq(r["coins"], DataDB.first_clear_coins(1))
	assert_eq(r["coins"], 60)
	assert_eq(r["gems"], 5)
	assert_true(r["first_clear"])
	assert_eq(eco.get_amount("coins"), 60)
	assert_eq(eco.get_amount("gems"), 5)
	assert_true(Progress.is_stage_unlocked(prof, 1, 2), "stage 2 unlocked by clearing stage 1")
	assert_eq(Progress.stage_stars(prof, 1, 1), 3)
	assert_true(not Progress.feature_unlocked(prof, "upgrades"), "upgrades need stage 2")

	# replay: normal reward only
	r = eco.settle_battle(1, 1, true)
	assert_eq(r["coins"], 30)
	assert_eq(r["gems"], 0)

	# lose stage 2: loss coins; underdog only from the 3rd consecutive loss
	r = eco.settle_battle(1, 2, false)
	assert_eq(r["coins"], DataDB.loss_coins(2))
	assert_eq(eco.underdog(1, 2)["stacks"], 0)
	eco.settle_battle(1, 2, false)
	assert_eq(eco.loss_streak(1, 2), 2)
	assert_eq(eco.underdog(1, 2)["stacks"], DataDB.underdog_stacks(2))
	assert_eq(eco.underdog(1, 2)["stacks"], 0)
	eco.settle_battle(1, 2, false)
	assert_eq(eco.underdog(1, 2)["stacks"], 1, "third consecutive loss")
	assert_near(eco.underdog(1, 2)["food_pct"], 0.1)
	eco.settle_battle(1, 2, false)
	assert_eq(eco.underdog(1, 2)["stacks"], 2)

	# win stage 2: streak resets, stage 3 unlocks, upgrades feature unlocked
	r = eco.settle_battle(1, 2, true, 1)
	assert_eq(eco.underdog(1, 2)["stacks"], 0)
	assert_eq(r["coins"], DataDB.first_clear_coins(2))
	assert_true(Progress.is_stage_unlocked(prof, 1, 3))
	assert_true(Progress.feature_unlocked(prof, "upgrades"))

	# clear stages 3..9 then the boss (stage 10): boss first-clear bundle
	for s in range(3, 10):
		eco.settle_battle(1, s, true, 2)
	assert_eq(eco.bosses_cleared(), 0)
	var gems_before := eco.get_amount("gems")
	var caps_before := eco.get_amount("capsules")
	r = eco.settle_battle(1, 10, true, 3)
	assert_true(r["boss_first_clear"])
	assert_eq(r["gems"], DataDB.bal_i("rewards.boss_first_clear_gems"))
	assert_eq(r["capsules"], DataDB.bal_i("rewards.boss_first_clear_capsules"))
	assert_eq(r["coins"], DataDB.first_clear_coins(10))
	assert_eq(eco.get_amount("gems"), gems_before + 20)
	assert_eq(eco.get_amount("capsules"), caps_before + 1)
	assert_eq(eco.bosses_cleared(), 1)
	assert_true(Progress.is_era_unlocked(prof, 2), "era 2 opens after the boss")
	r = eco.settle_battle(1, 10, true, 3)
	assert_eq(r["gems"], 0, "boss bundle only once")

	# spend on an upgrade, then save/reload keeps everything
	var coins := eco.get_amount("coins")
	var cost := eco.unit_upgrade_cost(2)
	assert_true(eco.upgrade_unit("p1_club_worm"))
	assert_eq(eco.get_amount("coins"), coins - cost)
	var snapshot := JSON.stringify(save.profile)
	var save2 := SaveService.new(P)
	save2.load_profile()
	assert_eq(save2.load_source, "main")
	assert_eq(JSON.stringify(save2.profile), snapshot, "profile identical after reload")
	var eco2 := Economy.new(DataDB.balance(), save2)
	assert_eq(eco2.get_amount("coins"), coins - cost)
	assert_eq(eco2.unit_level("p1_club_worm"), 2)
	assert_eq(eco2.bosses_cleared(), 1)
	assert_eq(Progress.highest_stage_number(save2.profile), 10)
	assert_true(not eco2.is_first_clear(1, 1))
	assert_eq(eco.missing_keys, [], "no silent balance defaults used")
	_clean()
