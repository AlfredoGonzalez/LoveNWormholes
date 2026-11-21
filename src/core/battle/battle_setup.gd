class_name BattleSetup
extends RefCounted
## Builds the dictionary BattleSim needs from DataDB, a stage definition and the player's profile.
## Pure functions: the same inputs always give the same setup.
##
## Stage definition (data/stages.json entry, see docs/DATA_SCHEMA.md):
##   {id, era, index, enemy_base_hp, food_budget, waves: [...], rule, rewards}
## A wave is {t, enemy, count, interval} (count enemies, one every `interval` s from `t`)
## or {t, boss: "<boss id>"} (the boss plus its escorts from bosses.json).
##
## opts (all optional):
##   squad: Array of unit ids (card order)     unit_levels: {id: level}
##   burrow_level, base_level: int              powers: Array of power ids (slot order)
##   power_levels: {id: level}                  underdog_stacks: int
##   food_boost: bool (rewarded ad, +30% starting Food)
##   relics: Relics.modifiers(profile) (fractions per stat; omitted = no relic effects)

static func make(stage_def: Dictionary, opts: Dictionary) -> Dictionary:
	var era := int(stage_def["era"])
	var stage := int(stage_def["index"])
	var n := DataDB.stage_number(era, stage)
	var levels: Dictionary = opts.get("unit_levels", {})
	var stacks := int(opts.get("underdog_stacks", 0))
	var burrow := int(opts.get("burrow_level", 1))
	var base_level := int(opts.get("base_level", 1))

	var rm: Dictionary = opts.get("relics", {})
	var squad: Array = []
	for id in opts.get("squad", []):
		squad.append(_with_relics(DataDB.unit_stats(str(id), int(levels.get(id, 1)), era), rm))

	var enemy_units := {}
	var boss_defs := {}
	var spawns: Array = []
	for w in stage_def.get("waves", []):
		if w.has("boss"):
			var bid := str(w["boss"])
			var bd: Dictionary = DataDB.boss(bid)
			if bd.is_empty():
				continue
			var bs := DataDB.boss_stats(bid, stage)
			bs["is_boss"] = true
			enemy_units[bid] = bs
			boss_defs[bid] = {"telegraph": bd.get("telegraph", {}), "phase2": bd.get("phase2", {})}
			var t := float(w["t"])
			var k := 0
			for esc in bd.get("escorts", []):
				var eid := str(esc["enemy"])
				_add_enemy(enemy_units, eid, era, stage)
				for _i in int(esc["count"]):
					spawns.append({"t": t + 0.6 * k, "id": eid})
					k += 1
			spawns.append({"t": t + 0.6 * k + 0.5, "id": bid})
			# Escorts the boss summons later must be resolvable too.
			var tg: Dictionary = bd.get("telegraph", {})
			if tg.has("enemy"):
				_add_enemy(enemy_units, str(tg["enemy"]), era, stage)
			var p2: Dictionary = bd.get("phase2", {})
			if p2.has("enemy"):
				_add_enemy(enemy_units, str(p2["enemy"]), era, stage)
		else:
			var eid2 := str(w["enemy"])
			_add_enemy(enemy_units, eid2, era, stage)
			for i in int(w.get("count", 1)):
				spawns.append({"t": float(w["t"]) + float(w.get("interval", 1.0)) * i, "id": eid2})
	spawns.sort_custom(func(a, b): return float(a["t"]) < float(b["t"]))

	var powers: Array = []
	var plv: Dictionary = opts.get("power_levels", {})
	for pid in opts.get("powers", []):
		var pp := DataDB.power_params(str(pid), int(plv.get(pid, 1)))
		if not pp.is_empty():
			pp["cooldown"] = float(pp["cooldown"]) * (1.0 - float(rm.get("power_cooldown", 0.0)))
		powers.append(pp)

	var food_mult := 1.0 + DataDB.bal_f("underdog.food_per_stack") * minf(float(stacks), DataDB.bal_f("underdog.max_stacks"))
	if bool(opts.get("food_boost", false)):
		food_mult += DataDB.bal_f("ads.food_boost_fraction")
	return {
		"era": era, "stage": stage, "stage_number": n,
		"player_base_hp": DataDB.player_base_hp(era, base_level) * DataDB.underdog_base_hp_mult(stacks) * (1.0 + float(rm.get("base_hp", 0.0))),
		"enemy_base_hp": float(stage_def.get("enemy_base_hp", DataDB.enemy_base_hp(n))),
		"food_start": DataDB.bal_f("battle.food_start") * food_mult,
		"food_income": (DataDB.bal_f("battle.food_income_base") + DataDB.bal_f("upgrades.burrow.income_per_level") * (burrow - 1)) * (1.0 + float(rm.get("food_income", 0.0))),
		"food_cap": DataDB.bal_f("battle.food_cap_base") + DataDB.bal_f("upgrades.burrow.cap_per_level") * (burrow - 1),
		"squad": squad,
		"enemy_units": enemy_units,
		"boss_defs": boss_defs,
		"spawns": spawns,
		"powers": powers,
		"rule": (stage_def.get("rule", {"type": "none"}) as Dictionary).duplicate(true),
	}


## Relic effects on a player unit (spec 7.4): +unit_hp, +unit_damage, -spawn_cooldown.
static func _with_relics(st: Dictionary, rm: Dictionary) -> Dictionary:
	if st.is_empty() or rm.is_empty():
		return st
	st["hp"] = float(st["hp"]) * (1.0 + float(rm.get("unit_hp", 0.0)))
	st["damage"] = float(st["damage"]) * (1.0 + float(rm.get("unit_damage", 0.0)))
	st["spawn_cooldown"] = float(st["spawn_cooldown"]) * (1.0 - float(rm.get("spawn_cooldown", 0.0)))
	return st


static func _add_enemy(dest: Dictionary, id: String, era: int, stage: int) -> void:
	if not dest.has(id):
		dest[id] = DataDB.enemy_stats(id, era, stage)
