class_name DataDB
extends RefCounted
## Static, cached access to every JSON data file plus the pure formulas of spec sections 4 to 7.
## No autoload. All tunable numbers come from res://data/balance.json; nothing is hardcoded here.
## Missing ids return {} (never crash); problems found while loading are listed in validate().
##
## Units/enemies/bosses are stored as role base stats + overrides; unit(id)/enemy(id)/boss(id) return the
## BASE (era-1 equivalent, unscaled) stats already merged. Use unit_stats / enemy_stats / boss_stats for
## scaled values so nothing is scaled twice.

const DATA_DIR := "res://data/"
const CONFIG_DIR := "res://config/"
const ROLES: Array = ["fighter", "shooter", "heavy", "support", "air"]
const FLAG_NAMES: Array = ["air", "splash", "slow", "heal", "buff"]
const STAT_FIELDS: Array = ["cost", "hp", "damage", "interval", "range", "speed", "spawn_cooldown"]
const RARITIES: Array = ["common", "rare", "epic"]
const AD_PLACEMENTS: Array = ["double_coins", "food_boost", "second_wind", "bonus_capsule", "double_farm"]

static var _loaded := false
static var _errors: Array = []
static var _balance: Dictionary = {}
static var _units: Dictionary = {}
static var _enemies: Dictionary = {}
static var _bosses: Dictionary = {}
static var _powers: Dictionary = {}
static var _relics: Dictionary = {}
static var _unit_ids: Array = []
static var _enemy_ids: Array = []
static var _boss_ids: Array = []
static var _power_ids: Array = []
static var _relic_ids: Array = []
static var _rarities: Dictionary = {}
static var _shop: Dictionary = {}
static var _quests: Dictionary = {}
static var _ads: Dictionary = {}
static var _flags: Dictionary = {}


# ------------------------------------------------------------------ loading

static func ensure_loaded() -> void:
	if not _loaded:
		reload()


## Drops the cache and reads every file again.
static func reload() -> void:
	_errors = []
	_balance = _read_json(DATA_DIR + "balance.json")
	_units = {}; _unit_ids = []
	_enemies = {}; _enemy_ids = []
	_bosses = {}; _boss_ids = []
	_powers = {}; _power_ids = []
	_relics = {}; _relic_ids = []
	_load_entries("units.json", "units", "unit", _units, _unit_ids)
	_load_entries("enemies.json", "enemies", "enemy", _enemies, _enemy_ids)
	_load_entries("bosses.json", "bosses", "boss", _bosses, _boss_ids)
	var pw := _read_json(DATA_DIR + "powers.json")
	for p in pw.get("powers", []):
		_powers[str(p.get("id", ""))] = _norm_numbers(p)
		_power_ids.append(str(p.get("id", "")))
	var rl := _read_json(DATA_DIR + "relics.json")
	_rarities = rl.get("rarities", {})
	for r in rl.get("relics", []):
		_relics[str(r.get("id", ""))] = r
		_relic_ids.append(str(r.get("id", "")))
	_shop = _read_json(DATA_DIR + "shop.json")
	_quests = _read_json(DATA_DIR + "quests.json")
	_ads = _read_json(CONFIG_DIR + "ads.json")
	_flags = _read_json(CONFIG_DIR + "feature_flags.json")
	_loaded = true
	_errors.append_array(_validate_data())


static func _read_json(path: String) -> Dictionary:
	var f := FileAccess.open(path, FileAccess.READ)
	if f == null:
		_errors.append("%s: cannot open file" % path)
		return {}
	var parsed = JSON.parse_string(f.get_as_text())
	if parsed == null or not (parsed is Dictionary):
		_errors.append("%s: invalid JSON (expected an object)" % path)
		return {}
	return parsed


static func _load_entries(file: String, list_key: String, kind: String, dest: Dictionary, ids: Array) -> void:
	var doc := _read_json(DATA_DIR + file)
	for raw in doc.get(list_key, []):
		if not (raw is Dictionary):
			_errors.append("%s: entry is not an object" % file)
			continue
		var e := _resolve_entry(raw, kind)
		var id := str(e.get("id", ""))
		if dest.has(id):
			_errors.append("%s: duplicate id '%s'" % [file, id])
			continue
		dest[id] = e
		ids.append(id)


## Role base stats + overrides -> a full base entry. Era becomes an int, flags get all five keys.
static func _resolve_entry(raw: Dictionary, kind: String) -> Dictionary:
	var e: Dictionary = raw.duplicate(true)
	var role := str(raw.get("role", ""))
	var base: Dictionary = (_balance.get("roles", {}) as Dictionary).get(role, {})
	var ov: Dictionary = raw.get("overrides", {})
	for f in STAT_FIELDS:
		e[f] = ov[f] if ov.has(f) else base.get(f, 0)
		e[f] = float(e[f])
	e["era"] = int(raw.get("era", 0))
	var flags := {}
	for fl in FLAG_NAMES:
		flags[fl] = false
	for k in (raw.get("flags", {}) as Dictionary):
		flags[k] = bool(raw["flags"][k])
	if bool(base.get("is_air", false)):
		flags["air"] = true
	e["flags"] = flags
	e["kind"] = kind
	e["can_hit_air"] = bool(base.get("can_hit_air", false))
	if not raw.has("abilities"):
		e["abilities"] = {}
	return e


static func _norm_numbers(d: Dictionary) -> Dictionary:
	return d.duplicate(true)


# ------------------------------------------------------------------ plain accessors

static func errors() -> Array:
	ensure_loaded()
	return _errors.duplicate()


static func balance() -> Dictionary:
	ensure_loaded()
	return _balance


## Dotted lookup in balance.json, e.g. bal("upgrades.unit.cost_growth"). Returns default when missing.
static func bal(path: String, default = 0.0):
	ensure_loaded()
	var v = _path_get(_balance, path)
	return default if v == null else v


static func bal_i(path: String, default := 0) -> int:
	return int(bal(path, default))


static func bal_f(path: String, default := 0.0) -> float:
	return float(bal(path, default))


static func unit(id: String) -> Dictionary:
	ensure_loaded()
	return _units.get(id, {})


static func enemy(id: String) -> Dictionary:
	ensure_loaded()
	return _enemies.get(id, {})


static func boss(id: String) -> Dictionary:
	ensure_loaded()
	return _bosses.get(id, {})


static func power(id: String) -> Dictionary:
	ensure_loaded()
	return _powers.get(id, {})


static func relic(id: String) -> Dictionary:
	ensure_loaded()
	return _relics.get(id, {})


static func unit_ids() -> Array:
	ensure_loaded()
	return _unit_ids.duplicate()


static func enemy_ids() -> Array:
	ensure_loaded()
	return _enemy_ids.duplicate()


static func boss_ids() -> Array:
	ensure_loaded()
	return _boss_ids.duplicate()


static func power_ids() -> Array:
	ensure_loaded()
	return _power_ids.duplicate()


static func relic_ids() -> Array:
	ensure_loaded()
	return _relic_ids.duplicate()


## kind is "unit", "enemy" or "boss".
static func ids_of(kind: String) -> Array:
	match kind:
		"unit": return unit_ids()
		"enemy": return enemy_ids()
		"boss": return boss_ids()
	return []


static func entry(kind: String, id: String) -> Dictionary:
	match kind:
		"unit": return unit(id)
		"enemy": return enemy(id)
		"boss": return boss(id)
	return {}


static func units_of_era(era: int) -> Array:
	ensure_loaded()
	var out: Array = []
	for id in _unit_ids:
		if _units[id]["era"] == era:
			out.append(_units[id])
	return out


static func enemies_of_era(era: int) -> Array:
	ensure_loaded()
	var out: Array = []
	for id in _enemy_ids:
		if _enemies[id]["era"] == era:
			out.append(_enemies[id])
	return out


static func boss_of_era(era: int) -> Dictionary:
	ensure_loaded()
	for id in _boss_ids:
		if _bosses[id]["era"] == era:
			return _bosses[id]
	return {}


static func role_base(role: String) -> Dictionary:
	ensure_loaded()
	return (_balance.get("roles", {}) as Dictionary).get(role, {})


static func rarities() -> Dictionary:
	ensure_loaded()
	return _rarities


static func shop() -> Dictionary:
	ensure_loaded()
	return _shop


static func quests() -> Array:
	ensure_loaded()
	return _quests.get("quests", [])


static func ads_config() -> Dictionary:
	ensure_loaded()
	return _ads


static func feature_enabled(flag: String) -> bool:
	ensure_loaded()
	return bool((_flags.get("flags", {}) as Dictionary).get(flag, false))


## True when the global ads flag and the placement's own switch are both on.
static func ad_placement_enabled(placement: String) -> bool:
	ensure_loaded()
	if not feature_enabled("ads"):
		return false
	for p in _ads.get("placements", []):
		if p.get("id", "") == placement:
			return bool(p.get("enabled", false))
	return false


# ------------------------------------------------------------------ lane scale

static func range_to_px(range_units: float) -> float:
	return range_units * bal_f("sim.range_unit_px")


static func tick_dt() -> float:
	return 1.0 / bal_f("sim.ticks_per_second")


# ------------------------------------------------------------------ roles and counters

## Damage multiplier of an attacker role against a defender role (spec 4.4): 1.5 / 0.75 / 1.0.
static func counter_multiplier(attacker_role: String, defender_role: String) -> float:
	var att := role_base(attacker_role)
	var def := role_base(defender_role)
	var strong: Array = att.get("strong_against", [])
	var def_weak: Array = def.get("weak_against", [])
	if defender_role in strong or attacker_role in def_weak or "any" in def_weak:
		return bal_f("battle.counter_strong_mult")
	var weak: Array = att.get("weak_against", [])
	var def_strong: Array = def.get("strong_against", [])
	if (defender_role in weak and not ("any" in weak)) or attacker_role in def_strong:
		return bal_f("battle.counter_weak_mult")
	return 1.0


## Can an attacker of this role hit the target? Air targets can only be hit by roles with can_hit_air.
static func can_hit(attacker_role: String, target_is_air: bool) -> bool:
	if not target_is_air:
		return true
	return bool(role_base(attacker_role).get("can_hit_air", false))


# ------------------------------------------------------------------ scaling formulas (spec 6.3)

## 1.6^(era-1)
static func era_stat_mult(era: int) -> float:
	return pow(bal_f("scaling.era_hp_damage_mult"), era - 1)


## 1.5^(era-1)
static func era_cost_mult(era: int) -> float:
	return pow(bal_f("scaling.era_cost_mult"), era - 1)


## 1 + 0.40 x (current era - unit era), never below 1 (older units only grow).
static func time_sync_mult(unit_era: int, current_era: int) -> float:
	return 1.0 + bal_f("scaling.time_sync_per_era") * maxi(0, current_era - unit_era)


## 1 + 0.10 x (level - 1)
static func level_mult(level: int) -> float:
	return 1.0 + bal_f("scaling.unit_level_step") * (clampi(level, 1, bal_i("scaling.unit_level_max")) - 1)


static func unit_multiplier(unit_era: int, current_era: int, level: int) -> float:
	return era_stat_mult(unit_era) * time_sync_mult(unit_era, current_era) * level_mult(level)


## Scaled stats of a player unit. HP and damage use the full multiplier; cost scales by era only;
## interval, range, speed and spawn cooldown are not scaled. Returns {} for unknown ids.
static func unit_stats(id: String, level: int, current_era: int) -> Dictionary:
	var u := unit(id)
	if u.is_empty():
		return {}
	var m := unit_multiplier(int(u["era"]), current_era, level)
	return _scaled_stats(u, m, era_cost_mult(int(u["era"])), {"level": level, "current_era": current_era})


## 1.6^(e-1) x (1 + 0.05 x (s-1)). `era` and `stage` are those of the stage being played.
static func enemy_stat_mult(era: int, stage: int) -> float:
	return era_stat_mult(era) * (1.0 + bal_f("scaling.enemy_stage_step") * (stage - 1))


static func enemy_stats(id: String, era: int, stage: int) -> Dictionary:
	var e := enemy(id)
	if e.is_empty():
		return {}
	return _scaled_stats(e, enemy_stat_mult(era, stage), era_cost_mult(era), {"era": era, "stage": stage})


## Boss stats: Heavy base x boss.hp_mult for HP, enemy stage multiplier on HP and damage (stage defaults to the boss stage).
static func boss_stats(id: String, stage := -1) -> Dictionary:
	var b := boss(id)
	if b.is_empty():
		return {}
	var s := stage if stage > 0 else bal_i("campaign.boss_stage")
	var era := int(b["era"])
	var out := _scaled_stats(b, enemy_stat_mult(era, s), era_cost_mult(era), {"era": era, "stage": s})
	out["hp"] = float(out["hp"]) * bal_f("boss.hp_mult")
	return out


static func _scaled_stats(base: Dictionary, stat_mult: float, cost_mult: float, extra: Dictionary) -> Dictionary:
	var out := {
		"id": base["id"], "role": base["role"], "era": base["era"], "mult": stat_mult,
		"hp": float(base["hp"]) * stat_mult,
		"damage": float(base["damage"]) * stat_mult,
		"cost": float(base["cost"]) * cost_mult,
		"interval": float(base["interval"]),
		"range": float(base["range"]),
		"range_px": range_to_px(float(base["range"])),
		"speed": float(base["speed"]),
		"spawn_cooldown": float(base["spawn_cooldown"]),
		"flags": (base["flags"] as Dictionary).duplicate(),
		"abilities": (base.get("abilities", {}) as Dictionary).duplicate(),
	}
	out.merge(extra)
	return out


## Food gained for killing something that costs `cost` Food: cost x 0.25.
static func kill_food(cost: float) -> float:
	return cost * bal_f("battle.kill_food_return")


# ------------------------------------------------------------------ stages and bases

## n = (era-1) x 10 + stage
static func stage_number(era: int, stage: int) -> int:
	return (era - 1) * bal_i("campaign.stages_per_era") + stage


@warning_ignore("integer_division")
static func era_of_stage(n: int) -> int:
	return (n - 1) / bal_i("campaign.stages_per_era") + 1


static func stage_in_era(n: int) -> int:
	return (n - 1) % bal_i("campaign.stages_per_era") + 1


static func is_boss_stage(n: int) -> bool:
	return stage_in_era(n) == bal_i("campaign.boss_stage")


## 1000 x (1 + 0.15 x (n-1))
static func enemy_base_hp(n: int) -> float:
	return bal_f("scaling.enemy_base_hp_start") * (1.0 + bal_f("scaling.enemy_base_hp_step") * (n - 1))


## 1000 x 1.6^(era-1) (era growth is a PROPOSAL, see balance.json) x (1 + 0.10 x (base level - 1)).
static func player_base_hp(era: int, base_level: int) -> float:
	return bal_f("battle.player_base_hp_era1") * pow(bal_f("battle.player_base_hp_era_mult"), era - 1) * base_hp_mult(base_level)


static func base_hp_mult(base_level: int) -> float:
	return 1.0 + bal_f("upgrades.base.hp_per_level") * (clampi(base_level, 1, bal_i("upgrades.base.max_level")) - 1)


# ------------------------------------------------------------------ upgrades (cost to REACH level L, L >= 2)

static func _upgrade_cost(section: String, level: int) -> int:
	if level < 2 or level > bal_i("upgrades.%s.max_level" % section):
		return -1
	return roundi(bal_f("upgrades.%s.cost_start" % section) * pow(bal_f("upgrades.%s.cost_growth" % section), level - 2))


## round(60 x 1.18^(L-2)); -1 outside 2..20.
static func unit_upgrade_cost(level: int) -> int:
	return _upgrade_cost("unit", level)


static func burrow_upgrade_cost(level: int) -> int:
	return _upgrade_cost("burrow", level)


static func base_upgrade_cost(level: int) -> int:
	return _upgrade_cost("base", level)


static func power_upgrade_cost(level: int) -> int:
	return _upgrade_cost("power", level)


static func burrow_income(level: int) -> float:
	return bal_f("battle.food_income_base") + bal_f("upgrades.burrow.income_per_level") * (clampi(level, 1, bal_i("upgrades.burrow.max_level")) - 1)


static func burrow_cap(level: int) -> float:
	return bal_f("battle.food_cap_base") + bal_f("upgrades.burrow.cap_per_level") * (clampi(level, 1, bal_i("upgrades.burrow.max_level")) - 1)


## Level-scaled power: {id, level, cooldown, effect{}}. Effect +12% per level on the entry's scaled_params
## (capped by param_caps), cooldown -4% per level (additive steps). Relic cooldown bonuses are applied by the caller.
static func power_params(id: String, level: int) -> Dictionary:
	var p := power(id)
	if p.is_empty():
		return {}
	var lv := clampi(level, 1, bal_i("upgrades.power.max_level"))
	var em := 1.0 + bal_f("upgrades.power.effect_per_level") * (lv - 1)
	var effect: Dictionary = (p["effect"] as Dictionary).duplicate()
	var caps: Dictionary = p.get("param_caps", {})
	for k in p.get("scaled_params", []):
		if effect.has(k):
			var v := float(effect[k]) * em
			if caps.has(k):
				v = minf(v, float(caps[k]))
			effect[k] = v
	var cd := float(p["cooldown"]) * (1.0 - bal_f("upgrades.power.cooldown_per_level") * (lv - 1))
	return {"id": id, "level": lv, "cooldown": cd, "effect": effect}


# ------------------------------------------------------------------ rewards (spec 6.4, 6.5, 6.6)

## round(30 x 1.06^(n-1))
static func win_coins(n: int) -> int:
	return roundi(bal_f("rewards.win_coins_base") * pow(bal_f("rewards.win_coins_growth"), n - 1))


static func first_clear_coins(n: int) -> int:
	return win_coins(n) * bal_i("rewards.first_clear_coins_mult")


## round(0.40 x win reward)
static func loss_coins(n: int) -> int:
	return roundi(win_coins(n) * bal_f("rewards.loss_fraction"))


## Underdog stacks after `consecutive_losses` losses in a row on the same stage: nothing until the
## 2nd loss, then each further loss adds one stack, up to 3 (literal reading of 6.4).
static func underdog_stacks(consecutive_losses: int) -> int:
	return clampi(consecutive_losses - bal_i("underdog.losses_to_trigger"), 0, bal_i("underdog.max_stacks"))


static func underdog_food_mult(stacks: int) -> float:
	return 1.0 + bal_f("underdog.food_per_stack") * clampi(stacks, 0, bal_i("underdog.max_stacks"))


static func underdog_base_hp_mult(stacks: int) -> float:
	return 1.0 + bal_f("underdog.base_hp_per_stack") * clampi(stacks, 0, bal_i("underdog.max_stacks"))


## min(3 + bosses cleared, 8) hours, plus 2 with the Golden Pass (the pass bonus sits on top of the cap).
static func offline_cap_hours(bosses_cleared: int, golden_pass := false) -> float:
	var h := minf(bal_f("offline.cap_hours_base") + bal_f("offline.cap_hours_per_boss") * bosses_cleared, bal_f("offline.cap_hours_max"))
	if golden_pass:
		h += bal_f("offline.golden_pass_bonus_hours")
	return h


## 2 + 0.4 x highest stage cleared
static func offline_coins_per_minute(highest_stage_cleared: int) -> float:
	return bal_f("offline.coins_per_min_base") + bal_f("offline.coins_per_min_per_stage") * highest_stage_cleared


## Coins for an absence of `away_minutes`, limited by the cap; rounded down.
static func offline_coins(highest_stage_cleared: int, away_minutes: float, bosses_cleared: int, golden_pass := false) -> int:
	var mins := minf(away_minutes, offline_cap_hours(bosses_cleared, golden_pass) * 60.0)
	return floori(offline_coins_per_minute(highest_stage_cleared) * maxf(mins, 0.0))


# ------------------------------------------------------------------ relics

## Sum of bonus x level over owned relics for `stat`, capped at +25%. `levels` maps relic id -> level.
static func relic_bonus(stat: String, levels: Dictionary) -> float:
	ensure_loaded()
	var total := 0.0
	for id in levels:
		var r := relic(str(id))
		if r.is_empty() or r.get("stat", "") != stat:
			continue
		var max_lv := int((_rarities.get(r["rarity"], {}) as Dictionary).get("max_level", 0))
		total += float(r["bonus"]) * clampi(int(levels[id]), 0, max_lv)
	return minf(total, bal_f("capsule.relic_bonus_cap"))


# ------------------------------------------------------------------ text helper

## Localized text of entry[field] (desc_key by default) with its desc_args filled in.
## desc_args is a list of [path, scale]; path is dotted inside the entry, or starts with "balance." for balance.json.
static func describe(entry: Dictionary, field := "desc_key") -> String:
	ensure_loaded()
	var args: Array = []
	for pair in entry.get("desc_args", []):
		var path := str(pair[0])
		var v = _path_get(_balance, path.substr(8)) if path.begins_with("balance.") else _path_get(entry, path)
		var num := float(v) if (v is float or v is int) else 0.0
		args.append(snappedf(num * float(pair[1]), 0.0001))
	return Localization.tr_key(str(entry.get(field, "")), args)


static func _path_get(root: Dictionary, path: String):
	var cur = root
	for part in path.split("."):
		if cur is Dictionary and (cur as Dictionary).has(part):
			cur = cur[part]
		else:
			return null
	return cur


# ------------------------------------------------------------------ validation

## All problems found in the data files (empty array = everything consistent).
static func validate() -> Array:
	ensure_loaded()
	return _errors.duplicate()


static func _is_snake(s: String) -> bool:
	var re := RegEx.new()
	re.compile("^[a-z][a-z0-9_]*$")
	return re.search(s) != null


static func _validate_data() -> Array:
	var errs: Array = []
	# balance
	for section in ["sim", "battle", "squad", "campaign", "scaling", "upgrades", "rewards", "underdog", "offline", "daily", "capsule", "ads", "era_rules", "boss", "roles"]:
		if not _balance.has(section):
			errs.append("balance.json: missing section '%s'" % section)
	for r in ROLES:
		var rb: Dictionary = (_balance.get("roles", {}) as Dictionary).get(r, {})
		if rb.is_empty():
			errs.append("balance.json: roles.%s missing" % r)
			continue
		for f in STAT_FIELDS:
			if not rb.has(f):
				errs.append("balance.json: roles.%s.%s missing" % [r, f])
	# entries
	var seen := {}
	var prefix := {"unit": "p", "enemy": "e", "boss": "b"}
	for pair in [["units", _units, _unit_ids], ["enemies", _enemies, _enemy_ids], ["bosses", _bosses, _boss_ids]]:
		var file: String = pair[0]
		var dict: Dictionary = pair[1]
		for id in pair[2]:
			var e: Dictionary = dict[id]
			var tag := "%s.json:%s" % [file, id]
			if not _is_snake(id):
				errs.append("%s: id is not lowercase snake_case" % tag)
			if seen.has(id):
				errs.append("%s: id also used in %s" % [tag, seen[id]])
			seen[id] = file
			if not ROLES.has(e["role"]):
				errs.append("%s: invalid role '%s'" % [tag, e["role"]])
			if int(e["era"]) < 1 or int(e["era"]) > 5:
				errs.append("%s: era out of 1..5" % tag)
			if str(e.get("sprite", "")) != id:
				errs.append("%s: sprite must equal id" % tag)
			if not id.begins_with("%s%d_" % [prefix[e["kind"]], int(e["era"])]):
				errs.append("%s: id must start with %s<era>_" % [tag, prefix[e["kind"]]])
			if float(e["hp"]) <= 0.0 or float(e["interval"]) <= 0.0 or float(e["speed"]) <= 0.0:
				errs.append("%s: hp, interval and speed must be > 0" % tag)
			for k in (e["flags"] as Dictionary):
				if not FLAG_NAMES.has(k):
					errs.append("%s: unknown flag '%s'" % [tag, k])
			if str(e.get("name_key", "")) == "" or str(e.get("desc_key", "")) == "":
				errs.append("%s: name_key/desc_key missing" % tag)
	for id in _boss_ids:
		var b: Dictionary = _bosses[id]
		for esc in b.get("escorts", []):
			if not _enemies.has(str(esc.get("enemy", ""))):
				errs.append("bosses.json:%s: escort enemy '%s' unknown" % [id, esc.get("enemy", "")])
		for blk in ["telegraph", "phase2"]:
			var en := str((b.get(blk, {}) as Dictionary).get("enemy", ""))
			if en != "" and not _enemies.has(en):
				errs.append("bosses.json:%s: %s enemy '%s' unknown" % [id, blk, en])
	# powers
	for id in _power_ids:
		var p: Dictionary = _powers[id]
		if not _is_snake(id):
			errs.append("powers.json:%s: id is not snake_case" % id)
		if float(p.get("cooldown", 0)) <= 0.0:
			errs.append("powers.json:%s: cooldown must be > 0" % id)
		for k in p.get("scaled_params", []):
			if not (p.get("effect", {}) as Dictionary).has(k):
				errs.append("powers.json:%s: scaled param '%s' not in effect" % [id, k])
		var ut := str((p.get("unlock", {}) as Dictionary).get("type", ""))
		if ut != "start" and ut != "boss":
			errs.append("powers.json:%s: unlock.type must be start or boss" % id)
	# relics
	var odds := 0.0
	for r in RARITIES:
		if not _rarities.has(r):
			errs.append("relics.json: rarity '%s' missing" % r)
		else:
			odds += float(_rarities[r].get("odds", 0.0))
	if absf(odds - 1.0) > 0.0001:
		errs.append("relics.json: rarity odds sum to %s, expected 1" % odds)
	for id in _relic_ids:
		var rel: Dictionary = _relics[id]
		if not _is_snake(id):
			errs.append("relics.json:%s: id is not snake_case" % id)
		if not RARITIES.has(str(rel.get("rarity", ""))):
			errs.append("relics.json:%s: invalid rarity" % id)
		if float(rel.get("bonus", 0.0)) <= 0.0:
			errs.append("relics.json:%s: bonus must be > 0" % id)
	# shop
	var pids := {}
	for p in _shop.get("products", []):
		var pid := str(p.get("id", ""))
		if pids.has(pid) or not _is_snake(pid):
			errs.append("shop.json:%s: duplicate or non-snake_case product id" % pid)
		pids[pid] = true
		if float(p.get("price_usd", 0.0)) <= 0.0:
			errs.append("shop.json:%s: price_usd must be > 0" % pid)
	# ads
	var aids: Array = []
	for pl in _ads.get("placements", []):
		aids.append(str(pl.get("id", "")))
		if not (pl.get("enabled") is bool):
			errs.append("ads.json:%s: enabled must be a bool" % pl.get("id", "?"))
	for ap in AD_PLACEMENTS:
		if not aids.has(ap):
			errs.append("ads.json: placement '%s' missing" % ap)
	return errs


# ------------------------------------------------------------------ stages (data/stages.json)

static var _stages: Dictionary = {}
static var _stages_loaded := false


static func _ensure_stages() -> void:
	if _stages_loaded:
		return
	_stages_loaded = true
	var raw := _read_json(DATA_DIR + "stages.json")
	for st in raw.get("stages", []):
		_stages["%d-%d" % [int(st["era"]), int(st["index"])]] = st


## Stage definition for era/stage (1-based), or {} if there is none.
static func stage(era: int, stage_index: int) -> Dictionary:
	_ensure_stages()
	return (_stages.get("%d-%d" % [era, stage_index], {}) as Dictionary).duplicate(true)


## All stage definitions of an era, ordered by index.
static func stages_of_era(era: int) -> Array:
	_ensure_stages()
	var out: Array = []
	for st in _stages.values():
		if int(st["era"]) == era:
			out.append((st as Dictionary).duplicate(true))
	out.sort_custom(func(a, b): return int(a["index"]) < int(b["index"]))
	return out
