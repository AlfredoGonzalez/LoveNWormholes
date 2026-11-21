extends TestCase
## Economy must read the REAL keys of data/balance.json (no silent fallback to its built-in defaults) and agree
## with DataDB's equivalent formulas.

const P := "user://t_econ_keys.json"

func _clean() -> void:
	for p in [P, "user://t_econ_keys.bak.json", P + ".tmp"]:
		if FileAccess.file_exists(p):
			DirAccess.remove_absolute(p)

func _eco() -> Economy:
	_clean()
	DataDB.ensure_loaded()
	return Economy.new(DataDB.balance(), SaveService.new(P))

## Calls every Economy function that reads balance keys.
func _exercise(e: Economy) -> void:
	e.add("coins", 1000000)
	e.unit_max_level(); e.unit_upgrade_cost(2); e.unit_stat_multiplier(3)
	e.burrow_max_level(); e.burrow_cost(2); e.burrow_income_bonus(2); e.burrow_cap_bonus(2)
	e.base_max_level(); e.base_cost(2); e.base_hp_multiplier(2)
	e.power_max_level(); e.power_cost(2); e.power_effect_multiplier(2); e.power_cooldown_multiplier(2)
	e.win_reward(5); e.loss_reward(5); e.underdog(1, 1)
	e.settle_battle(1, 1, true)
	e.settle_battle(1, 10, true)
	e.settle_battle(1, 2, false)
	e.underdog(1, 2)
	e.offline_rate_per_minute(); e.offline_cap_hours()
	e.claim_offline(1000.0)
	e.claim_offline(5000.0)
	e.claim_daily(86400.0 * 10)
	for i in range(1, 8):
		e.claim_daily(86400.0 * (10 + i))

func test_no_missing_balance_keys() -> void:
	var e := _eco()
	_exercise(e)
	assert_eq(e.missing_keys, [], "Economy asked for keys that data/balance.json does not have")
	_clean()

func test_missing_key_is_recorded() -> void:
	var e := Economy.new({}, SaveService.new(P))
	e.win_reward(1)
	assert_true(e.missing_keys.has("rewards.win_coins_base"))
	_clean()

func test_rewards_match_datadb() -> void:
	var e := _eco()
	for n in [1, 2, 5, 10, 11, 25, 50]:
		assert_eq(e.win_reward(n), DataDB.win_coins(n), "win %d" % n)
		assert_eq(e.loss_reward(n), DataDB.loss_coins(n), "loss %d" % n)
	var r := e.settle_battle(1, 1, true)
	assert_eq(r["coins"], DataDB.first_clear_coins(1))
	assert_eq(r["gems"], DataDB.bal_i("rewards.first_clear_gems"))
	_clean()

func test_upgrade_costs_match_datadb() -> void:
	var e := _eco()
	for l in range(0, 23):
		assert_eq(e.unit_upgrade_cost(l), DataDB.unit_upgrade_cost(l), "unit %d" % l)
		assert_eq(e.burrow_cost(l), DataDB.burrow_upgrade_cost(l), "burrow %d" % l)
		assert_eq(e.base_cost(l), DataDB.base_upgrade_cost(l), "base %d" % l)
		assert_eq(e.power_cost(l), DataDB.power_upgrade_cost(l), "power %d" % l)
	for l in range(1, 11):
		assert_near(e.burrow_income_bonus(l) + DataDB.bal_f("battle.food_income_base"), DataDB.burrow_income(l))
		assert_near(e.burrow_cap_bonus(l) + DataDB.bal_f("battle.food_cap_base"), DataDB.burrow_cap(l))
		assert_near(e.base_hp_multiplier(l), DataDB.base_hp_mult(l))
	for l in range(1, 21):
		assert_near(e.unit_stat_multiplier(l), DataDB.level_mult(l))
	for l in range(1, 6):
		var pp := DataDB.power_params("squirm_slam", l)
		assert_near(DataDB.power("squirm_slam")["cooldown"] * e.power_cooldown_multiplier(l), pp["cooldown"])
	assert_eq(e.unit_max_level(), DataDB.bal_i("upgrades.unit.max_level"))
	_clean()

func test_underdog_matches_datadb() -> void:
	var e := _eco()
	for losses in range(0, 9):
		e.save_service.profile["progress"]["loss_streak"]["1-3"] = losses
		var u := e.underdog(1, 3)
		assert_eq(u["stacks"], DataDB.underdog_stacks(losses), "stacks after %d losses" % losses)
		assert_near(1.0 + u["food_pct"], DataDB.underdog_food_mult(u["stacks"]))
		assert_near(1.0 + u["base_hp_pct"], DataDB.underdog_base_hp_mult(u["stacks"]))
	assert_eq(DataDB.underdog_stacks(2), 0)
	assert_eq(DataDB.underdog_stacks(3), 1)
	_clean()

func test_offline_matches_datadb() -> void:
	var e := _eco()
	var t0 := 1_000_000.0
	e.claim_offline(t0)
	for bosses in range(0, 6):
		for era in range(1, 6):
			e.save_service.profile["progress"]["highest_stage_cleared"][str(era)] = 10 if era <= bosses else 0
		e.save_service.profile["progress"]["highest_stage_cleared"]["1"] = maxi(10 if bosses > 0 else 0, 4)
		assert_eq(e.bosses_cleared(), bosses)
		assert_near(e.offline_cap_hours(), DataDB.offline_cap_hours(bosses))
		assert_near(e.offline_cap_hours(2.0), DataDB.offline_cap_hours(bosses, true))
		var hi := e.highest_stage_cleared()
		assert_near(e.offline_rate_per_minute(), DataDB.offline_coins_per_minute(hi))
		for mins in [0.0, 10.0, 90.0, 600.0, 100000.0]:
			var now: float = t0 + mins * 60.0
			assert_eq(e.offline_pending(now), DataDB.offline_coins(hi, mins, bosses), "offline %s min, %d bosses" % [mins, bosses])
	_clean()
