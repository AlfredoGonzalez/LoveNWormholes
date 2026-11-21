extends TestCase
## Time Capsules core (spec 7.4): pity, duplicates -> Dust, crafting, determinism, persistence. No UI, no Game autoload.

const P := "user://t_caps.json"

func _clean() -> void:
	for p in [P, "user://t_caps.bak.json", P + ".tmp"]:
		if FileAccess.file_exists(p):
			DirAccess.remove_absolute(p)

func _caps(seed := 1, capsules := 0) -> Capsules:
	_clean()
	DataDB.ensure_loaded()
	var e := Economy.new(DataDB.balance(), SaveService.new(P))
	e.add("capsules", capsules)
	var rng := RandomNumberGenerator.new()
	rng.seed = seed
	return Capsules.new(e, rng)

func test_pick_rarity_thresholds_and_pity() -> void:
	var odds := {"common": 0.7, "rare": 0.25, "epic": 0.05}
	assert_eq(Capsules.pick_rarity(0.0, odds, false, false), "common")
	assert_eq(Capsules.pick_rarity(0.69, odds, false, false), "common")
	assert_eq(Capsules.pick_rarity(0.71, odds, false, false), "rare")
	assert_eq(Capsules.pick_rarity(0.96, odds, false, false), "epic")
	assert_eq(Capsules.pick_rarity(0.999999, odds, false, false), "epic")
	assert_eq(Capsules.pick_rarity(0.1, odds, true, false), "rare", "rare pity lifts a common")
	assert_eq(Capsules.pick_rarity(0.96, odds, true, false), "epic", "rare pity never lowers")
	assert_eq(Capsules.pick_rarity(0.1, odds, true, true), "epic", "epic pity wins")

func test_published_odds_match_spec() -> void:
	var c := _caps()
	var o := c.rarity_odds()
	assert_near(o["common"], 0.7)
	assert_near(o["rare"], 0.25)
	assert_near(o["epic"], 0.05)
	assert_eq(c.rare_every(), 5)
	assert_eq(c.epic_every(), 20)

func test_hard_pity_counters_force_rarity() -> void:
	var c := _caps(7, 5)
	c.profile["pity"]["since_rare"] = 4
	var r := c.open_one()
	assert_true(r["rarity"] != "common", "5th capsule is Rare or better")
	assert_eq(c.profile["pity"]["since_rare"], 0)
	c.profile["pity"]["since_epic"] = 19
	var r2 := c.open_one()
	assert_eq(r2["rarity"], "epic", "20th capsule is Epic")
	assert_eq(c.profile["pity"]["since_epic"], 0)
	assert_eq(c.profile["pity"]["since_rare"], 0, "an Epic also resets the rare counter")
	assert_eq(c.pity()["epic_in"], 20)

func test_pity_bounds_over_many_openings() -> void:
	var c := _caps(99, 1000)
	var gap_rare := 0
	var gap_epic := 0
	var max_rare := 0
	var max_epic := 0
	var counts := {"common": 0, "rare": 0, "epic": 0}
	for r in c.open_many(1000):
		counts[r["rarity"]] += 1
		gap_rare = 0 if r["rarity"] != "common" else gap_rare + 1
		gap_epic = 0 if r["rarity"] == "epic" else gap_epic + 1
		max_rare = maxi(max_rare, gap_rare)
		max_epic = maxi(max_epic, gap_epic)
	assert_true(max_rare <= 4, "never more than 4 commons in a row, got %d" % max_rare)
	assert_true(max_epic <= 19, "never more than 19 non-epics in a row, got %d" % max_epic)
	assert_true(counts["common"] > counts["rare"] and counts["rare"] > counts["epic"], str(counts))
	assert_true(counts["epic"] >= 50, "pity gives at least 1 epic per 20: %s" % str(counts))

func test_open_consumes_capsules_and_stops_when_empty() -> void:
	var c := _caps(3, 3)
	assert_eq(c.open_many(10).size(), 3)
	assert_eq(c.economy.get_amount("capsules"), 0)
	assert_eq(c.open_one(), {}, "no capsule, no opening")
	assert_true(not c.can_open(1))

func test_new_then_levelup_then_dust_at_max() -> void:
	var c := _caps()
	var id := "sticky_seed"
	var r1 := c._grant_relic(id, "common")
	assert_eq(r1["kind"], "new")
	assert_eq(r1["level"], 1)
	var r2 := c._grant_relic(id, "common")
	assert_eq(r2["kind"], "level_up")
	assert_eq(r2["level"], 2)
	for _i in 3:
		c._grant_relic(id, "common")
	assert_eq(c.profile["relics"][id], 5, "common max level is 5")
	var dust_before := c.economy.get_amount("chrono_dust")
	var r3 := c._grant_relic(id, "common")
	assert_eq(r3["kind"], "dust")
	assert_eq(r3["dust"], 5)
	assert_eq(c.economy.get_amount("chrono_dust"), dust_before + 5)
	assert_eq(c.profile["relics"][id], 5, "level does not grow past max")
	for _i in 3:
		c._grant_relic("time_crown", "epic")
	assert_eq(c.profile["relics"]["time_crown"], 3, "epic max level is 3")
	assert_eq(c._grant_relic("time_crown", "epic")["dust"], 50)
	for _i in 4:
		c._grant_relic("golden_dewdrop", "rare")
	assert_eq(c._grant_relic("golden_dewdrop", "rare")["dust"], 15)

func test_determinism_with_injected_rng() -> void:
	var a := _caps(42, 30)
	var ra := a.open_many(30)
	var b := _caps(42, 30)
	var rb := b.open_many(30)
	assert_eq(ra, rb, "same seed, same results")
	assert_eq(a.profile["relics"], b.profile["relics"])
	var d := _caps(43, 30)
	assert_true(d.open_many(30) != ra, "another seed differs")

func test_determinism_from_saved_rng_state() -> void:
	var a := _caps(1, 12)
	a.rng = null
	a.profile["pity"]["rng_state"] = 123456789
	var first := a.open_many(6)
	var saved_state: int = a.profile["pity"]["rng_state"]
	assert_true(saved_state > 0 and saved_state != 123456789, "state advances")
	var b := _caps(1, 6)
	b.rng = null
	b.profile["pity"]["rng_state"] = 123456789
	assert_eq(b.open_many(6), first, "same saved state, same first batch")
	assert_eq(b.profile["pity"]["rng_state"], saved_state)

func test_pity_survives_save_and_load() -> void:
	var c := _caps(5, 4)
	c.profile["pity"]["since_epic"] = 7
	c.open_many(3)
	var expected_rare: int = c.profile["pity"]["since_rare"]
	var expected_epic: int = c.profile["pity"]["since_epic"]
	var relics: Dictionary = c.profile["relics"].duplicate()
	var s2 := SaveService.new(P)
	s2.load_profile()
	assert_eq(s2.profile["pity"]["since_rare"], expected_rare)
	assert_eq(s2.profile["pity"]["since_epic"], expected_epic)
	assert_eq(s2.profile["relics"], relics)
	assert_eq(s2.profile["currencies"]["capsules"], 1)

func test_craft_with_dust() -> void:
	var c := _caps()
	assert_eq(c.craft_block_reason("lucky_clover"), "dust")
	assert_eq(c.craft_block_reason("nope"), "unknown")
	c.economy.add("chrono_dust", 70)
	var r := c.craft("lucky_clover")
	assert_true(r["ok"])
	assert_eq(r["cost"], 30)
	assert_eq(c.economy.get_amount("chrono_dust"), 40)
	assert_eq(c.profile["relics"]["lucky_clover"], 1)
	assert_true(not c.craft("golden_dewdrop")["ok"], "rare costs 90")
	assert_eq(c.economy.get_amount("chrono_dust"), 40, "failed craft costs nothing")
	c.profile["relics"]["lucky_clover"] = 5
	assert_eq(c.craft_block_reason("lucky_clover"), "max_level")
	assert_eq(c.dust_cost("epic"), 250)

func test_buy_with_gems() -> void:
	var c := _caps()
	assert_true(not c.buy_with_gems(false))
	c.economy.add("gems", 600)
	assert_true(c.buy_with_gems(false))
	assert_eq(c.economy.get_amount("capsules"), 1)
	assert_eq(c.economy.get_amount("gems"), 540)
	assert_true(c.buy_with_gems(true))
	assert_eq(c.economy.get_amount("capsules"), 11)
	assert_eq(c.economy.get_amount("gems"), 0)

func test_auto_equip_until_slots_full() -> void:
	var c := _caps()
	for id in ["sticky_seed", "lucky_clover", "tough_pebble", "sharp_thorn", "quick_sprout"]:
		c._grant_relic(id, "common")
	assert_eq(Relics.equipped(c.profile).size(), Relics.slots())
	assert_true(not Relics.is_equipped(c.profile, "quick_sprout"))
