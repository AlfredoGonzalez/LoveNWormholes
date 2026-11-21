class_name Tutorial
extends RefCounted
## Guided first battles (spec 9.2): the step list (data/tutorial.json) and the flags in
## profile.seen["tutorial"] = {armed: bool, skipped: bool, steps: {step_id: true}}.
## It is armed by the intro story (Story.mark_seen), so a profile that never saw the intro (tests, tools) gets
## no tutorial. Never active on a stage that was already cleared, and never again after Skip.
## The overlay (TutorialDirector / TutorialOverlay) is presentation only: it never changes BattleSim.

const PATH := "res://data/tutorial.json"

static var _steps: Array = []
static var _loaded := false


static func _ensure_loaded() -> void:
	if _loaded:
		return
	_loaded = true
	_steps = []
	var f := FileAccess.open(PATH, FileAccess.READ)
	if f == null:
		return
	var parsed = JSON.parse_string(f.get_as_text())
	if typeof(parsed) == TYPE_DICTIONARY and typeof((parsed as Dictionary).get("steps", [])) == TYPE_ARRAY:
		_steps = (parsed as Dictionary)["steps"]


## Every step with its global position as "index" (the analytics step index).
static func all_steps() -> Array:
	_ensure_loaded()
	var out: Array = []
	for i in _steps.size():
		var s: Dictionary = (_steps[i] as Dictionary).duplicate(true)
		s["index"] = i
		out.append(s)
	return out


static func steps_for_stage(era: int, stage: int) -> Array:
	var key := "%d-%d" % [era, stage]
	var out: Array = []
	for s in all_steps():
		if str(s.get("stage", "")) == key:
			out.append(s)
	return out


static func flags(profile: Dictionary, create := false) -> Dictionary:
	if not profile.has("seen") or typeof(profile["seen"]) != TYPE_DICTIONARY:
		if not create:
			return {}
		profile["seen"] = {}
	var seen: Dictionary = profile["seen"]
	if not seen.has("tutorial") or typeof(seen["tutorial"]) != TYPE_DICTIONARY:
		if not create:
			return {}
		seen["tutorial"] = {"armed": false, "skipped": false, "steps": {}}
	var f: Dictionary = seen["tutorial"]
	if create:
		if typeof(f.get("steps", null)) != TYPE_DICTIONARY:
			f["steps"] = {}
	return f


static func arm(profile: Dictionary) -> void:
	var f := flags(profile, true)
	if not f.has("armed_once"):   # re-viewing the intro from Settings must not bring the tutorial back
		f["armed_once"] = true
		f["armed"] = true


static func is_armed(profile: Dictionary) -> bool:
	return bool(flags(profile).get("armed", false))


static func is_skipped(profile: Dictionary) -> bool:
	return bool(flags(profile).get("skipped", false))


static func step_done(profile: Dictionary, id: String) -> bool:
	return bool((flags(profile).get("steps", {}) as Dictionary).get(id, false))


static func mark_step(profile: Dictionary, id: String) -> void:
	(flags(profile, true)["steps"] as Dictionary)[id] = true


static func skip(profile: Dictionary) -> void:
	flags(profile, true)["skipped"] = true


## Steps still to show on this stage (empty when not armed, skipped, or the stage was already cleared).
static func pending_for_stage(profile: Dictionary, era: int, stage: int) -> Array:
	if not is_armed(profile) or is_skipped(profile) or Progress.is_stage_cleared(profile, era, stage):
		return []
	var out: Array = []
	for s in steps_for_stage(era, stage):
		if not step_done(profile, str(s["id"])):
			out.append(s)
	return out
