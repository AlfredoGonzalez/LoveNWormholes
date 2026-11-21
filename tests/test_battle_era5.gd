extends TestCase
## Era 5 (Far Future: Neon Orbit) in BattleSim: gravity wells, Laser Bug beam, Drone Fly hunting Support, Mecha Beetle
## targeting, Time Medic heal, Count Magpie 3000 (steal power, teleport + bombs), stage data and the game_completed flag.

const P := "user://t_era5.json"


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


func _enemy(s: BattleSim, id := "") -> SimUnit:
	for u in s.units:
		if u.side == BattleSim.ENEMY and (id == "" or u.id == id):
			return u
	return null


func _wells(list: Array) -> Dictionary:
	return {"type": "gravity_well", "wells": list}


# ---- gravity wells

## One enemy shooter fires once at a player unit at x = 300 from x = 700; returns the damage that unit took.
func _shot_damage(rule: Dictionary, shooter_x := 700.0, target_x := 300.0) -> float:
	var shooter := _u("sh", "shooter", 1000, 10, 100.0, 12.0, 0.0, 75.0)
	var s := _sim([_u("p", "fighter", 1000, 0, 1.0, 1.0, 0.0)], {"sh": shooter}, [{"t": 0.0, "id": "sh"}], {"rule": rule})
	s.spawn_player(0)
	var tgt: SimUnit = s.units[0]
	tgt.x = target_x
	s.run(0.05)
	_enemy(s).x = shooter_x
	s.run(1.5)
	return 1000.0 - tgt.hp


func test_well_rule_is_parsed() -> void:
	var s := _sim([], {}, [], {"rule": _wells([{"x": 400.0, "w": 100.0}, {"x": 600.0, "w": 80.0}])})
	assert_eq(s.rule["type"], "gravity_well")
	assert_eq(s.wells.size(), 2)
	assert_true(s.in_well(450.0))
	assert_true(not s.in_well(550.0))
	assert_eq(_sim([], {}, []).wells.size(), 0, "no rule, no wells")
	assert_near(DataDB.bal_f("era_rules.gravity_well.damage_loss"), 0.35)


func test_projectile_crossing_a_well_loses_35_percent() -> void:
	var clear := _shot_damage({"type": "none"})
	assert_true(clear > 0.0)
	var bent := _shot_damage(_wells([{"x": 450.0, "w": 100.0}]))
	assert_near(bent / clear, 0.65, 0.01, "35%% of the damage lost crossing one well")
	var off := _shot_damage(_wells([{"x": 100.0, "w": 100.0}]))
	assert_near(off / clear, 1.0, 0.01, "a well outside the flight path changes nothing")


func test_wells_compound_and_shooter_inside_counts() -> void:
	var clear := _shot_damage({"type": "none"})
	var two := _shot_damage(_wells([{"x": 400.0, "w": 60.0}, {"x": 550.0, "w": 60.0}]))
	assert_near(two / clear, 0.65 * 0.65, 0.01, "two wells compound")
	var inside := _shot_damage(_wells([{"x": 650.0, "w": 100.0}]))
	assert_near(inside / clear, 0.65, 0.01, "a shooter standing inside a well is bent too")


func test_wells_do_not_affect_melee() -> void:
	var rule := _wells([{"x": 0.0, "w": 1000.0}])
	var s := _sim([_u("p", "fighter", 1000, 0, 1.0, 1.0, 0.0)], {"e": _u("e", "fighter", 1000, 10, 1.0, 1.0, 0.0)}, [{"t": 0.0, "id": "e"}], {"rule": rule})
	s.spawn_player(0)
	s.units[0].x = 500.0
	s.run(0.05)
	_enemy(s).x = 520.0
	s.run(1.5)
	assert_true(1000.0 - s.units[0].hp >= 10.0 - 0.001, "melee hits at full damage, got %f" % (1000.0 - s.units[0].hp))


func test_stage_5_3_carries_wells() -> void:
	var st := DataDB.stage(5, 3)
	assert_eq(str(st["rule"]["type"]), "gravity_well")
	var setup := BattleSetup.make(st, {"squad": ["p5_laser_blade_worm"]})
	var s := BattleSim.new(setup)
	assert_true(s.wells.size() >= 1)
	assert_eq(str(DataDB.stage(5, 2)["rule"]["type"]), "none")


# ---- Laser Bug beam, Drone Fly, Mecha Beetle, Time Medic

func test_laser_bug_beam_pierces_units_between() -> void:
	var bug := _u("e5_laser_bug", "shooter", 1000, 10, 100.0, 8.0, 0.0, 75.0, {"abilities": {"pierce": true, "pierce_fraction": 0.5}})
	var front := _u("front", "support", 1000, 0, 1.0, 1.0, 0.0)   # target_priority: support gets shot first, the beam crosses the others
	var back := _u("back", "support", 1000, 0, 1.0, 1.0, 0.0)
	var s := _sim([_u("a", "heavy", 1000, 0, 1.0, 1.0, 0.0), _u("b", "heavy", 1000, 0, 1.0, 1.0, 0.0), front],
			{"e": bug}, [{"t": 0.0, "id": "e"}])
	s.spawn_player(0)
	s.spawn_player(1)
	s.spawn_player(2)
	s.units[0].x = 500.0   # out of the beam (the bug at 900 reaches 8 units = 320 px, to x = 580)
	s.units[1].x = 650.0   # in the beam, behind the target
	s.units[2].x = 700.0   # the support the bug prefers
	s.run(0.05)
	_enemy(s).x = 900.0
	s.run(1.3)
	var support_dmg: float = 1000.0 - s.units[2].hp
	var heavy_dmg: float = 1000.0 - s.units[1].hp
	assert_true(support_dmg > 0.0, "target hit")
	assert_true(heavy_dmg > 0.0, "the beam also hits the unit on its line")
	assert_true(heavy_dmg < support_dmg, "pierce damage is a fraction of the main hit")
	assert_true(1000.0 - s.units[0].hp == 0.0, "units past the end of the beam are not hit")
	assert_eq(back.id, "back")


func test_drone_fly_flies_past_to_hunt_support() -> void:
	var drone := _u("e5_drone_fly", "air", 100, 20, 0.5, 1.0, 60.0, 120.0,
			{"is_air": true, "flags": {"air": true}, "abilities": {"target_priority": "support", "hunts": true}})
	var s := _sim([_u("f", "fighter", 1000, 0, 1.0, 1.0, 0.0), _u("m", "support", 1000, 0, 1.0, 4.0, 0.0)],
			{"d": drone}, [{"t": 0.0, "id": "d"}])
	s.spawn_player(0)
	s.spawn_player(1)
	s.units[0].x = 500.0   # the fighter is in the drone's way
	s.units[1].x = 300.0   # the support is behind it
	s.run(0.05)
	var d := _enemy(s)
	d.x = 520.0
	s.run(1.0)
	assert_near(1000.0 - s.units[0].hp, 0.0, 0.001, "ignores the fighter while a Support exists")
	assert_true(d.x < 500.0, "keeps flying toward the Support, x = %f" % d.x)
	d.x = 330.0
	d.hp = 100.0
	s.run(1.0)
	assert_true(1000.0 - s.units[1].hp > 0.0, "attacks the Support")


func test_drone_fly_attacks_anything_when_there_is_no_support() -> void:
	var drone := _u("e5_drone_fly", "air", 100, 20, 0.5, 1.0, 0.0, 120.0,
			{"is_air": true, "flags": {"air": true}, "abilities": {"target_priority": "support", "hunts": true}})
	var s := _sim([_u("f", "fighter", 1000, 0, 1.0, 1.0, 0.0)], {"d": drone}, [{"t": 0.0, "id": "d"}])
	s.spawn_player(0)
	s.units[0].x = 500.0
	s.run(0.05)
	_enemy(s).x = 520.0
	s.run(1.0)
	assert_true(1000.0 - s.units[0].hp > 0.0, "no Support on the field: normal targeting")


func test_drone_fly_data_and_only_shooters_hit_it() -> void:
	var st := DataDB.enemy_stats("e5_drone_fly", 5, 1)
	assert_true(bool(st["abilities"].get("hunts", false)))
	assert_eq(str(st["abilities"]["target_priority"]), "support")
	assert_true(DataDB.can_hit("shooter", true))
	assert_true(not DataDB.can_hit("fighter", true))
	assert_true(not DataDB.can_hit("heavy", true))


func test_mecha_beetle_targets_the_highest_hp_unit() -> void:
	var st := DataDB.enemy_stats("e5_mecha_beetle", 5, 1)
	assert_eq(str(st["abilities"].get("target", "")), "highest_hp")
	var beetle := _u("e5_mecha_beetle", "heavy", 1000, 10, 1.0, 1.0, 0.0, 150.0, {"abilities": {"target": "highest_hp"}})
	var s := _sim([_u("weak", "fighter", 200, 0, 1.0, 1.0, 0.0), _u("tank", "fighter", 900, 0, 1.0, 1.0, 0.0)],
			{"b": beetle}, [{"t": 0.0, "id": "b"}])
	s.spawn_player(0)
	s.spawn_player(1)
	s.units[0].x = 500.0
	s.units[1].x = 505.0
	s.run(0.05)
	_enemy(s).x = 520.0
	s.run(1.5)
	assert_near(200.0 - s.units[0].hp, 0.0, 0.001, "the weak unit is left alone")
	assert_true(900.0 - s.units[1].hp > 0.0, "the highest-HP unit is hit")


func test_time_medic_heals_5_percent_per_second() -> void:
	var st := DataDB.unit_stats("p5_time_medic_worm", 1, 5)
	assert_near(float(st["abilities"]["heal_fraction_per_sec"]), 0.05)
	var medic := _u("p5_time_medic_worm", "support", 70, 0, 1.0, 4.0, 0.0, 100.0, {"abilities": {"heal_fraction_per_sec": 0.05}, "flags": {"heal": true}})
	var s := _sim([medic, _u("f", "fighter", 100, 0, 1.0, 1.0, 0.0)], {}, [])
	s.spawn_player(0)
	s.spawn_player(1)
	s.units[0].x = 300.0
	s.units[1].x = 320.0
	s.units[1].hp = 50.0
	s.run(2.0)
	assert_near(s.units[1].hp, 60.0, 1.5, "+5%% max HP per second for 2 s")


# ---- Count Magpie 3000

func _magpie_sim(powers: Array = []) -> BattleSim:
	var boss := _u("b5_count_magpie_3000", "heavy", 100000, 100, 1.0, 1.0, 0.0, 300.0, {"is_boss": true})
	var defs := {"b5_count_magpie_3000": {"telegraph": {"id": "steal_power", "duration_s": 8},
			"phase2": {"id": "teleport_bombs", "hop_units": 4, "bomb_damage_mult": 1.0, "bomb_interval_s": 5,
					"bomb_radius_units": 2, "bomb_delay_s": 1.0}}}
	var pw: Array = []
	for pid in powers:
		pw.append({"id": pid, "cooldown": 30.0, "effect": {"food": 50.0, "duration_s": 5.0}})
	return _sim([_u("p", "fighter", 100000, 0, 1.0, 1.0, 0.0)], {"b5_count_magpie_3000": boss},
			[{"t": 0.0, "id": "b5_count_magpie_3000"}], {"boss_defs": defs, "powers": pw})


func test_magpie_steals_a_ready_power_for_8_seconds() -> void:
	var s := _magpie_sim(["apple_rain", "squirm_slam"])
	s.run(8.6)
	assert_true(s.power_ready(0) and s.power_ready(1), "nothing stolen before the first telegraph")
	assert_true(s.cast_power(0), "slot 0 cast before the steal -> it is on cooldown")
	s.run(2.0)   # 10.0 s: the telegraph fires
	assert_true(not s.power_ready(1), "the ready power (slot 1) is the one stolen")
	assert_true(not s.cast_power(1), "a stolen power cannot be cast")
	var ev := s.drain_events()
	var seen := false
	for e in ev:
		if e["type"] == "boss_attack" and e["id"] == "steal_power":
			seen = true
			assert_eq(str(e["power"]), "squirm_slam")
			assert_near(float(e["duration"]), 8.0)
	assert_true(seen, "boss_attack steal_power event")
	s.run(7.0)
	assert_true(not s.power_ready(1), "still stolen just before 8 s")
	s.run(0.7)
	assert_true(s.power_ready(1), "returned after 8 s")


func test_magpie_steal_warns_1_5_seconds_before() -> void:
	var s := _magpie_sim(["apple_rain"])
	s.run(8.7)
	var warned := false
	for e in s.drain_events():
		if e["type"] == "telegraph" and e["id"] == "steal_power":
			warned = true
	assert_true(warned, "warning icon before the steal")
	assert_true(s.power_ready(0))


func test_magpie_with_no_powers_does_not_crash() -> void:
	var s := _magpie_sim([])
	s.run(11.0)
	assert_true(s.result == "")


func test_magpie_phase2_hops_and_drops_bombs() -> void:
	var s := _magpie_sim([])
	s.spawn_player(0)
	var mine: SimUnit = null
	for u in s.units:
		if u.side == BattleSim.PLAYER:
			mine = u
	s.run(0.1)
	var boss := _enemy(s, "b5_count_magpie_3000")
	mine.x = 100.0
	boss.x = 800.0
	boss.hp = boss.max_hp * 0.4
	s.run(0.1)
	assert_true(boss.phase2, "phase 2 below 50%% HP")
	s.drain_events()
	s.run(5.1)   # the first hop and bomb after bomb_interval_s
	assert_near(boss.x, 800.0 - 160.0, 1.0, "hops 4 range units (160 px) toward the player")
	var drop := false
	for e in s.drain_events():
		if e["type"] == "bomb_drop":
			drop = true
			assert_near(float(e["x"]), mine.x, 1.0, "the bomb targets the front player unit")
	assert_true(drop)
	assert_eq(s.bombs.size(), 1)
	var hp0 := mine.hp
	s.run(1.1)
	assert_true(mine.hp < hp0 - 99.0, "the bomb exploded: 100 damage on the unit under it")
	assert_eq(s.bombs.size(), 0)


func test_magpie_never_hops_past_the_front_unit() -> void:
	var s := _magpie_sim([])
	s.spawn_player(0)
	s.run(0.1)
	var mine: SimUnit = null
	for u in s.units:
		if u.side == BattleSim.PLAYER:
			mine = u
	var boss := _enemy(s, "b5_count_magpie_3000")
	mine.x = 600.0
	boss.x = 700.0
	boss.hp = boss.max_hp * 0.4
	s.run(5.3)
	assert_true(boss.x >= mine.x + 40.0 * 1.5 - 0.5, "lands in melee reach, got %f" % boss.x)


func test_magpie_stage_builds() -> void:
	var st := DataDB.stage(5, 10)
	var setup := BattleSetup.make(st, {"squad": ["p5_laser_blade_worm"], "powers": ["squirm_slam", "apple_rain", "time_freeze"]})
	assert_true((setup["boss_defs"] as Dictionary).has("b5_count_magpie_3000"))
	assert_eq(str(setup["boss_defs"]["b5_count_magpie_3000"]["telegraph"]["id"]), "steal_power")
	assert_eq(str(setup["boss_defs"]["b5_count_magpie_3000"]["phase2"]["id"]), "teleport_bombs")
	for id in ["e5_laser_bug", "e5_drone_fly"]:
		assert_true((setup["enemy_units"] as Dictionary).has(id), id + " escort resolvable")
	assert_eq(str(setup["rule"]["type"]), "gravity_well")


# ---- stage data

func test_era5_stages_are_valid() -> void:
	var all := DataDB.stages_of_era(5)
	assert_eq(all.size(), 10)
	for st in all:
		var idx := int(st["index"])
		var n := DataDB.stage_number(5, idx)
		var label := "stage 5-%d" % idx
		assert_eq(str(st["id"]), "5-%d" % idx)
		assert_near(float(st["enemy_base_hp"]), DataDB.enemy_base_hp(n), 0.01, label + " base HP")
		assert_eq(int((st["rewards"] as Dictionary)["coins"]), DataDB.win_coins(n))
		assert_eq(bool((st["rewards"] as Dictionary)["boss"]), idx == 10)
		assert_eq(bool((st["rewards"] as Dictionary)["echo"]), idx == 5)
		assert_eq(str(st["rule"]["type"]), "none" if idx < 3 else "gravity_well", label + " rule")
		var has_boss := false
		var last_t := -1.0
		for w in st["waves"]:
			assert_true(float(w["t"]) >= last_t, label + " waves sorted")
			last_t = float(w["t"])
			if w.has("boss"):
				has_boss = true
				assert_eq(str(w["boss"]), "b5_count_magpie_3000")
			else:
				assert_true(not DataDB.enemy(str(w["enemy"])).is_empty(), label + " enemy exists")
				assert_eq(int(DataDB.enemy(str(w["enemy"]))["era"]), 5)
		assert_eq(has_boss, idx == 10)
		if idx >= 3:
			assert_true((st["rule"]["wells"] as Array).size() >= 1)
			for wl in st["rule"]["wells"]:
				assert_true(float(wl["x"]) >= 0.0 and float(wl["x"]) + float(wl["w"]) <= 1000.0, label + " well inside the lane")


func test_era5_drones_appear_from_stage_2_and_force_a_shooter() -> void:
	for idx in range(2, 10):
		var has_air := false
		for w in DataDB.stage(5, idx)["waves"]:
			if str(w.get("enemy", "")) == "e5_drone_fly":
				has_air = true
		assert_true(has_air, "stage 5-%d has Drone Flies" % idx)


func test_era5_stage_runs_headless() -> void:
	var squad := ["p1_club_worm", "p4_gear_gunner_worm", "p2_shield_bearer_worm", "p5_time_medic_worm", "p5_laser_blade_worm"]
	var setup := BattleSetup.make(DataDB.stage(5, 4), {"squad": squad, "powers": ["squirm_slam"]})
	var s := BattleSim.new(setup)
	for _i in 30 * 40:
		for c in squad.size():
			s.spawn_player(c)
		s.tick()
		if s.result != "":
			break
	assert_true(s.stats["units_spawned"] > 0)
	assert_true(s.projectiles.size() >= 0)


# ---- game_completed

func test_game_completed_flag_on_5_10_win() -> void:
	for p in [P, "user://t_era5.bak.json", P + ".tmp"]:
		if FileAccess.file_exists(p):
			DirAccess.remove_absolute(p)
	var eco := Economy.new(DataDB.balance(), SaveService.new(P))
	var prof: Dictionary = eco.profile
	assert_true(not Progress.game_completed(prof))
	assert_true(prof["progress"].has("game_completed"), "default profile has the key")
	var r := eco.settle_battle(5, 9, true, 3)
	assert_true(not bool(r["game_completed"]) and not Progress.game_completed(prof))
	r = eco.settle_battle(5, 10, false, 0)
	assert_true(not bool(r["game_completed"]) and not Progress.game_completed(prof), "a loss does not complete the game")
	r = eco.settle_battle(4, 10, true, 3)
	assert_true(not Progress.game_completed(prof), "the Era 4 boss is not the end")
	r = eco.settle_battle(5, 10, true, 3)
	assert_true(bool(r["game_completed"]), "the first 5-10 win reports it")
	assert_true(Progress.game_completed(prof))
	r = eco.settle_battle(5, 10, true, 3)
	assert_true(not bool(r["game_completed"]), "later wins do not report it again")
	assert_true(Progress.game_completed(prof), "the flag never resets")
