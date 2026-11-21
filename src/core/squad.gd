class_name Squad
extends RefCounted
## Time Squad and equipped powers (spec 4.3, 4.5, 5.1), answered from a save profile (SaveService.default_profile shape).
## Static and pure: reads never mutate. Writers (set_*) change the profile dictionary in place and return true on
## success; the caller persists with Game.save.save() (or use the *_and_save helpers that take a SaveService).
## Every number comes from data/balance.json squad.* / campaign.* and data/powers.json.

const DEFAULT_POWERS := ["squirm_slam", "apple_rain"]


# ------------------------------------------------------------------ units

## Every player unit of every unlocked era, in data order.
static func unlocked_units(profile: Dictionary) -> Array[String]:
	var out: Array[String] = []
	for id in DataDB.unit_ids():
		if Progress.is_era_unlocked(profile, int(DataDB.unit(str(id))["era"])):
			out.append(str(id))
	return out


static func is_unit_unlocked(profile: Dictionary, id: String) -> bool:
	var u := DataDB.unit(id)
	return not u.is_empty() and Progress.is_era_unlocked(profile, int(u["era"]))


static func unit_level(profile: Dictionary, id: String) -> int:
	return int((profile.get("units", {}) as Dictionary).get(id, 1))


static func boss_cleared(profile: Dictionary, era: int) -> bool:
	return Progress.highest_in_era(profile, era) >= DataDB.bal_i("campaign.boss_stage", 10)


## Squad slots: slots_start, +1 once the boss of campaign.squad_slot5_after_boss_era is cleared (max slots_max).
static func slots(profile: Dictionary) -> int:
	var n := DataDB.bal_i("squad.slots_start", 4)
	if boss_cleared(profile, slot_unlock_era()):
		n += 1
	return mini(n, max_slots())


static func max_slots() -> int:
	return DataDB.bal_i("squad.slots_max", 5)


## Era whose boss unlocks the next squad slot (for the "Unlocks after the Era N boss" note).
static func slot_unlock_era() -> int:
	return DataDB.bal_i("campaign.squad_slot5_after_boss_era", 2)


## Presets available: squad.presets_start, more only when the profile already holds them (bought later), max presets_max.
static func preset_count(profile: Dictionary) -> int:
	var have: int = (_loadout(profile).get("squad_presets", []) as Array).size()
	return clampi(maxi(DataDB.bal_i("squad.presets_start", 2), have), 1, preset_max())


static func preset_max() -> int:
	return DataDB.bal_i("squad.presets_max", 3)


static func active_index(profile: Dictionary) -> int:
	return clampi(int(_loadout(profile).get("active_preset", 0)), 0, preset_count(profile) - 1)


static func set_active_index(profile: Dictionary, index: int) -> bool:
	if index < 0 or index >= preset_count(profile):
		return false
	_loadout(profile)["active_preset"] = index
	return true


## Unlocked ids of `ids` without duplicates, trimmed to the slots. Unknown or locked ids are dropped.
static func sanitize(profile: Dictionary, ids: Array) -> Array:
	var out: Array = []
	for raw in ids:
		var id := str(raw)
		if id in out or not is_unit_unlocked(profile, id):
			continue
		out.append(id)
		if out.size() >= slots(profile):
			break
	return out


## Defaults: the era-1 trio, then the best (latest era first, data order inside an era) unlocked units, up to the slots.
static func default_squad(profile: Dictionary) -> Array:
	var out: Array = []
	for u in DataDB.units_of_era(1):
		if out.size() < 3:
			out.append(str(u["id"]))
	var eras := DataDB.bal_i("campaign.eras", 5)
	for era in range(eras, 0, -1):
		for u in DataDB.units_of_era(era):
			if out.size() < slots(profile) and not (str(u["id"]) in out) and is_unit_unlocked(profile, str(u["id"])):
				out.append(str(u["id"]))
	return sanitize(profile, out)


## Stored ids of preset `index` (raw, not validated).
static func preset(profile: Dictionary, index: int) -> Array:
	var presets: Array = _loadout(profile).get("squad_presets", [])
	if index < 0 or index >= presets.size():
		return []
	return (presets[index] as Array).duplicate()


## The validated squad of preset `index`; an empty/invalid one is filled with the defaults.
static func preset_units(profile: Dictionary, index: int) -> Array:
	var ids := sanitize(profile, preset(profile, index))
	return ids if not ids.is_empty() else default_squad(profile)


## The active preset's validated squad (what the battle uses).
static func active(profile: Dictionary) -> Array:
	return preset_units(profile, active_index(profile))


## Stores `ids` in preset `index` of the profile. Returns false (nothing changes) when the index is out of
## range, the list is empty, has duplicates, has a locked/unknown unit or exceeds the slots.
static func set_preset(profile: Dictionary, index: int, ids: Array) -> bool:
	if index < 0 or index >= preset_count(profile) or ids.is_empty() or ids.size() > slots(profile):
		return false
	var clean: Array = []
	for raw in ids:
		var id := str(raw)
		if id in clean or not is_unit_unlocked(profile, id):
			return false
		clean.append(id)
	var lo := _loadout(profile)
	var presets: Array = lo.get("squad_presets", [])
	while presets.size() <= index:
		presets.append([])
	presets[index] = clean
	lo["squad_presets"] = presets
	return true


static func set_preset_and_save(save: SaveService, index: int, ids: Array) -> bool:
	if not set_preset(save.profile, index, ids):
		return false
	return save.save()


# ------------------------------------------------------------------ powers

## Powers whose unlock rule is met (powers.json unlock: start, or boss of era N cleared), in data order.
static func unlocked_powers(profile: Dictionary) -> Array[String]:
	var out: Array[String] = []
	for id in DataDB.power_ids():
		if is_power_unlocked(profile, str(id)):
			out.append(str(id))
	return out


static func is_power_unlocked(profile: Dictionary, id: String) -> bool:
	var d := DataDB.power(id)
	if d.is_empty():
		return false
	var rule: Dictionary = d.get("unlock", {"type": "start"})
	if str(rule.get("type", "start")) == "boss":
		return boss_cleared(profile, int(rule.get("era", 1)))
	return true


## Power slots: power_slots_start, +1 after the boss of campaign.power_slot3_after_boss_era (max power_slots_max).
static func power_slots(profile: Dictionary) -> int:
	var n := DataDB.bal_i("squad.power_slots_start", 2)
	if boss_cleared(profile, power_slot_unlock_era()):
		n += 1
	return mini(n, max_power_slots())


static func max_power_slots() -> int:
	return DataDB.bal_i("squad.power_slots_max", 3)


static func power_slot_unlock_era() -> int:
	return DataDB.bal_i("campaign.power_slot3_after_boss_era", 3)


## Equipped powers: validated (unlocked, no duplicates, trimmed to the power slots); defaults when empty.
static func equipped_powers(profile: Dictionary) -> Array:
	var out: Array = []
	for raw in _loadout(profile).get("equipped_powers", []):
		var id := str(raw)
		if id in out or not is_power_unlocked(profile, id):
			continue
		out.append(id)
		if out.size() >= power_slots(profile):
			break
	if out.is_empty():
		for id in DEFAULT_POWERS:
			if out.size() < power_slots(profile) and is_power_unlocked(profile, id):
				out.append(id)
	return out


## Same rules as set_preset: false and no change on empty, duplicate, locked/unknown or too many powers.
static func set_equipped_powers(profile: Dictionary, ids: Array) -> bool:
	if ids.is_empty() or ids.size() > power_slots(profile):
		return false
	var clean: Array = []
	for raw in ids:
		var id := str(raw)
		if id in clean or not is_power_unlocked(profile, id):
			return false
		clean.append(id)
	_loadout(profile)["equipped_powers"] = clean
	return true


static func set_equipped_powers_and_save(save: SaveService, ids: Array) -> bool:
	if not set_equipped_powers(save.profile, ids):
		return false
	return save.save()


## Result of putting `power_id` into `slot` of `current`: if it is already equipped elsewhere the two swap.
static func power_with_slot(current: Array, slot: int, power_id: String) -> Array:
	var out := current.duplicate()
	while out.size() <= slot:
		out.append("")
	var prev := str(out[slot])
	var other := out.find(power_id)
	if other >= 0 and other != slot:
		out[other] = prev
	out[slot] = power_id
	return out.filter(func(x): return str(x) != "")


static func _loadout(profile: Dictionary) -> Dictionary:
	if not profile.has("loadout") or typeof(profile["loadout"]) != TYPE_DICTIONARY:
		profile["loadout"] = {}
	return profile["loadout"]
