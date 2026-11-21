extends TestCase
## Schema validation of every JSON data/config file.

const SPRITE_RE := "^[pbe]\\d_[a-z0-9_]+$"

func _snake(s: String) -> bool:
	var re := RegEx.new()
	re.compile("^[a-z][a-z0-9_]*$")
	return re.search(s) != null

func test_no_load_or_validation_errors() -> void:
	var errs := DataDB.validate()
	assert_eq(errs.size(), 0, "validate(): %s" % str(errs))

func test_counts() -> void:
	assert_eq(DataDB.unit_ids().size(), 15)
	assert_eq(DataDB.enemy_ids().size(), 15)
	assert_eq(DataDB.boss_ids().size(), 5)
	assert_eq(DataDB.power_ids().size(), 6)
	assert_eq(DataDB.relic_ids().size(), 12)
	assert_eq(DataDB.quests().size(), 3)
	assert_eq(DataDB.shop()["products"].size(), 9)

func test_ids_unique_and_snake() -> void:
	var seen := {}
	for list in [DataDB.unit_ids(), DataDB.enemy_ids(), DataDB.boss_ids(), DataDB.power_ids(), DataDB.relic_ids()]:
		for id in list:
			assert_true(_snake(id), "not snake_case: " + id)
			assert_true(not seen.has(id), "duplicate id " + id)
			seen[id] = true

func test_sprite_ids_follow_spec_naming() -> void:
	var re := RegEx.new()
	re.compile(SPRITE_RE)
	for kind in ["unit", "enemy", "boss"]:
		var ids: Array = DataDB.ids_of(kind)
		var prefix: String = {"unit": "p", "enemy": "e", "boss": "b"}[kind]
		for id in ids:
			var e: Dictionary = DataDB.entry(kind, id)
			assert_eq(e["sprite"], id, "sprite must equal id")
			assert_true(re.search(e["sprite"]) != null, "bad sprite id " + id)
			assert_true(id.begins_with("%s%d_" % [prefix, e["era"]]), "id/era mismatch " + id)
	assert_true(DataDB.unit("p1_club_worm").size() > 0)
	assert_true(DataDB.boss("b5_count_magpie_3000").size() > 0)
	assert_true(DataDB.enemy("e4_clank_crab").size() > 0)

func test_units_fields_roles_and_distribution() -> void:
	for kind in ["unit", "enemy", "boss"]:
		for id in DataDB.ids_of(kind):
			var e: Dictionary = DataDB.entry(kind, id)
			for f in ["id", "era", "role", "cost", "hp", "damage", "interval", "range", "speed", "spawn_cooldown", "sprite", "flags", "name_key", "desc_key"]:
				assert_true(e.has(f), "%s missing %s" % [id, f])
			assert_true(DataDB.ROLES.has(e["role"]), "bad role " + id)
			assert_true(e["era"] >= 1 and e["era"] <= 5)
			assert_true(e["hp"] > 0.0 and e["interval"] > 0.0 and e["speed"] > 0.0 and e["cost"] > 0.0)
			assert_eq((e["flags"] as Dictionary).size(), 5, "flags must hold the 5 spec keys")
			for fl in e["flags"]:
				assert_true(DataDB.FLAG_NAMES.has(fl))
	for era in range(1, 6):
		assert_eq(DataDB.units_of_era(era).size(), 3, "3 units in era %d" % era)
		assert_eq(DataDB.enemies_of_era(era).size(), 3, "3 enemies in era %d" % era)
		assert_true(not DataDB.boss_of_era(era).is_empty())

func test_unit_signatures_match_spec_5_1() -> void:
	assert_eq(DataDB.unit("p1_club_worm")["role"], "fighter")
	assert_eq(DataDB.unit("p1_slinger_worm")["range"], 5.0)
	assert_eq(DataDB.unit("p2_shield_bearer_worm")["role"], "heavy")
	assert_near(DataDB.unit("p2_shield_bearer_worm")["abilities"]["block_ranged_fraction"], 0.20)
	assert_true(DataDB.unit("p2_cobra_charmer_worm")["flags"]["slow"])
	assert_near(DataDB.unit("p2_cobra_charmer_worm")["abilities"]["slow_fraction"], 0.20)
	assert_near(DataDB.unit("p3_knight_worm")["abilities"]["first_hit_bonus"], 0.50)
	assert_true(DataDB.unit("p3_wizard_worm")["flags"]["buff"])
	assert_near(DataDB.unit("p3_wizard_worm")["abilities"]["damage_aura"], 0.15)
	assert_true(DataDB.unit("p4_boiler_tank_worm")["flags"]["splash"])
	assert_true(DataDB.unit("p4_balloon_bomber_worm")["flags"]["air"])
	assert_eq(DataDB.unit("p4_balloon_bomber_worm")["role"], "air")
	assert_true(DataDB.unit("p5_time_medic_worm")["flags"]["heal"])
	assert_near(DataDB.unit("p5_time_medic_worm")["abilities"]["heal_fraction_per_sec"], 0.05)
	for id in ["e3_hornet_scout", "e4_spark_fly", "e5_drone_fly"]:
		assert_true(DataDB.enemy(id)["flags"]["air"], id)
		assert_eq(DataDB.enemy(id)["role"], "air")

func test_unmodified_units_match_role_table() -> void:
	# Units without overrides must equal the spec 5.4 role base stats (no double definition).
	for id in DataDB.unit_ids():
		var raw := DataDB.unit(id)
		var base := DataDB.role_base(raw["role"])
		for stat in DataDB.STAT_FIELDS:
			if not (raw["overrides"] as Dictionary).has(stat):
				assert_near(raw[stat], float(base[stat]), 0.0001, "%s.%s" % [id, stat])
		if not (raw["overrides"] as Dictionary).is_empty():
			assert_true(raw.get("proposed", false) or id == "", "overridden numbers must be marked proposed: " + id)

func test_bosses() -> void:
	for id in DataDB.boss_ids():
		var b := DataDB.boss(id)
		assert_true(b["proposed"], "boss stats are proposed: " + id)
		assert_eq(b["role"], "heavy")
		assert_true(b["telegraph"].has("id") and b["phase2"].has("id"))
		assert_true(b["escorts"].size() > 0)
		for e in b["escorts"]:
			assert_true(not DataDB.enemy(e["enemy"]).is_empty())
	var rexy := DataDB.boss("b1_rexy")
	assert_near(rexy["telegraph"]["stun_seconds"], 1.0)
	assert_near(rexy["phase2"]["enemy_speed_mult"], 1.2)
	assert_near(DataDB.bal_f("boss.telegraph_interval_s"), 10.0)
	assert_near(DataDB.bal_f("boss.phase2_hp_fraction"), 0.5)
	assert_near(DataDB.bal_f("boss.hp_mult"), 6.0)
	assert_near(DataDB.boss("b4_clockwork_queen")["phase2"]["interval_s"], 8.0)
	assert_near(DataDB.boss("b5_count_magpie_3000")["telegraph"]["duration_s"], 8.0)

func test_powers() -> void:
	var expected := {"squirm_slam": 18, "apple_rain": 40, "time_freeze": 45, "rewind": 60, "dirt_shield": 50, "fast_forward": 40}
	for id in expected:
		var p := DataDB.power(id)
		assert_true(not p.is_empty(), id)
		assert_near(p["cooldown"], float(expected[id]))
		assert_true(p["effect"].size() > 0)
	assert_eq(DataDB.power("squirm_slam")["unlock"]["type"], "start")
	assert_eq(DataDB.power("apple_rain")["unlock"]["type"], "start")
	assert_eq(int(DataDB.power("time_freeze")["unlock"]["era"]), 1)
	assert_eq(int(DataDB.power("fast_forward")["unlock"]["era"]), 4)
	assert_near(DataDB.power("squirm_slam")["effect"]["damage"], 60.0)
	assert_near(DataDB.power("squirm_slam")["effect"]["stun_seconds"], 1.5)
	assert_near(DataDB.power("time_freeze")["effect"]["boss_duration_s"], 1.5)
	assert_near(DataDB.power("dirt_shield")["effect"]["absorb_fraction"], 0.25)
	assert_near(DataDB.power("fast_forward")["effect"]["speed_bonus"], 0.30)

func test_relics() -> void:
	var counts := {"common": 0, "rare": 0, "epic": 0}
	for id in DataDB.relic_ids():
		var r := DataDB.relic(id)
		counts[r["rarity"]] += 1
		assert_true(r["bonus"] > 0.0)
	assert_eq(counts["common"], 6)
	assert_eq(counts["rare"], 4)
	assert_eq(counts["epic"], 2)
	var rar := DataDB.rarities()
	assert_near(rar["common"]["odds"], 0.70)
	assert_near(rar["rare"]["odds"], 0.25)
	assert_near(rar["epic"]["odds"], 0.05)
	assert_eq(int(rar["common"]["max_level"]), 5)
	assert_eq(int(rar["rare"]["max_level"]), 4)
	assert_eq(int(rar["epic"]["max_level"]), 3)
	assert_eq(int(rar["epic"]["dust_on_duplicate"]), 50)
	assert_eq(int(rar["rare"]["dust_cost"]), 90)
	assert_near(DataDB.relic("time_crown")["bonus"], 0.08)
	assert_eq(DataDB.relic("quick_sprout")["stat"], "spawn_cooldown")

func test_shop() -> void:
	var prices := {"gems_80": 0.99, "gems_450": 4.99, "gems_1000": 9.99, "gems_2200": 19.99, "starter_pack": 1.99,
		"golden_pass": 4.99, "skin_pirate": 1.99, "skin_knight": 1.99, "skin_astronaut": 1.99}
	var found := {}
	for p in DataDB.shop()["products"]:
		found[p["id"]] = p
	for id in prices:
		assert_true(found.has(id), id)
		assert_near(found[id]["price_usd"], prices[id])
	assert_eq(int(found["gems_450"]["contents"]["gems"]), 450)
	assert_eq(int(found["starter_pack"]["contents"]["capsules"]), 3)
	assert_eq(int(DataDB.shop()["capsules"]["gem_price_single"]), 60)
	assert_eq(int(DataDB.shop()["capsules"]["gem_price_bundle"]), 540)

func test_quests() -> void:
	for q in DataDB.quests():
		assert_true(_snake(q["id"]))
		assert_true(q["target"] > 0 and q["reward"]["coins"] > 0 and q["reward"]["gems"] > 0)
	assert_eq(int(DataDB.quests()[0]["target"]), 3)

func test_ads_and_flags() -> void:
	var cfg := DataDB.ads_config()
	var ids := []
	for p in cfg["placements"]:
		ids.append(p["id"])
		assert_true(p["enabled"] is bool)
	ids.sort()
	assert_eq(ids, ["bonus_capsule", "double_coins", "double_farm", "food_boost", "second_wind"])
	assert_true(cfg["rewarded_only"])
	assert_true(DataDB.ad_placement_enabled("double_coins"))
	assert_true(not DataDB.ad_placement_enabled("unknown"))
	assert_true(DataDB.feature_enabled("ads"))
	assert_true(not DataDB.feature_enabled("debug_menu"))
	assert_true(not DataDB.feature_enabled("does_not_exist"))

func test_balance_required_sections() -> void:
	for s in ["sim", "battle", "squad", "campaign", "scaling", "upgrades", "rewards", "underdog", "offline", "daily", "capsule", "ads", "era_rules", "boss", "roles", "proposed_keys"]:
		assert_true(DataDB.balance().has(s), s)
	for r in DataDB.ROLES:
		for f in DataDB.STAT_FIELDS:
			assert_true(DataDB.role_base(r).has(f), "%s.%s" % [r, f])
	assert_eq(DataDB.bal_i("campaign.eras") * DataDB.bal_i("campaign.stages_per_era"), 50)
