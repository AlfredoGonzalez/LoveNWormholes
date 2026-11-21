extends TestCase
## Formulas of DataDB checked against numbers computed by hand from docs/spec.md.

func test_unit_stats_base() -> void:
	var s := DataDB.unit_stats("p1_club_worm", 1, 1)
	assert_near(s["hp"], 100.0)
	assert_near(s["damage"], 12.0)
	assert_near(s["cost"], 50.0)
	assert_near(s["interval"], 0.8)
	assert_near(s["range_px"], 40.0)

func test_unit_level_multiplier() -> void:
	var s := DataDB.unit_stats("p1_club_worm", 5, 1)
	assert_near(s["hp"], 140.0)
	assert_near(s["damage"], 16.8)
	assert_near(s["cost"], 50.0, 0.0001, "cost does not scale with level")

func test_unit_era_scaling_and_cost() -> void:
	# Shield Bearer is a Heavy of era 2: 300 x 1.6, 25 x 1.6, cost 150 x 1.5
	var s := DataDB.unit_stats("p2_shield_bearer_worm", 1, 2)
	assert_near(s["hp"], 480.0)
	assert_near(s["damage"], 40.0)
	assert_near(s["cost"], 225.0)

func test_time_sync() -> void:
	# era 2 unit in era 4: 1.6 x (1 + 0.40 x 2) = 2.88
	assert_near(DataDB.time_sync_mult(2, 4), 1.8)
	assert_near(DataDB.unit_stats("p2_shield_bearer_worm", 1, 4)["hp"], 864.0)
	assert_near(DataDB.time_sync_mult(3, 1), 1.0, 0.0001, "never below 1")

func test_unit_full_formula() -> void:
	# Knight (era 3 fighter) level 5 in era 4: 1.6^2 x 1.4 x 1.4 = 5.0176
	var s := DataDB.unit_stats("p3_knight_worm", 5, 4)
	assert_near(s["mult"], 5.0176)
	assert_near(s["hp"], 501.76)
	assert_near(s["damage"], 60.2112)
	assert_near(s["cost"], 112.5)
	assert_near(s["interval"], 0.8, 0.0001, "interval is not scaled")

func test_unit_override_scaled_once() -> void:
	# Mecha Worm hp override 400, era 5: 400 x 1.6^4
	assert_near(DataDB.unit_stats("p5_mecha_worm", 1, 5)["hp"], 400.0 * 6.5536)

func test_unknown_ids_are_empty() -> void:
	assert_true(DataDB.unit("nope").is_empty())
	assert_true(DataDB.unit_stats("nope", 1, 1).is_empty())
	assert_true(DataDB.enemy_stats("nope", 1, 1).is_empty())
	assert_true(DataDB.boss_stats("nope").is_empty())
	assert_true(DataDB.power_params("nope", 1).is_empty())

func test_enemy_stats() -> void:
	var s1 := DataDB.enemy_stats("e1_ant_clubber", 1, 1)
	assert_near(s1["hp"], 100.0)
	assert_near(s1["cost"], 50.0)
	# era 3 stage 7: 1.6^2 x 1.30 = 3.328
	var s := DataDB.enemy_stats("e3_beetle_knight", 3, 7)
	assert_near(s["mult"], 3.328)
	assert_near(s["hp"], 332.8)
	assert_near(s["damage"], 39.936)
	assert_near(s["cost"], 112.5)
	assert_near(DataDB.kill_food(s["cost"]), 28.125)

func test_boss_stats() -> void:
	# Rexy: Heavy 300 x 6 x (1 + 0.05 x 9) = 2610, damage 25 x 1.45
	var s := DataDB.boss_stats("b1_rexy")
	assert_near(s["hp"], 2610.0)
	assert_near(s["damage"], 36.25)
	assert_near(DataDB.boss_stats("b2_pharaoh_scarab", 10)["hp"], 1800.0 * 1.6 * 1.45)

func test_enemy_base_hp() -> void:
	assert_near(DataDB.enemy_base_hp(1), 1000.0)
	assert_near(DataDB.enemy_base_hp(11), 2500.0)
	assert_near(DataDB.enemy_base_hp(50), 8350.0)

func test_stage_numbers() -> void:
	assert_eq(DataDB.stage_number(1, 1), 1)
	assert_eq(DataDB.stage_number(3, 4), 24)
	assert_eq(DataDB.stage_number(5, 10), 50)
	assert_eq(DataDB.era_of_stage(24), 3)
	assert_eq(DataDB.stage_in_era(24), 4)
	assert_true(DataDB.is_boss_stage(30))
	assert_true(not DataDB.is_boss_stage(29))

func test_player_base_hp() -> void:
	assert_near(DataDB.player_base_hp(1, 1), 1000.0)
	assert_near(DataDB.player_base_hp(1, 10), 1900.0)
	assert_near(DataDB.player_base_hp(3, 5), 1000.0 * 2.56 * 1.4)

func test_upgrade_costs() -> void:
	assert_eq(DataDB.unit_upgrade_cost(2), 60)
	assert_eq(DataDB.unit_upgrade_cost(3), 71)
	assert_eq(DataDB.unit_upgrade_cost(5), 99)
	assert_eq(DataDB.unit_upgrade_cost(20), 1180)
	assert_eq(DataDB.unit_upgrade_cost(1), -1)
	assert_eq(DataDB.unit_upgrade_cost(21), -1)
	assert_eq(DataDB.burrow_upgrade_cost(2), 80)
	assert_eq(DataDB.burrow_upgrade_cost(3), 116)
	assert_eq(DataDB.burrow_upgrade_cost(10), 1563)
	assert_eq(DataDB.burrow_upgrade_cost(11), -1)
	assert_eq(DataDB.base_upgrade_cost(2), 100)
	assert_eq(DataDB.base_upgrade_cost(10), 1954)
	assert_eq(DataDB.power_upgrade_cost(2), 150)
	assert_eq(DataDB.power_upgrade_cost(3), 240)
	assert_eq(DataDB.power_upgrade_cost(5), 614)
	assert_eq(DataDB.power_upgrade_cost(6), -1)

func test_burrow_stats() -> void:
	assert_near(DataDB.burrow_income(1), 8.0)
	assert_near(DataDB.burrow_cap(1), 500.0)
	assert_near(DataDB.burrow_income(10), 8.0 + 1.2 * 9)
	assert_near(DataDB.burrow_cap(10), 500.0 + 60.0 * 9)
	assert_near(DataDB.base_hp_mult(10), 1.9)

func test_power_levels() -> void:
	var p1 := DataDB.power_params("squirm_slam", 1)
	assert_near(p1["cooldown"], 18.0)
	assert_near(p1["effect"]["damage"], 60.0)
	var p3 := DataDB.power_params("squirm_slam", 3)
	assert_near(p3["effect"]["damage"], 74.4)
	assert_near(p3["cooldown"], 16.56)
	assert_near(p3["effect"]["radius_units"], 3.0, 0.0001, "only scaled_params grow")
	# rewind hp_fraction 0.5 x 1.48 = 0.74 at level 5, capped at 1.0
	assert_near(DataDB.power_params("rewind", 5)["effect"]["hp_fraction"], 0.74)
	assert_near(DataDB.power_params("rewind", 99)["level"] * 1.0, 5.0)

func test_counter_multipliers() -> void:
	assert_near(DataDB.counter_multiplier("fighter", "shooter"), 1.5)
	assert_near(DataDB.counter_multiplier("shooter", "heavy"), 1.5)
	assert_near(DataDB.counter_multiplier("heavy", "fighter"), 1.5)
	assert_near(DataDB.counter_multiplier("shooter", "fighter"), 0.75)
	assert_near(DataDB.counter_multiplier("heavy", "shooter"), 0.75)
	assert_near(DataDB.counter_multiplier("fighter", "heavy"), 0.75)
	assert_near(DataDB.counter_multiplier("fighter", "fighter"), 1.0)
	assert_near(DataDB.counter_multiplier("shooter", "air"), 1.5)
	assert_near(DataDB.counter_multiplier("air", "shooter"), 0.75)
	assert_near(DataDB.counter_multiplier("fighter", "support"), 1.5)

func test_air_targeting() -> void:
	assert_true(DataDB.can_hit("shooter", true))
	assert_true(not DataDB.can_hit("fighter", true))
	assert_true(not DataDB.can_hit("heavy", true))
	assert_true(DataDB.can_hit("fighter", false))

func test_rewards() -> void:
	assert_eq(DataDB.win_coins(1), 30)
	assert_eq(DataDB.win_coins(4), 36)
	assert_eq(DataDB.win_coins(50), 521)
	assert_eq(DataDB.first_clear_coins(4), 72)
	assert_eq(DataDB.loss_coins(4), 14)

func test_underdog() -> void:
	assert_eq(DataDB.underdog_stacks(0), 0)
	assert_eq(DataDB.underdog_stacks(2), 0)
	assert_eq(DataDB.underdog_stacks(3), 1)
	assert_eq(DataDB.underdog_stacks(5), 3)
	assert_eq(DataDB.underdog_stacks(50), 3)
	assert_near(DataDB.underdog_food_mult(3), 1.3)
	assert_near(DataDB.underdog_base_hp_mult(2), 1.2)

func test_offline_farm() -> void:
	assert_near(DataDB.offline_cap_hours(0), 3.0)
	assert_near(DataDB.offline_cap_hours(3), 6.0)
	assert_near(DataDB.offline_cap_hours(5), 8.0)
	assert_near(DataDB.offline_cap_hours(5, true), 10.0)
	assert_near(DataDB.offline_coins_per_minute(4), 3.6)
	assert_eq(DataDB.offline_coins(4, 161.0, 0), 579)
	# capped at 3 hours: 180 min x (2 + 0.4 x 20) = 1800
	assert_eq(DataDB.offline_coins(20, 10000.0, 0), 1800)
	assert_eq(DataDB.offline_coins(20, -5.0, 0), 0)

func test_relic_bonus_and_cap() -> void:
	assert_near(DataDB.relic_bonus("food_income", {"sticky_seed": 2}), 0.10)
	assert_near(DataDB.relic_bonus("food_income", {"sticky_seed": 99}), 0.25, 0.0001, "level clamps to max 5 x 5% = cap")
	assert_near(DataDB.relic_bonus("food_income", {"sticky_seed": 5, "echo_seashell": 4, "chrono_gear": 3}), 0.25)
	assert_near(DataDB.relic_bonus("coins", {"sticky_seed": 5}), 0.0)
	assert_near(DataDB.relic_bonus("unit_damage", {"sharp_thorn": 1, "time_crown": 1}), 0.11)

func test_lane_scale() -> void:
	assert_near(DataDB.range_to_px(5.0), 200.0)
	assert_near(DataDB.tick_dt(), 1.0 / 30.0)
	assert_eq(DataDB.bal_i("sim.lane_length_px"), 1000)

func test_balance_constants() -> void:
	assert_eq(DataDB.bal_i("battle.food_start"), 100)
	assert_near(DataDB.bal_f("battle.food_income_base"), 8.0)
	assert_eq(DataDB.bal_i("battle.food_cap_base"), 500)
	assert_near(DataDB.bal_f("battle.kill_food_return"), 0.25)
	assert_near(DataDB.bal_f("battle.counter_strong_mult"), 1.5)
	assert_near(DataDB.bal_f("battle.counter_weak_mult"), 0.75)
	assert_eq(DataDB.bal_i("battle.overtime_after_seconds"), 240)
	assert_near(DataDB.bal_f("battle.overtime_attack_mult"), 1.2)
	assert_eq(DataDB.bal_i("battle.pop_cap_per_side"), 40)
	assert_near(DataDB.bal_f("capsule.relic_bonus_cap"), 0.25)
	assert_eq(DataDB.bal_i("capsule.pity_rare_every"), 5)
	assert_eq(DataDB.bal_i("capsule.pity_epic_every"), 20)
	assert_near(DataDB.bal_f("rewards.loss_fraction"), 0.40)
	assert_eq(DataDB.bal_i("sim.ticks_per_second"), 30)

func test_role_table_matches_spec_5_4() -> void:
	var fighter := DataDB.role_base("fighter")
	assert_eq(int(fighter["cost"]), 50)
	assert_eq(int(fighter["hp"]), 100)
	assert_eq(int(DataDB.role_base("shooter")["range"]), 5)
	assert_eq(int(DataDB.role_base("heavy")["hp"]), 300)
	assert_eq(int(DataDB.role_base("support")["cost"]), 100)
	assert_eq(int(DataDB.role_base("air")["speed"]), 70)
	assert_near(float(DataDB.role_base("air")["interval"]), 1.4)
