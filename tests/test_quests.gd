extends TestCase
## Daily quests: deterministic pick, UTC day rollover, progress from events, claim once, persistence, ad rewards.

const SAVE := "user://test_quests_save.json"
const DAY := 86400.0
const T0 := 1_800_000_000.0   # an arbitrary UTC moment


func _clean() -> void:
	for f in [SAVE, SAVE.get_basename() + ".bak.json", SAVE + ".tmp"]:
		DirAccess.remove_absolute(ProjectSettings.globalize_path(f))


func _make() -> Array:
	DataDB.ensure_loaded()
	var save := SaveService.new(SAVE)
	save.load_profile()
	var eco := Economy.new(DataDB.balance(), save)
	return [Quests.new(save, eco), eco, save]


func test_pick_is_deterministic_and_sized() -> void:
	DataDB.ensure_loaded()
	var a := Quests.pick_ids(20000)
	assert_eq(a, Quests.pick_ids(20000))
	assert_eq(a.size(), mini(Quests.DAILY_COUNT, DataDB.quests().size()))
	var seen := {}
	for id in a:
		assert_true(not seen.has(id), "no duplicates")
		seen[id] = true
		assert_true(not Quests.quest_def(id).is_empty())


func test_rollover_resets_on_utc_day_change() -> void:
	_clean()
	var q: Quests = _make()[0]
	assert_true(q.ensure_today(T0), "first call creates the list")
	assert_true(not q.ensure_today(T0 + 60.0), "same UTC day keeps it")
	var first: Array = q.items(T0)
	var id := str(first[0]["id"])
	q.record(str(Quests.quest_def(id)["event"]), 1, T0)
	assert_eq(int(q.item(id, T0)["progress"]), 1)
	var day := Economy.day_index(T0)
	var next_day_time := (day + 1) * DAY + 5.0
	assert_true(q.ensure_today(next_day_time), "new UTC day resets")
	assert_eq(int(q.item(id, next_day_time)["progress"]), 0)
	assert_eq(int(q.save_service.profile["quests"]["day"]), day + 1)
	_clean()


func test_progress_from_events_and_cap() -> void:
	_clean()
	var q: Quests = _make()[0]
	for it in q.items(T0):
		var id := str(it["id"])
		var def := Quests.quest_def(id)
		q.record(str(def["event"]), 1, T0)
		assert_eq(int(q.item(id, T0)["progress"]), 1, id)
		q.record(str(def["event"]), 10000, T0)
		assert_eq(int(q.item(id, T0)["progress"]), int(def["target"]), "capped at target " + id)
		assert_true(q.is_complete(id, T0))
	q.record("unknown_event", 5, T0)   # ignored
	_clean()


func test_battle_stats_and_settled_events() -> void:
	_clean()
	var parts := _make()
	var q: Quests = parts[0]
	var eco: Economy = parts[1]
	var save: SaveService = parts[2]
	q.ensure_today()   # real clock: battle_settled records with the real day
	eco.settle_battle(1, 1, true, 3, 1)
	eco.settle_battle(1, 2, false, 0, 1)
	assert_eq(int(save.profile["stats"]["battles_played"]), 2)
	assert_eq(int(save.profile["stats"]["battles_won"]), 1)
	q.record_battle_stats({"units_spawned": 12, "powers_used": 2})
	assert_eq(int(save.profile["stats"]["units_spawned"]), 12)
	assert_eq(int(save.profile["stats"]["powers_used"]), 2)
	for it in q.items():
		var ev := str(Quests.quest_def(str(it["id"]))["event"])
		var expect: int = {"battle_won": 1, "unit_spawned": 12, "power_used": 2}.get(ev, 0)
		assert_eq(int(it["progress"]), expect, ev)
	_clean()


func test_claim_once_and_persistence() -> void:
	_clean()
	var parts := _make()
	var q: Quests = parts[0]
	var eco: Economy = parts[1]
	var id := str(q.items(T0)[0]["id"])
	var def := Quests.quest_def(id)
	assert_true(not q.claim(id, T0), "not complete yet")
	q.record(str(def["event"]), int(def["target"]), T0)
	assert_eq(q.claimable_count(T0), 1)
	var coins := eco.get_amount("coins")
	var gems := eco.get_amount("gems")
	assert_true(q.claim(id, T0))
	assert_true(not q.claim(id, T0), "second claim refused")
	assert_eq(eco.get_amount("coins"), coins + int(def["reward"]["coins"]))
	assert_eq(eco.get_amount("gems"), gems + int(def["reward"]["gems"]))
	assert_eq(q.claimable_count(T0), 0)
	# reload from disk: claimed flag, progress and currencies survive
	var save2 := SaveService.new(SAVE)
	save2.load_profile()
	assert_eq(int(save2.profile["quests"]["day"]), Economy.day_index(T0))
	var found := false
	for it in save2.profile["quests"]["items"]:
		if str(it["id"]) == id:
			found = true
			assert_true(bool(it["claimed"]))
	assert_true(found)
	assert_eq(int(save2.profile["currencies"]["coins"]), eco.get_amount("coins"))
	_clean()


func test_bonus_capsule_limit_and_double_farm_rewards() -> void:
	_clean()
	var parts := _make()
	var q: Quests = parts[0]
	var eco: Economy = parts[1]
	assert_true(q.bonus_capsule_available(T0))
	assert_true(q.apply_reward("bonus_capsule", {"capsules": 1}, T0))
	assert_eq(eco.get_amount("capsules"), 1)
	assert_true(not q.bonus_capsule_available(T0), "max 1 per day")
	assert_true(q.bonus_capsule_available(T0 + DAY), "available again next day")
	# double farm: pending farm is claimed x2 (cap reached, so exact)
	eco.profile["timestamps"]["offline_farm"] = T0 - 10 * 3600.0
	var pending := eco.offline_pending(T0)
	assert_true(pending > 0)
	q.apply_reward("double_farm", {"coins": pending, "multiplier": 2}, T0)
	assert_eq(eco.get_amount("coins"), pending * 2)
	assert_eq(eco.offline_pending(T0), 0, "timer restarted")
	# already claimed meanwhile: only the missing extra is paid
	q.apply_reward("double_farm", {"coins": pending, "multiplier": 2}, T0)
	assert_eq(eco.get_amount("coins"), pending * 3)
	assert_true(not q.apply_reward("unknown", {}, T0))
	_clean()
