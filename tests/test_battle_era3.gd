extends TestCase
## Era 3 (Medieval: Kingdom of Crumbs) rules in BattleSim: base walls, Knight first-hit bonus, Wizard damage aura,
## Dung Catapult highest-HP targeting, Hornet Scout (air), Sir Sizzle fire breath and take-flight, stage data.

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


const WALLS := {"type": "walls", "hp_fraction": 0.2, "damage_mult": 0.5,
		"walls": [{"x": 52.0, "w": 20.0, "side": "player"}, {"x": 928.0, "w": 20.0, "side": "enemy"}]}


func _find(s: BattleSim, id: String) -> SimUnit:
	for u in s.units:
		if u.id == id:
			return u
	return null


# ---- walls

func test_walls_halve_damage_on_both_bases_until_they_fall() -> void:
	var s := _sim([], {}, [], {"rule": WALLS})
	assert_true(s.walls_on)
	assert_near(s.wall_hp[BattleSim.ENEMY], 200.0, 0.01, "20% of 1000")
	s._damage_base(BattleSim.ENEMY, 100.0, 900.0)
	assert_near(s.enemy_base_hp, 950.0, 0.01, "half damage while the wall stands")
	s._damage_base(BattleSim.PLAYER, 100.0, 100.0)
	assert_near(s.player_base_hp, 950.0, 0.01, "the player base has a wall too")
	s._damage_base(BattleSim.ENEMY, 300.0, 900.0)   # 150 more through the wall: wall (200) is exactly used up
	assert_near(s.enemy_base_hp, 800.0, 0.01)
	assert_true(not s.wall_up(BattleSim.ENEMY), "the wall is gone after the base lost 20% of its HP")
	assert_true(s.wall_up(BattleSim.PLAYER))
	s._damage_base(BattleSim.ENEMY, 100.0, 900.0)
	assert_near(s.enemy_base_hp, 700.0, 0.01, "full damage once the wall is down")


func test_wall_damage_that_crosses_the_wall_is_split() -> void:
	var s := _sim([], {}, [], {"rule": WALLS})
	s._damage_base(BattleSim.ENEMY, 500.0, 900.0)   # 400 raw break the wall (200 HP), 100 raw go through
	assert_near(s.enemy_base_hp, 1000.0 - 200.0 - 100.0, 0.01)
	var ev := s.drain_events()
	var downs := 0
	for e in ev:
		if e["type"] == "wall_down":
			downs += 1
	assert_eq(downs, 1, "wall_down emitted once")


func test_dirt_shield_absorbs_before_the_wall() -> void:
	var s := _sim([], {}, [], {"rule": WALLS})
	s.player_shield = 100.0
	s.player_shield_t = 5.0
	s._damage_base(BattleSim.PLAYER, 150.0, 100.0)   # 100 absorbed by the shield, 50 raw hit the wall -> 25 HP
	assert_near(s.player_base_hp, 975.0, 0.01)


func test_no_walls_without_the_rule() -> void:
	var s := _sim([], {}, [], {"rule": {"type": "none"}})
	assert_true(not s.walls_on)
	s._damage_base(BattleSim.ENEMY, 100.0, 900.0)
	assert_near(s.enemy_base_hp, 900.0, 0.01)
	var s2 := _sim([], {}, [], {"rule": {"type": "sand_patch", "patches": []}})
	s2._damage_base(BattleSim.PLAYER, 100.0, 100.0)
	assert_near(s2.player_base_hp, 900.0, 0.01)


func test_walls_work_through_real_attacks() -> void:
	var s := _sim([_u("p", "fighter", 1000, 10, 1.0, 1.0, 0.0)], {}, [], {"rule": WALLS})
	s.spawn_player(0)
	s.units[0].x = 960.0   # next to the enemy base
	s.run(3.0)
	assert_true(s.enemy_base_hp < 1000.0)
	assert_true(1000.0 - s.enemy_base_hp <= 0.5 * 10.0 * 4.0 + 0.01, "hits counted at half: %f" % (1000.0 - s.enemy_base_hp))


func test_setup_passes_walls_rule_from_stage() -> void:
	var st := DataDB.stage(3, 3)
	assert_eq(str(st["rule"]["type"]), "walls")
	var setup := BattleSetup.make(st, {"squad": ["p3_knight_worm"]})
	var s := BattleSim.new(setup)
	assert_true(s.walls_on)
	assert_near(s.wall_max[BattleSim.ENEMY], s.enemy_base_max * DataDB.bal_f("era_rules.walls.hp_fraction"), 0.01)
	assert_eq(str(DataDB.stage(3, 2)["rule"]["type"]), "none")
	assert_true(not BattleSim.new(BattleSetup.make(DataDB.stage(3, 2), {"squad": []})).walls_on)


# ---- units

func test_knight_first_hit_is_50_percent_stronger() -> void:
	var knight := _u("p3_knight_worm", "fighter", 1000, 10, 1.0, 1.0, 0.0, 100.0, {"abilities": {"first_hit_bonus": 0.5}})
	var s := _sim([knight], {}, [])
	s.spawn_player(0)
	s.units[0].x = 960.0
	s.run(0.6)
	assert_near(1000.0 - s.enemy_base_hp, 15.0, 0.01, "first hit x1.5")
	s.run(1.0)
	assert_near(1000.0 - s.enemy_base_hp, 25.0, 0.01, "then normal hits")


func test_wizard_aura_buffs_nearby_allies_15_percent() -> void:
	var wizard := _u("p3_wizard_worm", "support", 100, 0, 1.0, 4.0, 0.0, 100.0, {"abilities": {"damage_aura": 0.15}})
	var s := _sim([wizard, _u("f", "fighter", 1000, 10, 1.0, 1.0, 0.0)], {}, [])
	s.spawn_player(0)
	s.spawn_player(1)
	s.units[0].x = 950.0
	s.units[1].x = 960.0
	s.run(0.6)
	assert_near(1000.0 - s.enemy_base_hp, 11.5, 0.01, "10 x 1.15")


func test_catapult_targets_the_highest_hp_unit() -> void:
	var cat := _u("e3_dung_catapult", "shooter", 100, 10, 1.0, 8.0, 0.0, 100.0, {"abilities": {"target": "highest_hp"}})
	var s := _sim([_u("low", "fighter", 100, 0, 1.0, 1.0, 0.0), _u("big", "heavy", 900, 0, 1.0, 1.0, 0.0)],
			{"c": cat}, [{"t": 0.0, "id": "c"}])
	s.spawn_player(0)
	s.spawn_player(1)
	s.units[0].x = 800.0   # the weak one is closer
	s.units[1].x = 700.0
	s.run(3.0)
	var low := _find(s, "low")
	var big := _find(s, "big")
	assert_near(low.hp, 100.0, 0.01, "the closer weak unit is ignored")
	assert_true(big.hp < 900.0, "the high-HP unit is shot")


func test_hornet_scout_only_dies_to_shooters() -> void:
	var hornet := _u("e3_hornet_scout", "air", 50, 0, 1.0, 1.0, 0.0, 120.0, {"flags": {"air": true}})
	var s := _sim([_u("f", "fighter", 100, 50, 0.5, 1.0, 0.0), _u("s", "shooter", 100, 10, 0.5, 5.0, 0.0)],
			{"h": hornet}, [{"t": 0.0, "id": "h"}])
	s.spawn_player(0)
	s.units[s.units.size() - 1].x = 940.0
	s.run(0.1)
	var h := _find(s, "e3_hornet_scout")
	assert_true(h.is_air)
	h.x = 960.0
	s.run(2.0)
	assert_near(h.hp, 50.0, 0.01, "fighters cannot touch it")
	s.spawn_player(1)
	s.units[s.units.size() - 1].x = 940.0
	s.run(2.0)
	assert_true(h.hp < 50.0, "a shooter can")


# ---- Sir Sizzle

func _sizzle_sim(extra_squad := []) -> BattleSim:
	var boss := _u("b3_sir_sizzle", "heavy", 1000, 20, 1.0, 1.0, 0.0, 300.0, {"is_boss": true})
	var defs := {"b3_sir_sizzle": {"telegraph": {"id": "fire_breath", "segment_units": 6, "dps_mult": 0.5, "duration_s": 3},
			"phase2": {"id": "take_flight", "becomes_air": true}}}
	var squad := [_u("p", "fighter", 1000, 0, 1.0, 1.0, 0.0), _u("far", "fighter", 1000, 0, 1.0, 1.0, 0.0)]
	squad.append_array(extra_squad)
	return _sim(squad, {"b3_sir_sizzle": boss}, [{"t": 0.0, "id": "b3_sir_sizzle"}], {"boss_defs": defs})


func test_fire_breath_burns_a_lane_segment_for_three_seconds() -> void:
	var s := _sizzle_sim()
	s.run(0.1)
	var boss := _find(s, "b3_sir_sizzle")
	boss.x = 600.0
	s.spawn_player(0)
	s.spawn_player(1)
	var inside := _find(s, "p")
	inside.x = 450.0   # 6 range units = 240 px: segment is [360, 600]
	var far: SimUnit = s.units[s.units.size() - 1]
	far.x = 200.0
	s.run(10.1)
	assert_eq(s.hazards.size(), 1, "the breath is on the lane")
	assert_near(float(s.hazards[0]["x0"]), 360.0, 0.01)
	assert_near(float(s.hazards[0]["x1"]), 600.0, 0.01)
	var hp0 := inside.hp
	s.run(3.2)
	assert_near(hp0 - inside.hp, 20.0 * 0.5 * 3.0, 3.0, "dps = boss damage x 0.5 for 3 s")
	assert_near(far.hp, 1000.0, 0.01, "units outside the segment are safe")
	assert_eq(s.hazards.size(), 0, "the fire dies out")


func test_sizzle_takes_flight_at_half_hp_and_only_shooters_hit_him() -> void:
	var shooter := _u("sh", "shooter", 100, 10, 0.5, 6.0, 0.0)
	var s := _sizzle_sim([shooter])
	s.run(0.1)
	var boss := _find(s, "b3_sir_sizzle")
	assert_true(not boss.is_air)
	boss.hp = boss.max_hp * 0.4
	s.run(0.1)
	assert_true(boss.phase2 and boss.is_air, "phase 2: he flies")
	boss.x = 600.0
	s.spawn_player(0)
	s.units[s.units.size() - 1].x = 580.0
	s.units[s.units.size() - 1].damage = 500.0
	s.run(1.5)
	assert_near(boss.hp, boss.max_hp * 0.4, 0.5, "a fighter cannot hit the flying boss")
	s.spawn_player(2)
	s.units[s.units.size() - 1].x = 560.0
	s.run(1.5)
	assert_true(boss.hp < boss.max_hp * 0.4 - 5.0, "a shooter can")


func test_era3_stage_data() -> void:
	var st := DataDB.stages_of_era(3)
	assert_eq(st.size(), 10)
	for s in st:
		var idx := int(s["index"])
		assert_eq(str(s["id"]), "3-%d" % idx)
		assert_eq(str(s["rule"]["type"]), "walls" if idx >= 3 else "none")
		assert_eq(bool(s["rewards"]["boss"]), idx == 10)
		for w in s["waves"]:
			if w.has("boss"):
				assert_eq(str(w["boss"]), "b3_sir_sizzle")
			else:
				assert_true(str(w["enemy"]).begins_with("e3_"), "era 3 enemies only")
		if idx == 10:
			var setup := BattleSetup.make(s, {"squad": ["p3_knight_worm"]})
			assert_true((setup["boss_defs"] as Dictionary).has("b3_sir_sizzle"))
			assert_true((setup["enemy_units"] as Dictionary).has("e3_beetle_knight"))
			assert_true((setup["enemy_units"] as Dictionary).has("e3_dung_catapult"))
		assert_near(float(s["enemy_base_hp"]), DataDB.enemy_base_hp(20 + idx), 0.01)
	# From stage 4 on every stage carries air units (they force a Shooter in the squad, spec 4.7).
	for s in st:
		if int(s["index"]) >= 3 and int(s["index"]) < 10:
			var has_air := false
			for w in s["waves"]:
				if str(w.get("enemy", "")) == "e3_hornet_scout":
					has_air = true
			assert_true(has_air, "stage %s has hornets" % s["id"])


func test_era3_stage_runs_headless() -> void:
	var setup := BattleSetup.make(DataDB.stage(3, 4), {"squad": ["p3_knight_worm", "p3_crossbow_worm"], "powers": ["squirm_slam"]})
	var s := BattleSim.new(setup)
	for i in 600:
		s.spawn_player(0)
		s.tick()
	assert_true(s.units.size() > 0)
