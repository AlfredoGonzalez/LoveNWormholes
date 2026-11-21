extends TestCase
## Combat rules (spec 4). Units are hand-made stat dictionaries so the tests do not depend on tuning.

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


func test_spawn_costs_food_and_starts_cooldown() -> void:
	var s := _sim([_u("p", "fighter", 100, 10)], {}, [])
	assert_true(s.spawn_player(0))
	assert_near(s.food, 950.0)
	assert_true(not s.card_ready(0), "card cooling down")
	assert_true(not s.spawn_player(0))
	s.run(2.1)
	assert_true(s.card_ready(0))


func test_cannot_spawn_without_food() -> void:
	var s := _sim([_u("p", "fighter", 100, 10, 1.0, 1.0, 60.0, 50.0)], {}, [], {"food_start": 49.0})
	assert_true(not s.spawn_player(0))


func test_food_income_and_cap() -> void:
	var s := _sim([], {}, [], {"food_start": 0.0, "food_income": 8.0, "food_cap": 20.0})
	s.run(1.0)
	assert_near(s.food, 8.0, 0.3)
	s.run(10.0)
	assert_near(s.food, 20.0)


func test_population_cap() -> void:
	var s := _sim([_u("p", "fighter", 100, 10, 1.0, 1.0, 60.0, 1.0)], {}, [], {"food_start": 100000.0, "food_cap": 100000.0})
	var n := 0
	for i in 60:
		s.cards[0]["cd"] = 0.0
		if s.spawn_player(0):
			n += 1
	assert_eq(n, 40)


func test_melee_duel_is_decided_by_stats() -> void:
	var enemies := {"e": _u("e", "fighter", 50, 10, 1.0)}
	var s := _sim([_u("p", "fighter", 200, 10, 1.0)], enemies, [{"t": 0.0, "id": "e"}])
	s.spawn_player(0)
	s.run(20.0)
	assert_eq(s.stats["kills"], 1)
	var alive := s.alive_units(BattleSim.PLAYER)
	assert_eq(alive.size(), 1)
	assert_true(alive[0].hp > 0.0 and alive[0].hp < 200.0)


func test_counter_multiplier_applied() -> void:
	# A shooter hits a heavy for 1.5x and a fighter for 0.75x (spec 4.4).
	var enemies := {"h": _u("h", "heavy", 1000, 0, 1.0, 1.0, 0.0), "f": _u("f", "fighter", 1000, 0, 1.0, 1.0, 0.0)}
	var s := _sim([_u("p", "shooter", 100, 10, 1.0, 5.0, 0.0)], enemies, [{"t": 0.0, "id": "h"}])
	s.spawn_player(0)
	s.units[0].x = 700.0
	s.run(0.2)
	var h: SimUnit = null
	for u in s.units:
		if u.side == BattleSim.ENEMY:
			h = u
	h.x = 800.0
	s.run(2.0)
	assert_near(h.max_hp - h.hp, 15.0 * 2.0, 15.1, "heavy took counter damage")
	assert_true(h.max_hp - h.hp >= 15.0, "at least one 1.5x hit")
	var s2 := _sim([_u("p", "shooter", 100, 10, 1.0, 5.0, 0.0)], {"f": _u("f", "fighter", 1000, 0, 1.0, 1.0, 0.0)}, [{"t": 0.0, "id": "f"}])
	s2.spawn_player(0)
	s2.units[0].x = 700.0
	s2.run(0.2)
	var f: SimUnit = s2.units[1]
	f.x = 800.0
	s2.run(1.5)
	assert_near(f.max_hp - f.hp, 7.5, 0.01, "fighter takes 0.75x")


func test_win_when_enemy_base_destroyed() -> void:
	var s := _sim([_u("p", "fighter", 100, 100, 0.5)], {}, [], {"enemy_base_hp": 200.0})
	s.spawn_player(0)
	s.run(60.0)
	assert_eq(s.result, "win")
	assert_true(s.enemy_base_hp <= 0.0)


func test_lose_when_player_base_destroyed() -> void:
	var s := _sim([], {"e": _u("e", "fighter", 100, 200, 0.5, 1.0, 100.0)}, [{"t": 0.0, "id": "e"}], {"player_base_hp": 300.0})
	s.run(60.0)
	assert_eq(s.result, "lose")


func test_kill_returns_quarter_of_cost() -> void:
	var s := _sim([_u("p", "fighter", 500, 100, 0.5)], {"e": _u("e", "fighter", 10, 0, 1.0, 1.0, 0.0, 200.0)}, [{"t": 0.0, "id": "e"}], {"food_start": 100.0, "food_cap": 500.0})
	s.spawn_player(0)
	s.run(30.0)
	assert_eq(s.stats["kills"], 1)
	assert_near(s.food, 50.0 + 200.0 * 0.25, 0.01)


func test_ranged_hits_before_melee_arrives() -> void:
	var enemies := {"e": _u("e", "fighter", 1000, 5, 1.0, 1.0, 40.0)}
	var s := _sim([_u("p", "shooter", 100, 20, 1.0, 5.0, 0.0)], enemies, [{"t": 0.0, "id": "e"}])
	s.spawn_player(0)
	s.run(20.0)
	var e: SimUnit = null
	for u in s.units:
		if u.side == BattleSim.ENEMY:
			e = u
	assert_true(e != null and e.hp < e.max_hp)


func test_air_units_only_hit_by_shooters() -> void:
	var enemies := {"a": _u("a", "air", 100, 0, 1.0, 1.0, 0.0, 50.0, {"flags": {"air": true}})}
	var s := _sim([_u("f", "fighter", 100, 50, 0.5)], enemies, [{"t": 0.0, "id": "a"}])
	s.spawn_player(0)
	s.run(10.0)
	assert_eq(s.stats["kills"], 0, "a fighter cannot hit air")
	var s2 := _sim([_u("sh", "shooter", 100, 50, 0.5, 5.0)], enemies, [{"t": 0.0, "id": "a"}])
	s2.spawn_player(0)
	s2.run(20.0)
	assert_eq(s2.stats["kills"], 1, "a shooter can")


func test_overtime_boosts_enemy_attack() -> void:
	var hits: Array = []
	for t0 in [0.0, 245.0]:
		var s := _sim([], {"e": _u("e", "fighter", 100, 10, 1.0, 1.0, 0.0)}, [{"t": 0.0, "id": "e"}], {"player_base_hp": 100000.0})
		s.time = t0
		s.tick()
		s.units[0].x = 40.0   # in reach of the player base at x = 0
		var dmg := 0.0
		for _i in 40:
			s.tick()
			for ev in s.drain_events():
				if ev["type"] == "base_hit" and dmg == 0.0:
					dmg = ev["damage"]
		hits.append(dmg)
	assert_near(hits[0], 10.0, 0.01)
	assert_near(hits[1], 12.0, 0.01, "10 x 1.2 after 4 minutes")


func test_support_slows_and_buffs_and_heals() -> void:
	var sup := _u("w", "support", 100, 0, 1.0, 4.0, 0.0, 100.0, {"abilities": {"damage_aura": 0.15, "slow_fraction": 0.2, "heal_fraction_per_sec": 0.1}})
	var s := _sim([sup, _u("f", "fighter", 100, 10, 1.0, 1.0, 0.0)], {"e": _u("e", "fighter", 100, 0, 1.0, 1.0, 100.0)}, [{"t": 0.5, "id": "e"}])
	s.spawn_player(0)
	s.spawn_player(1)
	s.units[1].hp = 50.0
	s.run(0.2)
	assert_near(s.units[1].dmg_buff, 0.15)
	assert_true(s.units[1].hp > 50.0, "healed")


func test_shield_bearer_blocks_ranged() -> void:
	var tank := _u("t", "heavy", 1000, 0, 1.0, 1.0, 0.0, 150.0, {"abilities": {"block_ranged_fraction": 0.2}})
	var s := _sim([tank], {"a": _u("a", "shooter", 100, 10, 1.0, 5.0, 0.0)}, [{"t": 0.0, "id": "a"}])
	s.spawn_player(0)
	s.units[0].x = 700.0
	s.run(0.1)
	s.units[1].x = 800.0
	s.run(1.5)
	# shooter vs heavy: 10 x 1.5 counter... heavy is strong vs fighter, weak vs shooter -> 1.5; 20% blocked -> 12
	assert_near(s.units[0].max_hp - s.units[0].hp, 12.0, 0.01)


func test_squirm_slam_damages_and_stuns() -> void:
	var enemies := {"e": _u("e", "fighter", 200, 5, 1.0, 1.0, 0.0)}
	var power := {"id": "squirm_slam", "cooldown": 18.0, "effect": {"damage": 60.0, "radius_units": 3.0, "stun_seconds": 1.5}}
	var s := _sim([], enemies, [{"t": 0.0, "id": "e"}], {"powers": [power]})
	assert_true(not s.cast_power(0), "no enemy on the field yet")
	s.run(0.1)
	assert_true(s.cast_power(0))
	assert_near(s.units[0].hp, 140.0)
	assert_true(s.units[0].stun > 1.0)
	assert_true(not s.cast_power(0), "cooldown")
	s.run(18.1)
	assert_true(s.power_ready(0))


func test_apple_rain_adds_food_over_time() -> void:
	var power := {"id": "apple_rain", "cooldown": 40.0, "effect": {"food": 150.0, "duration_s": 5.0}}
	var s := _sim([], {}, [], {"powers": [power], "food_start": 0.0, "food_income": 0.0})
	s.cast_power(0)
	s.run(2.5)
	assert_near(s.food, 75.0, 3.0)
	s.run(3.0)
	assert_near(s.food, 150.0, 0.5)


func test_time_freeze_rewind_shield_fast_forward() -> void:
	var enemies := {"e": _u("e", "fighter", 200, 5, 1.0, 1.0, 50.0)}
	var freeze := {"id": "time_freeze", "cooldown": 45.0, "effect": {"duration_s": 3.0, "boss_duration_s": 1.5}}
	var s := _sim([], enemies, [{"t": 0.0, "id": "e"}], {"powers": [freeze]})
	s.run(0.1)
	var x0: float = s.units[0].x
	s.cast_power(0)
	s.run(2.0)
	assert_near(s.units[0].x, x0, 6.0, "frozen enemies do not advance")
	var shield := {"id": "dirt_shield", "cooldown": 50.0, "effect": {"absorb_fraction": 0.25, "duration_s": 8.0}}
	var s2 := _sim([], {"e": _u("e", "fighter", 100, 100, 0.5, 1.0, 200.0)}, [{"t": 0.0, "id": "e"}], {"powers": [shield], "player_base_hp": 1000.0})
	s2.cast_power(0)
	assert_near(s2.player_shield, 250.0)
	var ff := {"id": "fast_forward", "cooldown": 40.0, "effect": {"speed_bonus": 0.3, "duration_s": 8.0}}
	var s3 := _sim([_u("p", "fighter", 100, 5)], {}, [], {"powers": [ff]})
	s3.spawn_player(0)
	s3.cast_power(0)
	var x1: float = s3.units[0].x
	s3.run(1.0)
	assert_near(s3.units[0].x - x1, 60.0 * 1.3, 4.0)


func test_rewind_revives_recent_deaths() -> void:
	var rw := {"id": "rewind", "cooldown": 60.0, "effect": {"window_s": 6.0, "hp_fraction": 0.5}}
	var s := _sim([_u("p", "fighter", 100, 1)], {}, [], {"powers": [rw]})
	s.spawn_player(0)
	s.run(0.1)
	s._damage_unit(s.units[0], 1000.0, null, false, false)
	s.run(1.0)
	assert_eq(s.alive_units(BattleSim.PLAYER).size(), 0)
	s.cast_power(0)
	var alive := s.alive_units(BattleSim.PLAYER)
	assert_eq(alive.size(), 1)
	assert_near(alive[0].hp, 50.0)


func test_boss_stomp_stuns_and_roar_speeds_enemies() -> void:
	var boss_stats := _u("b1_rexy", "heavy", 1000, 1, 1.0, 1.0, 0.0, 300.0, {"is_boss": true})
	var defs := {"b1_rexy": {"telegraph": {"id": "stomp", "stun_seconds": 1.0, "reach_units": 3}, "phase2": {"id": "roar", "enemy_speed_mult": 1.2}}}
	var s := _sim([_u("p", "fighter", 500, 1, 1.0, 1.0, 0.0)], {"b1_rexy": boss_stats}, [{"t": 0.0, "id": "b1_rexy"}], {"boss_defs": defs})
	s.spawn_player(0)
	s.run(0.1)
	s.units[0].x = 900.0   # next to the boss (boss spawns at 970)
	var saw_warning := false
	for _i in int(10.5 / s.dt):
		s.tick()
		for ev in s.drain_events():
			if ev["type"] == "telegraph":
				saw_warning = true
		if s.units[0].stun > 0.5:
			break
	assert_true(saw_warning, "telegraph warning comes before the attack")
	assert_true(s.units[0].stun > 0.5, "stomp stunned the ally")
	s._damage_unit(s.units[1], 600.0, null, false, false)
	s.run(0.2)
	assert_near(s._enemy_speed_mult, 1.2)


func test_determinism() -> void:
	var enemies := {"e": _u("e", "fighter", 80, 8, 0.9), "s": _u("s", "shooter", 40, 9, 1.0, 5.0)}
	var spawns := [{"t": 1.0, "id": "e"}, {"t": 3.0, "id": "s"}, {"t": 5.0, "id": "e"}]
	var squad := [_u("p", "fighter", 100, 9, 0.8), _u("q", "shooter", 50, 10, 1.0, 5.0, 55.0, 75.0)]
	var results: Array = []
	for _r in 2:
		var s := _sim(squad, enemies, spawns, {"food_income": 8.0})
		for i in 300:
			if i % 40 == 0:
				s.spawn_player(i % 2)
			s.tick()
		results.append("%d|%.4f|%.4f|%.4f|%d" % [s.tick_count, s.food, s.enemy_base_hp, s.player_base_hp, s.units.size()])
	assert_eq(results[0], results[1])


func test_battle_setup_from_stage_data() -> void:
	var st := DataDB.stage(1, 10)
	assert_true(not st.is_empty(), "stage 1-10 exists")
	var setup := BattleSetup.make(st, {"squad": ["p1_club_worm", "p1_slinger_worm", "p1_dino_rider_worm"], "powers": ["squirm_slam", "apple_rain"]})
	assert_eq(setup["squad"].size(), 3)
	assert_true(setup["enemy_units"].has("b1_rexy"))
	assert_true(setup["enemy_units"]["b1_rexy"]["is_boss"])
	assert_true(setup["spawns"].size() > 3, "boss escorts are scheduled")
	var s := BattleSim.new(setup)
	s.spawn_player(0)
	s.run(30.0)
	assert_true(s.result != "win", "one club worm does not beat Rexy")


func test_revive_base_continues_battle() -> void:
	var s := _sim([], {"e": _u("e", "fighter", 100, 500, 0.5, 1.0, 200.0)}, [{"t": 0.0, "id": "e"}], {"player_base_hp": 100.0})
	s.run(60.0)
	assert_eq(s.result, "lose")
	s.revive_base(0.25)
	assert_eq(s.result, "")
	assert_near(s.player_base_hp, 25.0)
