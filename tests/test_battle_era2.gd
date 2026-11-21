extends TestCase
## Era 2 (Ancient Egypt) rules in BattleSim: sand patches, Locust Archer jump-back, Mummy Moth heal,
## Shield Bearer block, Cobra Charmer slow aura, Pharaoh Scarab summon and sandstorm.

func _u(id: String, role: String, hp: float, dmg: float, interval := 1.0, range_units := 1.0, speed := 60.0, cost := 50.0, extra := {}) -> Dictionary:
	var d := {"id": id, "role": role, "hp": hp, "damage": dmg, "interval": interval, "range": range_units,
			"range_px": range_units * 40.0, "speed": speed, "cost": cost, "spawn_cooldown": 2.0,
			"flags": {}, "abilities": {}}
	d.merge(extra, true)
	return d


func _sim(squad: Array, enemies: Dictionary, spawns: Array, extra := {}) -> BattleSim:
	var setup := {"player_base_hp": 1000.0, "enemy_base_hp": 1000.0, "food_start": 1000.0, "food_income": 0.0,
			"food_cap": 2000.0, "squad": squad, "enemy_units": enemies, "spawns": spawns, "powers": [], "boss_defs": {}}
	setup.merge(extra, true)
	return BattleSim.new(setup)


func _enemy(s: BattleSim) -> SimUnit:
	for u in s.units:
		if u.side == BattleSim.ENEMY:
			return u
	return null


# ---- sand patches

func test_sand_patch_slows_30_percent_while_standing_on_it() -> void:
	var rule := {"type": "sand_patch", "patches": [{"x": 300.0, "w": 200.0}]}
	var s := _sim([_u("p", "fighter", 100, 1, 1.0, 1.0, 60.0)], {}, [], {"rule": rule})
	assert_eq(s.rule["type"], "sand_patch")
	assert_eq(s.patches.size(), 1)
	s.spawn_player(0)
	var u: SimUnit = s.units[0]
	u.x = 100.0
	s.run(1.0)
	assert_near(u.x, 160.0, 2.5, "full speed off the patch")
	u.x = 350.0
	s.run(1.0)
	assert_near(u.x, 350.0 + 60.0 * 0.7, 2.5, "30% slower on the patch")
	assert_true(u.in_sand)


func test_sand_patch_slows_enemies_too_and_none_rule_does_not() -> void:
	var enemies := {"e": _u("e", "fighter", 100, 1, 1.0, 1.0, 60.0)}
	var rule := {"type": "sand_patch", "patches": [{"x": 600.0, "w": 400.0}]}
	var s := _sim([], enemies, [{"t": 0.0, "id": "e"}], {"rule": rule})
	s.run(1.0)
	assert_near(_enemy(s).x, 970.0 - 42.0, 2.5, "enemy slowed on sand")
	var s2 := _sim([], enemies, [{"t": 0.0, "id": "e"}], {"rule": {"type": "none"}})
	s2.run(1.0)
	assert_near(_enemy(s2).x, 970.0 - 60.0, 2.5, "no rule, no slow")
	assert_eq(s2.patches.size(), 0)


func test_setup_passes_rule_from_stage() -> void:
	var st := DataDB.stage(2, 3)
	var setup := BattleSetup.make(st, {"squad": ["p1_club_worm", "p2_bow_worm"]})
	assert_eq(str(setup["rule"]["type"]), "sand_patch")
	var s := BattleSim.new(setup)
	assert_true(s.patches.size() > 0)
	assert_near(float(DataDB.bal_f("era_rules.sand_patch.slow_fraction")), 0.3)
	var setup1 := BattleSetup.make(DataDB.stage(1, 3), {"squad": ["p1_club_worm"]})
	assert_eq(str(setup1["rule"]["type"]), "none")


# ---- Locust Archer

func test_locust_archer_jumps_back_after_shooting() -> void:
	var archer := _u("e2_locust_archer", "shooter", 100, 5, 1.0, 5.0, 0.0, 75.0, {"abilities": {"jump_back_units": 2}})
	var s := _sim([_u("p", "fighter", 1000, 1, 1.0, 1.0, 0.0)], {"a": archer}, [{"t": 0.0, "id": "a"}])
	s.spawn_player(0)
	s.units[0].x = 700.0
	s.run(0.05)
	var a: SimUnit = _enemy(s)
	a.x = 850.0
	var x0 := a.x
	s.run(0.5)
	assert_near(a.x, x0 + 80.0, 0.01, "2 range units (80 px) back, away from the player")


func test_locust_archer_never_leaves_its_base_side() -> void:
	var archer := _u("e2_locust_archer", "shooter", 100, 5, 0.5, 5.0, 0.0, 75.0, {"abilities": {"jump_back_units": 2}})
	var s := _sim([_u("p", "fighter", 1000, 1, 1.0, 1.0, 0.0)], {"a": archer}, [{"t": 0.0, "id": "a"}])
	s.spawn_player(0)
	s.units[0].x = 800.0
	s.run(0.05)
	var a: SimUnit = _enemy(s)   # spawns at 970, the enemy limit
	s.run(3.0)
	assert_true(a.x <= 970.0 + 0.01, "clamped to the spawn side, got %f" % a.x)


# ---- supports and blockers

func test_mummy_moth_heals_allies_in_range() -> void:
	var moth := _u("e2_mummy_moth", "support", 70, 0, 1.0, 4.0, 0.0, 100.0, {"abilities": {"heal_fraction_per_sec": 0.05}, "flags": {"heal": true}})
	var ally := _u("f", "fighter", 100, 0, 1.0, 1.0, 0.0)
	var s := _sim([], {"m": moth, "f": ally}, [{"t": 0.0, "id": "m"}, {"t": 0.0, "id": "f"}])
	s.run(0.1)
	var f: SimUnit = null
	for u in s.units:
		if u.id == "f":
			f = u
	f.hp = 50.0
	s.run(2.0)
	assert_true(f.hp > 50.0 + 8.0, "healed about 5%% per second, hp %f" % f.hp)
	assert_true(f.hp < 100.0)


func test_shield_bearer_blocks_20_percent_of_ranged() -> void:
	var shield := _u("p2_shield_bearer_worm", "heavy", 1000, 0, 1.0, 1.0, 0.0, 150.0, {"abilities": {"block_ranged_fraction": 0.2}})
	var plain := _u("h", "heavy", 1000, 0, 1.0, 1.0, 0.0, 150.0)
	var shooter := _u("e", "shooter", 100, 10, 1.0, 5.0, 0.0, 75.0)
	var lost := []
	for card in [shield, plain]:
		var s := _sim([card], {"e": shooter}, [{"t": 0.0, "id": "e"}])
		s.spawn_player(0)
		s.units[0].x = 800.0
		s.run(0.1)
		_enemy(s).x = 900.0
		s.run(3.0)
		lost.append(1000.0 - s.units[0].hp)
	assert_true(lost[1] > 0.0)
	assert_near(lost[0] / lost[1], 0.8, 0.02, "20%% of ranged damage blocked")


func test_cobra_charmer_slows_enemies_20_percent() -> void:
	var cobra := _u("p2_cobra_charmer_worm", "support", 70, 0, 1.0, 4.0, 0.0, 100.0, {"abilities": {"slow_fraction": 0.2}})
	var s := _sim([cobra], {"e": _u("e", "fighter", 100, 0, 1.0, 1.0, 60.0)}, [{"t": 0.0, "id": "e"}])
	s.spawn_player(0)
	s.units[0].x = 800.0
	s.run(0.1)
	var e := _enemy(s)
	e.x = 900.0
	s.run(1.0)
	assert_near(e.x, 900.0 - 60.0 * 0.8, 6.0, "enemy inside the aura walks 20% slower")


# ---- Pharaoh Scarab

func _pharaoh_sim() -> BattleSim:
	var boss := _u("b2_pharaoh_scarab", "heavy", 1000, 0, 1.0, 1.0, 60.0, 300.0, {"is_boss": true})
	var scarab := _u("e2_scarab_soldier", "fighter", 50, 0, 1.0, 1.0, 60.0)
	var defs := {"b2_pharaoh_scarab": {"telegraph": {"id": "summon", "enemy": "e2_scarab_soldier", "count": 3},
			"phase2": {"id": "sandstorm", "slow_fraction": 0.3}}}
	return _sim([_u("p", "fighter", 1000, 0, 1.0, 1.0, 60.0)], {"b2_pharaoh_scarab": boss, "e2_scarab_soldier": scarab},
			[{"t": 0.0, "id": "b2_pharaoh_scarab"}], {"boss_defs": defs})


func _count(s: BattleSim, id: String) -> int:
	var n := 0
	for u in s.units:
		if u.id == id:
			n += 1
	return n


func test_pharaoh_summons_three_scarabs_every_10s() -> void:
	var s := _pharaoh_sim()
	s.run(10.2)
	assert_eq(_count(s, "e2_scarab_soldier"), 3, "first summon at 10 s")
	s.run(10.0)
	assert_eq(_count(s, "e2_scarab_soldier"), 6, "second summon at 20 s")


func test_sandstorm_slows_both_sides_and_ends_with_the_boss() -> void:
	var s := _pharaoh_sim()
	s.run(0.1)
	var boss: SimUnit = _enemy(s)
	s.spawn_player(0)
	var mine: SimUnit = s.units[s.units.size() - 1]
	boss.hp = boss.max_hp * 0.4
	s.run(0.1)
	assert_true(boss.phase2, "phase 2 below 50% HP")
	mine.x = 100.0
	boss.x = 800.0
	s.run(1.0)
	assert_near(mine.x, 100.0 + 60.0 * 0.7, 3.0, "player unit slowed 30%")
	assert_near(800.0 - boss.x, 60.0 * 0.7, 3.0, "enemy unit slowed 30% too (the whole lane)")
	boss.hp = 0.0
	boss.state = SimUnit.State.DIE
	s.run(0.2)
	var x1 := mine.x
	s.run(1.0)
	assert_near(mine.x - x1, 60.0, 3.0, "storm over once the Pharaoh is dead")


func test_era2_boss_stage_builds_with_escorts() -> void:
	var st := DataDB.stage(2, 10)
	var setup := BattleSetup.make(st, {"squad": ["p1_club_worm"]})
	assert_true((setup["boss_defs"] as Dictionary).has("b2_pharaoh_scarab"))
	assert_true((setup["enemy_units"] as Dictionary).has("e2_locust_archer"))
	assert_true((setup["enemy_units"] as Dictionary).has("e2_scarab_soldier"))
