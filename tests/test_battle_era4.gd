extends TestCase
## Era 4 (Industrial: Steam City) rules in BattleSim: steam vents (+25% attack speed), Boiler Tank splash,
## Spark Fly chain shock, Clank Crab frontal armor, Cog Roach speed, Clockwork Queen steam burst and spawn_cogs, stage data.

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


func _find(s: BattleSim, id: String) -> SimUnit:
	for u in s.units:
		if u.id == id:
			return u
	return null


func _count(s: BattleSim, id: String) -> int:
	var n := 0
	for u in s.units:
		if u.id == id and u.alive():
			n += 1
	return n


# ---- steam vents

func _hits_on_dummy(on_vent: bool, rule: Dictionary) -> float:
	var shooter := _u("g", "fighter", 100, 1.0, 2.0, 1.0, 0.0)
	var dummy := _u("d", "heavy", 1.0e7, 0, 1.0, 1.0, 0.0)
	var s := _sim([shooter], {"d": dummy}, [{"t": 0.0, "id": "d"}], {"rule": rule})
	s.spawn_player(0)
	s.units[s.units.size() - 1].x = 500.0 if on_vent else 100.0
	s.run(0.1)
	_find(s, "d").x = (520.0 if on_vent else 120.0)
	var d := _find(s, "d")
	s.run(60.0)
	return 1.0e7 - d.hp


func test_steam_vent_gives_25_percent_attack_speed() -> void:
	var rule := {"type": "steam_vent", "vents": [{"x": 450.0, "w": 120.0}]}
	var on := _hits_on_dummy(true, rule)
	var off := _hits_on_dummy(false, rule)
	assert_true(off > 0.0)
	assert_near(on / off, 1.25, 0.04, "attack speed +25%% on the vent (%f vs %f)" % [on, off])


func test_vent_flags_and_none_rule() -> void:
	var s := _sim([_u("p", "fighter", 100, 1, 1.0, 1.0, 0.0)], {}, [], {"rule": {"type": "steam_vent", "vents": [{"x": 300.0, "w": 100.0}]}})
	assert_eq(s.vents.size(), 1)
	s.spawn_player(0)
	var u: SimUnit = s.units[0]
	u.x = 350.0
	s.run(0.1)
	assert_true(u.in_vent)
	u.x = 100.0
	s.run(0.1)
	assert_true(not u.in_vent)
	var s2 := _sim([_u("p", "fighter", 100, 1, 1.0, 1.0, 0.0)], {}, [], {"rule": {"type": "none"}})
	assert_eq(s2.vents.size(), 0)


func _enemy_damage(rule: Dictionary) -> float:
	var foe := _u("e", "fighter", 100, 1.0, 2.0, 1.0, 0.0)
	var s := _sim([_u("t", "heavy", 1.0e7, 0, 1.0, 1.0, 0.0)], {"e": foe}, [{"t": 0.0, "id": "e"}], {"rule": rule})
	s.spawn_player(0)
	s.units[0].x = 960.0
	s.run(60.0)
	return 1.0e7 - s.units[0].hp


func test_vents_also_help_enemies() -> void:
	var on := _enemy_damage({"type": "steam_vent", "vents": [{"x": 0.0, "w": 1000.0}]})
	var off := _enemy_damage({"type": "none"})
	assert_true(off > 0.0)
	assert_near(on / off, 1.25, 0.04, "enemy attacks 25%% faster on a vent")


func test_setup_passes_vents_from_stage() -> void:
	var st := DataDB.stage(4, 3)
	assert_eq(str(st["rule"]["type"]), "steam_vent")
	var s := BattleSim.new(BattleSetup.make(st, {"squad": ["p3_knight_worm"]}))
	assert_true(s.vents.size() > 0)
	assert_near(DataDB.bal_f("era_rules.steam_vent.attack_speed_bonus"), 0.25)
	assert_eq(str(DataDB.stage(4, 2)["rule"]["type"]), "none")


# ---- units

func test_boiler_tank_splashes_half_damage_on_neighbours() -> void:
	var tank := _u("p4_boiler_tank_worm", "heavy", 1000, 40, 1.0, 1.0, 0.0, 200.0, {"abilities": {"splash_radius_units": 1.5}})
	var foes := {"a": _u("a", "fighter", 1000, 0, 1.0, 1.0, 0.0), "b": _u("b", "fighter", 1000, 0, 1.0, 1.0, 0.0),
			"c": _u("c", "fighter", 1000, 0, 1.0, 1.0, 0.0)}
	var s := _sim([tank], foes, [{"t": 0.0, "id": "a"}, {"t": 0.0, "id": "b"}, {"t": 0.0, "id": "c"}])
	s.spawn_player(0)
	s.run(0.1)
	s.units[0].x = 600.0
	_find(s, "a").x = 620.0
	_find(s, "b").x = 640.0   # within 1.5 units (60 px) of the target
	_find(s, "c").x = 800.0
	s.run(0.5)
	var a := _find(s, "a")
	var b := _find(s, "b")
	assert_true(a.hp < 1000.0)
	assert_near(1000.0 - b.hp, (1000.0 - a.hp) * 0.5, 0.5, "splash is half")
	assert_near(_find(s, "c").hp, 1000.0, 0.01, "far unit untouched")


func test_spark_fly_chains_to_two_nearby_units() -> void:
	var fly := _u("e4_spark_fly", "air", 100, 20, 1.0, 1.0, 0.0, 120.0,
			{"flags": {"air": true}, "abilities": {"chain_targets": 2, "chain_radius_units": 2, "chain_damage_fraction": 0.5}})
	var guys := []
	for i in 4:
		guys.append(_u("g%d" % i, "fighter", 1000, 0, 1.0, 1.0, 0.0))
	var s := _sim(guys, {"f": fly}, [{"t": 0.0, "id": "f"}])
	for i in 4:
		s.spawn_player(i)
	s.units[0].x = 900.0   # the target (closest to the fly)
	s.units[1].x = 880.0
	s.units[2].x = 860.0
	s.units[3].x = 700.0   # out of the chain radius
	s.run(0.1)
	_find(s, "e4_spark_fly").x = 940.0
	s.run(0.45)
	assert_true(s.units[0].hp < 1000.0, "target hit")
	var main: float = 1000.0 - s.units[0].hp
	assert_near(1000.0 - s.units[1].hp, main * 0.5, 0.1, "first chained unit")
	assert_near(1000.0 - s.units[2].hp, main * 0.5, 0.1, "second chained unit")
	assert_near(s.units[3].hp, 1000.0, 0.01, "out of range")


func test_chain_shock_stops_at_chain_targets() -> void:
	var fly := _u("e4_spark_fly", "air", 100, 20, 1.0, 1.0, 0.0, 120.0,
			{"flags": {"air": true}, "abilities": {"chain_targets": 1, "chain_radius_units": 3, "chain_damage_fraction": 0.5}})
	var s := _sim([_u("g", "fighter", 1000, 0, 1.0, 1.0, 0.0), _u("h", "fighter", 1000, 0, 1.0, 1.0, 0.0), _u("i", "fighter", 1000, 0, 1.0, 1.0, 0.0)],
			{"f": fly}, [{"t": 0.0, "id": "f"}])
	s.spawn_player(0)
	s.spawn_player(1)
	s.spawn_player(2)
	s.units[0].x = 900.0
	s.units[1].x = 880.0
	s.units[2].x = 870.0
	s.run(0.1)
	_find(s, "e4_spark_fly").x = 940.0
	s.run(0.45)
	assert_true(s.units[1].hp < 1000.0)
	assert_near(s.units[2].hp, 1000.0, 0.01, "only one chained target")


func test_clank_crab_frontal_armor() -> void:
	var crab := _u("e4_clank_crab", "heavy", 1000, 0, 1.0, 1.0, 0.0, 300.0, {"abilities": {"frontal_armor_fraction": 0.25}})
	var s := _sim([_u("p", "fighter", 1000, 100, 1.0, 1.0, 0.0)], {"c": crab}, [{"t": 0.0, "id": "c"}])
	s.spawn_player(0)
	s.run(0.1)
	var c := _find(s, "e4_clank_crab")
	c.x = 500.0
	s.units[0].x = 480.0   # the player comes from the front (its own side)
	s.run(0.5)
	assert_true(c.hp < 1000.0)
	var from_front := 1000.0 - c.hp
	# From behind (player unit past the crab): full damage.
	var s2 := _sim([_u("p", "fighter", 1000, 100, 1.0, 1.0, 0.0)], {"c": crab}, [{"t": 0.0, "id": "c"}])
	s2.spawn_player(0)
	s2.run(0.1)
	var c2 := _find(s2, "e4_clank_crab")
	c2.x = 500.0
	s2.units[0].x = 520.0
	s2.run(0.5)
	assert_near(from_front / (1000.0 - c2.hp), 0.75, 0.01, "25%% less from the front")


func test_cog_roach_is_fast() -> void:
	var st := DataDB.enemy_stats("e4_cog_roach", 4, 1)
	assert_near(float(st["speed"]), 80.0)
	var s := _sim([], {"r": st}, [{"t": 0.0, "id": "r"}])
	s.run(1.0)
	var r := _find(s, "e4_cog_roach")
	assert_near(970.0 - r.x, 80.0, 3.0)


# ---- Clockwork Queen

func _queen_sim() -> BattleSim:
	var boss := _u("b4_clockwork_queen", "heavy", 1000, 30, 1.0, 1.0, 0.0, 400.0, {"is_boss": true})
	var cog := _u("e4_cog_roach", "fighter", 50, 0, 1.0, 1.0, 0.0)
	var defs := {"b4_clockwork_queen": {
			"telegraph": {"id": "steam_burst", "radius_units": 4, "slow_fraction": 0.3, "slow_seconds": 3, "damage_mult": 1.0},
			"phase2": {"id": "spawn_cogs", "enemy": "e4_cog_roach", "interval_s": 8, "count": 1}}}
	return _sim([_u("near", "fighter", 1000, 0, 1.0, 1.0, 0.0), _u("far", "fighter", 1000, 0, 1.0, 1.0, 0.0)],
			{"b4_clockwork_queen": boss, "e4_cog_roach": cog}, [{"t": 0.0, "id": "b4_clockwork_queen"}], {"boss_defs": defs})


func test_steam_burst_damages_and_slows_nearby_units() -> void:
	var s := _queen_sim()
	s.run(0.1)
	var q := _find(s, "b4_clockwork_queen")
	q.x = 700.0
	s.spawn_player(0)
	s.spawn_player(1)
	var near := _find(s, "near")
	var far: SimUnit = s.units[s.units.size() - 1]
	near.x = 600.0   # 100 px: inside 4 units (160 px)
	far.x = 300.0
	s.run(9.8)
	var hp_far := far.hp
	assert_near(near.hp, 1000.0, 0.01, "not yet")
	s.run(0.5)
	assert_near(1000.0 - near.hp, 30.0, 0.5, "boss damage x 1.0")
	assert_near(far.hp, hp_far, 0.01, "outside the radius")
	assert_near(near.slow, 0.3, 0.001, "slowed 30%")
	assert_near(far.slow, 0.0, 0.001)
	s.run(2.0)
	assert_near(near.slow, 0.3, 0.001, "still slowed after 2 s")
	s.run(1.5)
	assert_near(near.slow, 0.0, 0.001, "the slow wears off after 3 s")


func test_queen_spawns_a_cog_roach_every_8s_in_phase_2() -> void:
	var s := _queen_sim()
	s.run(0.1)
	var q := _find(s, "b4_clockwork_queen")
	q.x = 900.0
	s.run(7.0)
	assert_eq(_count(s, "e4_cog_roach"), 0, "no cogs in phase 1")
	q.hp = q.max_hp * 0.4
	s.run(0.2)
	assert_true(q.phase2)
	assert_eq(_count(s, "e4_cog_roach"), 1, "first cog right at phase 2")
	s.run(8.1)
	assert_eq(_count(s, "e4_cog_roach"), 2)
	s.run(8.0)
	assert_eq(_count(s, "e4_cog_roach"), 3)


func test_era4_stage_data() -> void:
	var st := DataDB.stages_of_era(4)
	assert_eq(st.size(), 10)
	for s in st:
		var idx := int(s["index"])
		assert_eq(str(s["id"]), "4-%d" % idx)
		assert_eq(str(s["rule"]["type"]), "steam_vent" if idx >= 3 else "none")
		if idx >= 3:
			assert_true((s["rule"]["vents"] as Array).size() >= 1)
		assert_eq(bool(s["rewards"]["boss"]), idx == 10)
		for w in s["waves"]:
			if w.has("boss"):
				assert_eq(str(w["boss"]), "b4_clockwork_queen")
			else:
				assert_true(str(w["enemy"]).begins_with("e4_"), "era 4 enemies only")
		if idx == 10:
			var setup := BattleSetup.make(s, {"squad": ["p3_knight_worm"]})
			assert_true((setup["boss_defs"] as Dictionary).has("b4_clockwork_queen"))
			assert_true((setup["enemy_units"] as Dictionary).has("e4_cog_roach"))
			assert_true((setup["enemy_units"] as Dictionary).has("e4_clank_crab"))
		assert_near(float(s["enemy_base_hp"]), DataDB.enemy_base_hp(30 + idx), 0.01)


func test_era4_stage_runs_headless() -> void:
	var setup := BattleSetup.make(DataDB.stage(4, 5), {"squad": ["p3_knight_worm", "p4_gear_gunner_worm"], "powers": ["squirm_slam"]})
	var s := BattleSim.new(setup)
	for i in 600:
		s.spawn_player(0)
		s.tick()
	assert_true(s.units.size() > 0)
