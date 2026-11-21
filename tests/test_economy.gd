extends TestCase
## Balance dictionary shape (mirrors spec 6): see _balance().

const P := "user://t_econ.json"

func _balance() -> Dictionary:
	return {
		"scaling": {"unit_level_step": 0.10},
		"upgrades": {
			"unit": {"max_level": 20, "cost_start": 60, "cost_growth": 1.18},
			"burrow": {"max_level": 10, "income_per_level": 1.2, "cap_per_level": 60, "cost_start": 80, "cost_growth": 1.45},
			"base": {"max_level": 10, "hp_per_level": 0.10, "cost_start": 100, "cost_growth": 1.45},
			"power": {"max_level": 5, "effect_per_level": 0.12, "cooldown_per_level": 0.04, "cost_start": 150, "cost_growth": 1.6},
		},
		"rewards": {"win_coins_base": 30, "win_coins_growth": 1.06, "first_clear_coins_mult": 2, "first_clear_gems": 5,
			"boss_first_clear_gems": 20, "boss_first_clear_capsules": 1, "loss_fraction": 0.4},
		"underdog": {"losses_to_trigger": 2, "food_per_stack": 0.10, "base_hp_per_stack": 0.10, "max_stacks": 3},
		"offline": {"coins_per_min_base": 2, "coins_per_min_per_stage": 0.4, "cap_hours_base": 3,
			"cap_hours_per_boss": 1, "cap_hours_max": 8},
		"daily": {"login_capsules": 1, "login_gems": 10, "streak_day": 7, "streak_bonus_gems": 50, "streak_bonus_capsules": 1},
	}

func _clean() -> void:
	for p in [P, "user://t_econ.bak.json", P + ".tmp"]:
		if FileAccess.file_exists(p):
			DirAccess.remove_absolute(p)

func _eco() -> Economy:
	_clean()
	return Economy.new(_balance(), SaveService.new(P))

func test_add_spend_validation() -> void:
	var e := _eco()
	assert_true(e.add("coins", 100))
	assert_true(not e.add("coins", -5), "no negative add")
	assert_true(not e.spend("coins", -5), "no negative spend")
	assert_true(not e.spend("coins", 101), "cannot overspend")
	assert_eq(e.get_amount("coins"), 100)
	assert_true(e.spend("coins", 40))
	assert_eq(e.get_amount("coins"), 60)
	assert_true(not e.add("food", 5), "food is not a persistent currency")
	assert_true(not e.spend("gems", 1), "gems are separate from coins")
	_clean()

func test_signals_and_persistence() -> void:
	var e := _eco()
	var seen := []
	e.currency_changed.connect(func(c, v, d): seen.append([c, v, d]))
	e.add("gems", 5)
	e.spend("gems", 2)
	assert_eq(seen, [["gems", 5, 5], ["gems", 3, -2]])
	var s2 := SaveService.new(P)
	s2.load_profile()
	assert_eq(s2.profile["currencies"]["gems"], 3)
	_clean()

func test_unit_upgrade_costs() -> void:
	var e := _eco()
	assert_eq(e.unit_upgrade_cost(2), 60)
	assert_eq(e.unit_upgrade_cost(3), 71)
	assert_eq(e.unit_upgrade_cost(4), 84)
	assert_eq(e.unit_upgrade_cost(20), 1180)
	assert_eq(e.unit_upgrade_cost(1), -1)
	assert_eq(e.unit_upgrade_cost(21), -1)
	assert_near(e.unit_stat_multiplier(1), 1.0)
	assert_near(e.unit_stat_multiplier(11), 2.0)
	e.add("coins", 200)
	assert_true(e.upgrade_unit("worm"))
	assert_eq(e.unit_level("worm"), 2)
	assert_eq(e.get_amount("coins"), 140)
	assert_true(e.upgrade_unit("worm"))   # 71
	assert_eq(e.get_amount("coins"), 69)
	assert_true(not e.upgrade_unit("worm"), "84 > 69")
	assert_eq(e.unit_level("worm"), 3)
	_clean()

func test_burrow_base_power_formulas() -> void:
	var e := _eco()
	assert_eq(e.burrow_cost(2), 80)
	assert_eq(e.burrow_cost(3), 116)
	assert_eq(e.burrow_cost(10), 1563)
	assert_eq(e.burrow_cost(11), -1)
	assert_near(e.burrow_income_bonus(6), 6.0)
	assert_near(e.burrow_cap_bonus(6), 300.0)
	assert_eq(e.base_cost(2), 100)
	assert_eq(e.base_cost(10), 1954)
	assert_near(e.base_hp_multiplier(5), 1.4)
	assert_eq(e.power_cost(2), 150)
	assert_eq(e.power_cost(3), 240)
	assert_eq(e.power_cost(5), 614)
	assert_eq(e.power_cost(6), -1)
	assert_near(e.power_effect_multiplier(5), 1.48)
	assert_near(e.power_cooldown_multiplier(5), 0.84)
	e.add("coins", 1000)
	assert_true(e.upgrade_burrow())
	assert_true(e.upgrade_base())
	assert_true(e.upgrade_power("p1"))
	assert_eq(e.get_amount("coins"), 1000 - 80 - 100 - 150)
	assert_eq([e.burrow_level(), e.base_level(), e.power_level("p1")], [2, 2, 2])
	_clean()

func test_win_and_loss_rewards() -> void:
	var e := _eco()
	assert_eq(e.win_reward(1), 30)
	assert_eq(e.win_reward(2), 32)
	assert_eq(e.win_reward(10), 51)
	assert_eq(e.win_reward(50), 521)
	assert_eq(e.loss_reward(10), 20)
	# first clear of 1-1: x2 coins + 5 gems
	var r := e.settle_battle(1, 1, true, 2)
	assert_eq(r["coins"], 60)
	assert_eq(r["gems"], 5)
	assert_true(r["first_clear"])
	# replay: normal reward, no gems
	r = e.settle_battle(1, 1, true)
	assert_eq(r["coins"], 30)
	assert_eq(r["gems"], 0)
	assert_eq(e.get_amount("coins"), 90)
	assert_eq(e.get_amount("gems"), 5)
	assert_eq(e.highest_stage_cleared(), 1)
	# loss on 1-2 pays 40% of round(30*1.06) = 32 -> 13
	r = e.settle_battle(1, 2, false)
	assert_eq(r["coins"], 13)
	assert_eq(e.loss_streak(1, 2), 1)
	# ad double
	r = e.settle_battle(1, 1, true, 0, 2)
	assert_eq(r["coins"], 60)
	_clean()

func test_boss_first_clear() -> void:
	var e := _eco()
	var r := e.settle_battle(1, 10, true)
	assert_eq(r["coins"], 102)   # 2 x 51
	assert_eq(r["gems"], 20)
	assert_eq(r["capsules"], 1)
	assert_true(r["boss_first_clear"])
	assert_eq(e.get_amount("capsules"), 1)
	assert_eq(e.bosses_cleared(), 1)
	assert_eq(e.highest_stage_cleared(), 10)
	r = e.settle_battle(1, 10, true)
	assert_eq(r["gems"], 0)
	assert_eq(r["capsules"], 0)
	_clean()

func test_underdog_stacks() -> void:
	var e := _eco()
	assert_eq(e.underdog(1, 3)["stacks"], 0)
	e.settle_battle(1, 3, false)
	assert_eq(e.underdog(1, 3)["stacks"], 0, "1 loss: nothing")
	e.settle_battle(1, 3, false)
	assert_eq(e.underdog(1, 3)["stacks"], 0, "2 losses: still nothing (stacks = losses - 2)")
	e.settle_battle(1, 3, false)
	var u := e.underdog(1, 3)
	assert_eq(u["stacks"], 1, "3rd consecutive loss: first stack")
	assert_near(u["food_pct"], 0.10)
	assert_near(u["base_hp_pct"], 0.10)
	e.settle_battle(1, 3, false)
	assert_eq(e.underdog(1, 3)["stacks"], 2)
	e.settle_battle(1, 3, false)
	e.settle_battle(1, 3, false)
	e.settle_battle(1, 3, false)
	u = e.underdog(1, 3)
	assert_eq(u["stacks"], 3, "max 3")
	assert_near(u["food_pct"], 0.30)
	assert_eq(e.underdog(1, 4)["stacks"], 0, "per stage")
	e.settle_battle(1, 3, true)
	assert_eq(e.underdog(1, 3)["stacks"], 0, "reset on win")
	_clean()

func test_offline_farm() -> void:
	var e := _eco()
	var t0 := 1_000_000.0
	assert_eq(e.claim_offline(t0), 0, "first call only starts the timer")
	# highest stage 13 (era 2, stage 3): rate 2 + 0.4 x 13 = 7.2/min
	e.save_service.profile["progress"]["highest_stage_cleared"]["1"] = 10
	e.save_service.profile["progress"]["highest_stage_cleared"]["2"] = 3
	assert_near(e.offline_rate_per_minute(), 7.2)
	assert_near(e.offline_cap_hours(), 4.0, 0.0001, "3 h + 1 boss")
	assert_eq(e.offline_pending(t0 + 600.0), 72, "10 min")
	assert_eq(e.offline_pending(t0 + 3600.0 * 100), 1728, "capped at 4 h = 240 min x 7.2")
	assert_eq(e.offline_pending(t0 + 3600.0 * 100, 2.0), 2592, "+2 h IAP: 6 h")
	var c := e.claim_offline(t0 + 600.0, 0.0, 2)
	assert_eq(c, 144, "double farm ad")
	assert_eq(e.get_amount("coins"), 144)
	assert_eq(e.offline_pending(t0 + 600.0), 0, "timer restarted")
	_clean()

func test_offline_cap_max_8h() -> void:
	var e := _eco()
	for era in ["1", "2", "3", "4", "5"]:
		e.save_service.profile["progress"]["highest_stage_cleared"][era] = 10
	assert_near(e.offline_cap_hours(), 8.0, 0.0001, "3 + 5 bosses = 8")
	e.balance["offline"]["cap_hours_per_boss"] = 3
	assert_near(e.offline_cap_hours(), 8.0, 0.0001, "never above 8")
	assert_near(e.offline_cap_hours(2.0), 10.0, 0.0001, "IAP hours add on top")
	_clean()

func test_daily_login() -> void:
	var e := _eco()
	var day := 86400.0
	var d0 := 100 * day + 3600.0
	var r := e.claim_daily(d0)
	assert_true(r["claimed"])
	assert_eq(e.get_amount("capsules"), 1)
	assert_eq(e.get_amount("gems"), 10)
	assert_true(not e.claim_daily(d0 + 100.0)["claimed"], "once per day")
	for i in range(1, 6):
		assert_true(e.claim_daily(d0 + i * day)["claimed"])
	r = e.claim_daily(d0 + 6 * day)
	assert_eq(r["streak"], 7)
	assert_true(r["streak_bonus"])
	assert_eq(e.get_amount("gems"), 70 + 50)
	assert_eq(e.get_amount("capsules"), 7 + 1)
	# missing a day resets the streak
	r = e.claim_daily(d0 + 9 * day)
	assert_eq(r["streak"], 1)
	_clean()
