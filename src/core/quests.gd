class_name Quests
extends RefCounted
## Daily quests (spec 6.6) and the daily-loop ad rewards. Plain class, no nodes. The UTC day number is
## Economy.day_index(now); `profile.quests` = {day, items: [{id, progress, claimed}], all_claimed_day}.
## Quests are picked deterministically from the day number (seeded shuffle of data/quests.json) and
## reset when the day changes. Rewards are paid with Economy.add_bundle (persisted).
## Progress comes from Economy.battle_settled (battle_won) and record_battle_stats (units/powers of the
## finished battle). Every method takes `now` (unix seconds, UTC) so tests control the clock; -1 = real clock.

signal changed

const DAILY_COUNT := 3

var save_service: SaveService
var economy: Economy


func _init(p_save: SaveService, p_economy: Economy) -> void:
	save_service = p_save
	economy = p_economy
	economy.battle_settled.connect(_on_battle_settled)


func shutdown() -> void:
	if economy != null and economy.battle_settled.is_connected(_on_battle_settled):
		economy.battle_settled.disconnect(_on_battle_settled)


var profile: Dictionary:
	get: return save_service.profile


static func _clock(now: float) -> float:
	return Time.get_unix_time_from_system() if now < 0.0 else now


## Deterministic daily pick: ids of DAILY_COUNT quests (fewer if the pool is smaller), same for the same day.
static func pick_ids(day: int) -> Array:
	var ids: Array = []
	for q in DataDB.quests():
		ids.append(str(q["id"]))
	var rng := RandomNumberGenerator.new()
	rng.seed = day * 2654435761 + 40503
	for i in range(ids.size() - 1, 0, -1):
		var j := rng.randi_range(0, i)
		var tmp = ids[i]
		ids[i] = ids[j]
		ids[j] = tmp
	return ids.slice(0, mini(DAILY_COUNT, ids.size()))


static func quest_def(id: String) -> Dictionary:
	for q in DataDB.quests():
		if str(q["id"]) == id:
			return q
	return {}


## Rolls the quest list over when the UTC day changed (or on the first call). Returns true when it reset.
func ensure_today(now := -1.0) -> bool:
	var day := Economy.day_index(_clock(now))
	var q: Dictionary = profile["quests"]
	if int(q.get("day", 0)) == day and not (q.get("items", []) as Array).is_empty():
		return false
	var items: Array = []
	for id in pick_ids(day):
		items.append({"id": id, "progress": 0, "claimed": false})
	q["day"] = day
	q["items"] = items
	save_service.save()
	changed.emit()
	return true


func items(now := -1.0) -> Array:
	ensure_today(now)
	return profile["quests"]["items"]


func item(id: String, now := -1.0) -> Dictionary:
	for it in items(now):
		if str(it["id"]) == id:
			return it
	return {}


func target_of(id: String) -> int:
	return int(quest_def(id).get("target", 1))


func is_complete(id: String, now := -1.0) -> bool:
	var it := item(id, now)
	return not it.is_empty() and int(it["progress"]) >= target_of(id)


func can_claim(id: String, now := -1.0) -> bool:
	var it := item(id, now)
	return not it.is_empty() and not bool(it["claimed"]) and is_complete(id, now)


func claimable_count(now := -1.0) -> int:
	var n := 0
	for it in items(now):
		if can_claim(str(it["id"]), now):
			n += 1
	return n


## Adds `amount` to every quest of today that counts `event` ("battle_won", "power_used", "unit_spawned").
func record(event: String, amount := 1, now := -1.0) -> void:
	if amount <= 0:
		return
	var touched := false
	for it in items(now):
		if bool(it["claimed"]):
			continue
		var def := quest_def(str(it["id"]))
		if str(def.get("event", "")) == event:
			it["progress"] = mini(int(it["progress"]) + amount, target_of(str(it["id"])))
			touched = true
	if touched:
		save_service.save()
		changed.emit()


## Called by the result screen once per settled battle with sim.stats ({units_spawned, powers_used, ...}).
func record_battle_stats(stats: Dictionary, now := -1.0) -> void:
	var s: Dictionary = profile["stats"]
	var units := int(stats.get("units_spawned", 0))
	var powers := int(stats.get("powers_used", 0))
	s["units_spawned"] = int(s.get("units_spawned", 0)) + units
	s["powers_used"] = int(s.get("powers_used", 0)) + powers
	save_service.save()
	record("unit_spawned", units, now)
	record("power_used", powers, now)


func _on_battle_settled(result: Dictionary) -> void:
	var s: Dictionary = profile["stats"]
	s["battles_played"] = int(s.get("battles_played", 0)) + 1
	if bool(result.get("won", false)):
		s["battles_won"] = int(s.get("battles_won", 0)) + 1
		record("battle_won", 1)
	else:
		save_service.save()


## Pays the quest reward once. Returns false when not complete or already claimed.
func claim(id: String, now := -1.0) -> bool:
	if not can_claim(id, now):
		return false
	var it := item(id, now)
	it["claimed"] = true
	var all := true
	for other in profile["quests"]["items"]:
		all = all and bool(other["claimed"])
	if all:
		profile["quests"]["all_claimed_day"] = int(profile["quests"]["day"])
	economy.add_bundle(quest_def(id).get("reward", {}))   # persists together with the flag
	changed.emit()
	return true


# ---------------------------------------------------------------- ad rewards of the daily loop

## Bonus Capsule: at most `ads.bonus_capsule_per_day` per UTC day (counter in profile.seen).
func bonus_capsules_today(now := -1.0) -> int:
	var b = profile["seen"].get("bonus_capsule", {})
	if typeof(b) == TYPE_DICTIONARY and int(b.get("day", -1)) == Economy.day_index(_clock(now)):
		return int(b.get("n", 0))
	return 0


func bonus_capsule_available(now := -1.0) -> bool:
	return bonus_capsules_today(now) < DataDB.bal_i("ads.bonus_capsule_per_day", 1)


## Applies a granted ad reward that is not owned by a screen. Called by Game's global reward listener;
## AdService hands each reward out exactly once. Returns true when it was handled here.
##   double_farm   {coins, multiplier}: claims the pending farm coins x multiplier, or, if the player already
##                 claimed them meanwhile, pays only the missing extra (coins x (multiplier - 1)).
##   bonus_capsule {capsules}: capsules, counted for today (the player is never refused a reward already granted).
##   double_coins  {coins}: the extra Coins of a battle whose result screen is gone (re-delivery after a kill).
func apply_reward(placement: String, reward: Dictionary, now := -1.0) -> bool:
	var t := _clock(now)
	match placement:
		"double_farm":
			var mult := maxi(int(reward.get("multiplier", DataDB.bal_i("ads.double_farm_mult", 2))), 1)
			if economy.offline_pending(t) > 0:
				economy.claim_offline(t, 0.0, mult)
			else:
				economy.add("coins", int(reward.get("coins", 0)) * (mult - 1))
			return true
		"bonus_capsule":
			economy.add("capsules", int(reward.get("capsules", DataDB.bal_i("ads.bonus_capsule_count", 1))))
			profile["seen"]["bonus_capsule"] = {"day": Economy.day_index(t), "n": bonus_capsules_today(t) + 1}
			save_service.save()
			changed.emit()
			return true
		"double_coins":
			economy.add("coins", int(reward.get("coins", 0)))
			return true
	return false
