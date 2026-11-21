class_name Capsules
extends RefCounted
## Time Capsules (spec 7.4): open a capsule for a relic, hard pity, duplicates to Chrono Dust, dust crafting,
## Gem purchase, Bonus Capsule ad. No UI. All numbers come from data/relics.json (rarities, odds, dust) and
## data/balance.json (`capsule.*`) and data/shop.json (`capsules` gem prices).
##
## Pity: a Rare or better is guaranteed on every `pity_rare_every`-th capsule since the last Rare+, an Epic on every
## `pity_epic_every`-th since the last Epic. Counters live in profile.pity {since_rare, since_epic, rng_state} and are
## saved with every opening, so closing the app never resets them.
##
## Randomness: pass a RandomNumberGenerator for tests/simulations (used as is, never reseeded). Without one, every
## opening seeds a local generator from profile.pity.rng_state (seeded from the clock the first time) and stores the
## next seed (50 bits, exact in JSON), so a saved profile always continues the same sequence.
##
## Result of one opening: {rarity, relic_id, kind: "new"|"level_up"|"dust", level, dust, pity_rare, pity_epic}
##   pity_rare/pity_epic are true when the guarantee (not luck) decided the rarity.

signal opened(results: Array)

const RARITY_ORDER: Array = ["common", "rare", "epic"]
const SEED_MASK := 0x3FFFFFFFFFFFF

var economy: Economy
var rng: RandomNumberGenerator   # injected, or null to use the profile's saved seed


func _init(p_economy: Economy, p_rng: RandomNumberGenerator = null) -> void:
	economy = p_economy
	rng = p_rng


var profile: Dictionary:
	get: return economy.profile


# ---------------------------------------------------------------- published numbers (shown on screen)

func rarity_odds() -> Dictionary:
	var out := {}
	for r in RARITY_ORDER:
		out[r] = float((DataDB.rarities().get(r, {}) as Dictionary).get("odds", 0.0))
	return out


func rare_every() -> int:
	return maxi(DataDB.bal_i("capsule.pity_rare_every", 5), 1)


func epic_every() -> int:
	return maxi(DataDB.bal_i("capsule.pity_epic_every", 20), 1)


## Visible pity state: {since_rare, since_epic, rare_in, epic_in} where *_in is how many more capsules until the
## guarantee (1 = the next capsule is guaranteed).
func pity() -> Dictionary:
	var p: Dictionary = profile["pity"]
	var sr := int(p.get("since_rare", 0))
	var se := int(p.get("since_epic", 0))
	return {"since_rare": sr, "since_epic": se,
		"rare_in": maxi(rare_every() - sr, 1), "epic_in": maxi(epic_every() - se, 1)}


func dust_on_duplicate(rarity: String) -> int:
	return int((DataDB.rarities().get(rarity, {}) as Dictionary).get("dust_on_duplicate", 0))


func dust_cost(rarity: String) -> int:
	return int((DataDB.rarities().get(rarity, {}) as Dictionary).get("dust_cost", 0))


func gem_price_single() -> int:
	return int((DataDB.shop().get("capsules", {}) as Dictionary).get("gem_price_single", 60))


func gem_price_bundle() -> int:
	return int((DataDB.shop().get("capsules", {}) as Dictionary).get("gem_price_bundle", 540))


func bundle_count() -> int:
	return int((DataDB.shop().get("capsules", {}) as Dictionary).get("bundle_count", 10))


func relics_of(rarity: String) -> Array:
	var out: Array = []
	for id in DataDB.relic_ids():
		if str(DataDB.relic(id).get("rarity", "")) == rarity:
			out.append(id)
	return out


# ---------------------------------------------------------------- rolling (pure part)

## Picks a rarity. `u` is uniform in [0, 1). Epic pity beats Rare pity; both only ever raise the rarity.
static func pick_rarity(u: float, odds: Dictionary, force_rare: bool, force_epic: bool) -> String:
	var r := "common"
	var acc := 0.0
	for k in RARITY_ORDER:
		acc += float(odds.get(k, 0.0))
		if u < acc:
			r = k
			break
		r = k   # u beyond the sum (rounding): the last tier
	if force_epic:
		return "epic"
	if force_rare and r == "common":
		return "rare"
	return r


## Next pity counters after a capsule of `rarity`.
static func next_counters(since_rare: int, since_epic: int, rarity: String) -> Array:
	var sr := 0 if rarity != "common" else since_rare + 1
	var se := 0 if rarity == "epic" else since_epic + 1
	return [sr, se]


# ---------------------------------------------------------------- opening

func can_open(count := 1) -> bool:
	return count > 0 and economy.can_afford("capsules", count)


## Opens one capsule (consumes 1 from currencies.capsules). Returns {} when there is none. `persist` false lets a
## caller batch the save.
func open_one(persist := true) -> Dictionary:
	if not economy.spend("capsules", 1, false):
		return {}
	var result := _roll_and_apply()
	if persist:
		economy.save_service.save()
	opened.emit([result])
	return result


## Opens up to `count` capsules with a single save. Returns the results in order (fewer when capsules run out).
func open_many(count: int) -> Array:
	var results: Array = []
	for _i in maxi(count, 0):
		if not economy.spend("capsules", 1, false):
			break
		results.append(_roll_and_apply())
	if not results.is_empty():
		economy.save_service.save()
		opened.emit(results)
	return results


func _roll_and_apply() -> Dictionary:
	var gen := rng
	var seeded := false
	var p: Dictionary = profile["pity"]
	if gen == null:
		gen = RandomNumberGenerator.new()
		var st := int(p.get("rng_state", 0))
		gen.seed = st if st > 0 else int(Time.get_ticks_usec()) ^ int(Time.get_unix_time_from_system() * 1000.0)
		seeded = true
	var sr := int(p.get("since_rare", 0))
	var se := int(p.get("since_epic", 0))
	var force_epic := se + 1 >= epic_every()
	var force_rare := sr + 1 >= rare_every()
	var u := gen.randf()
	var natural := pick_rarity(u, rarity_odds(), false, false)
	var rarity := pick_rarity(u, rarity_odds(), force_rare, force_epic)
	var pool := relics_of(rarity)
	var relic_id: String = str(pool[gen.randi() % pool.size()]) if not pool.is_empty() else ""
	var counters := next_counters(sr, se, rarity)
	p["since_rare"] = counters[0]
	p["since_epic"] = counters[1]
	if seeded:
		p["rng_state"] = maxi(int(gen.randi()) & SEED_MASK, 1)
	var result := _grant_relic(relic_id, rarity)
	# The guarantee "decided" the rarity when the natural roll would have been lower.
	result["pity_rare"] = rarity == "rare" and natural == "common"
	result["pity_epic"] = rarity == "epic" and natural != "epic"
	return result


## Gives the relic: new (level 1), level up, or Dust when already at max level. Does not save.
func _grant_relic(relic_id: String, rarity: String) -> Dictionary:
	var result := {"rarity": rarity, "relic_id": relic_id, "kind": "new", "level": 0, "dust": 0}
	if relic_id == "":
		return result
	var owned: Dictionary = profile["relics"]
	var lv := int(owned.get(relic_id, 0))
	var mx := Relics.max_level(relic_id)
	if lv >= mx:
		var dust := dust_on_duplicate(rarity)
		economy.add("chrono_dust", dust, false)
		result["kind"] = "dust"
		result["dust"] = dust
		result["level"] = lv
		return result
	owned[relic_id] = lv + 1
	result["kind"] = "new" if lv == 0 else "level_up"
	result["level"] = lv + 1
	if lv == 0:
		Relics.equip(profile, relic_id)   # auto-equip while a slot is free
	return result


# ---------------------------------------------------------------- Chrono Dust crafting

## Why `craft` would fail: "" if it can be done, else "unknown", "max_level" or "dust".
func craft_block_reason(relic_id: String) -> String:
	var r := DataDB.relic(relic_id)
	if r.is_empty():
		return "unknown"
	if Relics.level(profile, relic_id) >= Relics.max_level(relic_id):
		return "max_level"
	if not economy.can_afford("chrono_dust", dust_cost(str(r["rarity"]))):
		return "dust"
	return ""


## Buys the chosen relic with Dust (new at level 1, or +1 level). Returns {ok, reason, relic_id, level, cost}.
func craft(relic_id: String) -> Dictionary:
	var why := craft_block_reason(relic_id)
	if why != "":
		return {"ok": false, "reason": why, "relic_id": relic_id}
	var cost := dust_cost(str(DataDB.relic(relic_id)["rarity"]))
	economy.spend("chrono_dust", cost, false)
	var lv := Relics.level(profile, relic_id)
	profile["relics"][relic_id] = lv + 1
	if lv == 0:
		Relics.equip(profile, relic_id)
	economy.save_service.save()
	return {"ok": true, "reason": "", "relic_id": relic_id, "level": lv + 1, "cost": cost}


# ---------------------------------------------------------------- Gems and the Bonus Capsule ad

## Buys capsules with Gems: one (60) or the bundle (10 for 540). False when the Gems are short.
func buy_with_gems(bundle := false) -> bool:
	var price := gem_price_bundle() if bundle else gem_price_single()
	var n := bundle_count() if bundle else 1
	if not economy.spend("gems", price, false):
		return false
	economy.add("capsules", n, false)
	economy.save_service.save()
	return true


## Shows the opt-in Bonus Capsule rewarded ad when today's allowance is not used. The capsule itself is granted
## (exactly once, persisted first) by AdService -> Game -> Quests.apply_reward, and counted for the day there.
func request_bonus_ad(ads: AdService, quests: Quests, now := -1.0) -> bool:
	if not quests.bonus_capsule_available(now):
		return false
	return ads.show_ad("bonus_capsule", {"capsules": DataDB.bal_i("ads.bonus_capsule_count", 1)})
