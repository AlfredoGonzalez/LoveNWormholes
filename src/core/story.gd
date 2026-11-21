class_name Story
extends RefCounted
## Story sequences (spec 3, 9.2): the comic panels of data/story.json plus the "already seen" flags in
## profile.seen["story"] (id -> true). Pure logic, no nodes: the StoryScreen plays a sequence, and the
## screens that start a battle / finish one / open Home ask the route_* helpers where to go next.
##
## Era story only plays once the player went through the intro (profile.seen has "story"), so a profile
## that never visited the Title (tests, tools) behaves exactly as before.

const PATH := "res://data/story.json"
const REPLAY := "replay"        # StoryScreen param: play everything the player has unlocked

static var _data: Dictionary = {}
static var _loaded := false


static func _ensure_loaded() -> void:
	if _loaded:
		return
	_loaded = true
	_data = {}
	var f := FileAccess.open(PATH, FileAccess.READ)
	if f == null:
		return
	var parsed = JSON.parse_string(f.get_as_text())
	if typeof(parsed) == TYPE_DICTIONARY:
		_data = parsed


static func reload() -> void:
	_loaded = false
	_ensure_loaded()


## Ids of every sequence, in story order.
static func order() -> Array:
	_ensure_loaded()
	return (_data.get("order", []) as Array).duplicate()


static func has_sequence(id: String) -> bool:
	_ensure_loaded()
	return (_data.get("sequences", {}) as Dictionary).has(id)


## Panels of a sequence: [{art, color, caption, text_key}]. Empty for an unknown id.
static func panels(id: String) -> Array:
	_ensure_loaded()
	var seq = (_data.get("sequences", {}) as Dictionary).get(id, {})
	return (seq.get("panels", []) as Array).duplicate(true) if typeof(seq) == TYPE_DICTIONARY else []


static func era_open_id(era: int) -> String:
	return "era_%d_open" % era


static func era_close_id(era: int) -> String:
	return "era_%d_close" % era


# ------------------------------------------------------------------ flags

static func _seen_dict(profile: Dictionary, create := false) -> Dictionary:
	if not profile.has("seen") or typeof(profile["seen"]) != TYPE_DICTIONARY:
		if not create:
			return {}
		profile["seen"] = {}
	var seen: Dictionary = profile["seen"]
	if not seen.has("story") or typeof(seen["story"]) != TYPE_DICTIONARY:
		if not create:
			return {}
		seen["story"] = {}
	return seen["story"]


static func is_seen(profile: Dictionary, id: String) -> bool:
	return bool(_seen_dict(profile).get(id, false))


## The player already went through the intro (seen or skipped): era comics and the ending are active.
static func enabled(profile: Dictionary) -> bool:
	return profile.has("seen") and typeof(profile["seen"]) == TYPE_DICTIONARY and (profile["seen"] as Dictionary).has("story")


## Marks a sequence as shown. The intro also arms the battle tutorial (first-time experience, spec 9.2).
static func mark_seen(profile: Dictionary, id: String) -> void:
	_seen_dict(profile, true)[id] = true
	if id == "intro":
		Tutorial.arm(profile)


## Tolerant read of the flag another module sets when the last boss is beaten.
static func game_completed(profile: Dictionary) -> bool:
	var prog = profile.get("progress", {})
	return typeof(prog) == TYPE_DICTIONARY and bool((prog as Dictionary).get("game_completed", false))


static func ending_pending(profile: Dictionary) -> bool:
	return enabled(profile) and game_completed(profile) and not is_seen(profile, "ending")


# ------------------------------------------------------------------ routing

## [screen, params] that plays `id` and then continues to next/next_params, or [next, next_params] when it was seen.
static func route(profile: Dictionary, id: String, next: String, next_params: Dictionary = {}) -> Array:
	if not has_sequence(id) or is_seen(profile, id):
		return [next, next_params]
	return ["story", {"seq": id, "next": next, "next_params": next_params}]


## Before a battle starts: stage 1 of an era shows the era opening once.
static func before_battle(profile: Dictionary, era: int, stage: int, battle_params: Dictionary) -> Array:
	if stage == 1 and not bool(battle_params.get("resume", false)) and enabled(profile):
		return route(profile, era_open_id(era), "battle", battle_params)
	return ["battle", battle_params]


## After a battle: beating the boss shows the era closing once, before the result screen.
static func after_battle(profile: Dictionary, result: String, era: int, stage: int, result_params: Dictionary) -> Array:
	if result == "win" and stage == DataDB.bal_i("campaign.boss_stage", 10) and enabled(profile):
		return route(profile, era_close_id(era), "result", result_params)
	return ["result", result_params]


## Sequence ids the player may replay from Settings: the intro, every unlocked era opening, every beaten boss
## closing, and the ending once the game was completed (or seen). Spoiler free.
static func replay_ids(profile: Dictionary) -> Array:
	var out: Array = []
	for id in order():
		var sid := str(id)
		var ok := is_seen(profile, sid)
		if sid == "intro":
			ok = true
		elif sid == "ending":
			ok = ok or game_completed(profile)
		else:
			var parts := sid.split("_")
			if parts.size() == 3:
				var era := int(parts[1])
				if parts[2] == "open":
					ok = ok or Progress.is_era_unlocked(profile, era)
				else:
					ok = ok or Progress.highest_in_era(profile, era) >= DataDB.bal_i("campaign.boss_stage", 10)
		if ok:
			out.append(sid)
	return out
