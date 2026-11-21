class_name Relics
extends RefCounted
## Relic collection and their battle effects (spec 7.4). Static, pure functions over the profile Dictionary.
## profile.relics: relic id -> level (1..max of its rarity). profile.loadout.equipped_relics: ids that are active.
## Only equipped relics apply (at most `capsule.relic_slots`). Per stat the total is capped by DataDB.relic_bonus
## (`capsule.relic_bonus_cap`, +25%). Newly obtained relics are auto-equipped while a slot is free.

const STATS: Array = ["food_income", "coins", "base_hp", "unit_damage", "unit_hp", "spawn_cooldown", "power_cooldown"]


static func slots() -> int:
	return maxi(DataDB.bal_i("capsule.relic_slots", 4), 0)


static func levels(profile: Dictionary) -> Dictionary:
	return profile.get("relics", {})


static func level(profile: Dictionary, id: String) -> int:
	return int(levels(profile).get(id, 0))


static func max_level(id: String) -> int:
	var r := DataDB.relic(id)
	if r.is_empty():
		return 0
	return int((DataDB.rarities().get(str(r["rarity"]), {}) as Dictionary).get("max_level", 0))


## Equipped ids, in equip order, dropping ids that are not owned (corrupt/edited saves) or beyond the slot limit.
static func equipped(profile: Dictionary) -> Array:
	var out: Array = []
	var raw = profile.get("loadout", {}).get("equipped_relics", [])
	if typeof(raw) != TYPE_ARRAY:
		return out
	for id in raw:
		var s := str(id)
		if level(profile, s) > 0 and not out.has(s) and out.size() < slots():
			out.append(s)
	return out


static func is_equipped(profile: Dictionary, id: String) -> bool:
	return equipped(profile).has(id)


## Equips an owned relic. False when not owned, already equipped or no free slot. Does not save.
static func equip(profile: Dictionary, id: String) -> bool:
	var eq := equipped(profile)
	if level(profile, id) <= 0 or eq.has(id) or eq.size() >= slots():
		return false
	eq.append(id)
	_store(profile, eq)
	return true


static func unequip(profile: Dictionary, id: String) -> bool:
	var eq := equipped(profile)
	if not eq.has(id):
		return false
	eq.erase(id)
	_store(profile, eq)
	return true


static func _store(profile: Dictionary, eq: Array) -> void:
	if not profile.has("loadout"):
		profile["loadout"] = {}
	profile["loadout"]["equipped_relics"] = eq


## Fractional bonus per stat of the equipped relics, e.g. {"food_income": 0.05, ...}. Every stat is present.
## spawn_cooldown / power_cooldown are REDUCTIONS (0.05 = -5%). Deterministic, no side effects.
static func modifiers(profile: Dictionary) -> Dictionary:
	var lv := {}
	for id in equipped(profile):
		lv[id] = level(profile, id)
	var out := {}
	for stat in STATS:
		out[stat] = DataDB.relic_bonus(stat, lv)
	return out


## True when `mods` changes nothing.
static func is_neutral(mods: Dictionary) -> bool:
	for k in mods:
		if absf(float(mods[k])) > 0.0:
			return false
	return true
