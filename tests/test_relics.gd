extends TestCase
## Relic effects (spec 7.4): modifiers, cap, equip limit, BattleSetup and Economy integration, save migration.

const P := "user://t_relics.json"

func _clean() -> void:
	for p in [P, "user://t_relics.bak.json", P + ".tmp"]:
		if FileAccess.file_exists(p):
			DirAccess.remove_absolute(p)

func _svc() -> SaveService:
	_clean()
	DataDB.ensure_loaded()
	return SaveService.new(P)

func test_no_relics_no_modifiers() -> void:
	var s := _svc()
	var m := Relics.modifiers(s.profile)
	assert_true(Relics.is_neutral(m))
	for stat in Relics.STATS:
		assert_true(m.has(stat))

func test_modifier_values_and_equipped_only() -> void:
	var s := _svc()
	s.profile["relics"] = {"sticky_seed": 2, "echo_seashell": 1, "mini_hourglass": 3}
	assert_true(Relics.is_neutral(Relics.modifiers(s.profile)), "owned but not equipped does nothing")
	for id in ["sticky_seed", "echo_seashell", "mini_hourglass"]:
		assert_true(Relics.equip(s.profile, id))
	var m := Relics.modifiers(s.profile)
	assert_near(m["food_income"], 0.05 * 2 + 0.08)
	assert_near(m["power_cooldown"], 0.06 * 3)
	assert_near(m["coins"], 0.0)

func test_cap_at_25_percent() -> void:
	var s := _svc()
	s.profile["relics"] = {"sticky_seed": 5, "echo_seashell": 4, "chrono_gear": 3}
	for id in s.profile["relics"]:
		Relics.equip(s.profile, id)
	assert_near(Relics.modifiers(s.profile)["food_income"], 0.25)

func test_equip_limit_and_validation() -> void:
	var s := _svc()
	var ids := ["sticky_seed", "lucky_clover", "tough_pebble", "sharp_thorn", "quick_sprout"]
	for id in ids:
		s.profile["relics"][id] = 1
	assert_true(not Relics.equip(s.profile, "time_crown"), "not owned")
	for i in Relics.slots():
		assert_true(Relics.equip(s.profile, ids[i]))
	assert_true(not Relics.equip(s.profile, ids[Relics.slots()]), "slots are full")
	assert_true(not Relics.equip(s.profile, ids[0]), "already equipped")
	assert_true(Relics.unequip(s.profile, ids[0]))
	assert_true(Relics.equip(s.profile, ids[Relics.slots()]))
	# A tampered list cannot exceed the limit or equip unowned relics.
	s.profile["loadout"]["equipped_relics"] = ids + ["time_crown", "sticky_seed"]
	assert_eq(Relics.equipped(s.profile).size(), Relics.slots())

func _stage_opts(relics: Dictionary) -> Dictionary:
	return {"squad": ["p1_club_worm"], "powers": ["squirm_slam"], "relics": relics}

func test_battle_setup_applies_relics() -> void:
	DataDB.ensure_loaded()
	var st := DataDB.stage(1, 1)
	var base := BattleSetup.make(st, _stage_opts({}))
	var none := BattleSetup.make(st, {"squad": ["p1_club_worm"], "powers": ["squirm_slam"]})
	assert_eq(base["squad"], none["squad"], "empty relics == no relics")
	assert_eq(base["food_income"], none["food_income"])
	var mods := {"food_income": 0.10, "coins": 0.05, "base_hp": 0.05, "unit_damage": 0.03, "unit_hp": 0.03,
		"spawn_cooldown": 0.05, "power_cooldown": 0.06}
	var r := BattleSetup.make(st, _stage_opts(mods))
	assert_near(r["food_income"], base["food_income"] * 1.10)
	assert_near(r["player_base_hp"], base["player_base_hp"] * 1.05)
	assert_near(r["squad"][0]["hp"], base["squad"][0]["hp"] * 1.03)
	assert_near(r["squad"][0]["damage"], base["squad"][0]["damage"] * 1.03)
	assert_near(r["squad"][0]["spawn_cooldown"], base["squad"][0]["spawn_cooldown"] * 0.95)
	assert_near(r["powers"][0]["cooldown"], base["powers"][0]["cooldown"] * 0.94)
	assert_eq(r["enemy_base_hp"], base["enemy_base_hp"], "enemies are untouched")

func test_settle_battle_coin_bonus() -> void:
	var s := _svc()
	var e := Economy.new(DataDB.balance(), s)
	var plain := e.win_reward(1)
	var r0 := e.settle_battle(1, 1, true, 3)
	assert_eq(r0["coins"], plain * 2, "first clear x2, no relic")
	s.profile["relics"]["golden_dewdrop"] = 2
	Relics.equip(s.profile, "golden_dewdrop")   # +16%
	var r1 := e.settle_battle(1, 1, true, 3)
	assert_eq(r1["coins"], int(round(plain * 1.16)))
	var r2 := e.settle_battle(1, 1, true, 3, 2)
	assert_eq(r2["coins"], int(round(plain * 1.16)) * 2, "the ad multiplier applies after the relic")

func test_save_without_equipped_relics_migrates() -> void:
	var s := _svc()
	# A v2 profile written before relics could be equipped: no loadout.equipped_relics key.
	s.profile["loadout"].erase("equipped_relics")
	s.profile["relics"] = {"sticky_seed": 3}
	s.save()
	var s2 := SaveService.new(P)
	s2.load_profile()
	assert_eq(s2.profile["loadout"]["equipped_relics"], [], "default filled in")
	assert_eq(s2.profile["relics"], {"sticky_seed": 3}, "relics kept")
	assert_true(Relics.is_neutral(Relics.modifiers(s2.profile)))
	assert_true(Relics.equip(s2.profile, "sticky_seed"))
	s2.save()
	var s3 := SaveService.new(P)
	s3.load_profile()
	assert_eq(Relics.equipped(s3.profile), ["sticky_seed"])
	assert_eq(s3.profile["schema_version"], SaveService.CURRENT_VERSION)
