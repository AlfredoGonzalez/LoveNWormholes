class_name SaveService
extends RefCounted
## Player profile persistence (spec 8.3, 8.7): JSON with schema version, SHA-256 checksum, atomic write
## (temp file then rename), rolling backup (save.json + save.bak.json), versioned migrations.
## Load order: main file -> backup -> fresh default profile. Plain class, path injectable for tests.

const CURRENT_VERSION := 2
## from_version -> migration. A migration is a Callable (or method name on this class) taking the profile
## Dictionary and returning the profile upgraded to from_version + 1 (it need not set schema_version).
const MIGRATIONS := {1: "_migrate_1_to_2"}
const CHECKSUM_SALT := "lnw-save-v1"
const ERAS := 5

signal saved
signal loaded(source: String)   # "main", "backup" or "default"

var path: String
var backup_path: String
var tmp_path: String
var current_version: int = CURRENT_VERSION
var migrations: Dictionary = MIGRATIONS.duplicate()
var profile: Dictionary = {}
var load_source: String = ""

func _init(p_path := "user://save.json", p_migrations: Dictionary = {}, p_current_version := -1) -> void:
	path = p_path
	backup_path = p_path.get_basename() + ".bak." + p_path.get_extension()
	tmp_path = p_path + ".tmp"
	if not p_migrations.is_empty():
		migrations = p_migrations
	if p_current_version >= 0:
		current_version = p_current_version
	profile = default_profile()

func default_profile() -> Dictionary:
	var highest := {}
	for e in range(1, ERAS + 1):
		highest[str(e)] = 0
	return {
		"schema_version": current_version,
		"currencies": {"coins": 0, "gems": 0, "chrono_dust": 0, "capsules": 0},
		"progress": {
			"highest_stage_cleared": highest,   # era (string) -> highest stage index cleared (0..10)
			"stars": {},                        # "era-stage" -> 0..3
			"first_clear": {},                  # "era-stage" -> true
			"loss_streak": {},                  # "era-stage" -> consecutive losses
		},
		"units": {},                            # unit id -> level
		"upgrades": {"food_burrow": 1, "base": 1, "powers": {}},
		"loadout": {"equipped_powers": [], "squad_presets": [[], []], "active_preset": 0, "equipped_relics": []},
		"relics": {},                           # relic id -> level
		"pity": {"since_rare": 0, "since_epic": 0, "rng_state": 0},
		"settings": {"language": "en", "music": 0.7, "sfx": 1.0, "muted": false, "vibration": true, "text_size": 1.0},
		"consent": {"state": "unknown"},
		"pending_rewards": [],                  # [{id, placement, reward}] persisted before delivery
		"reward_seq": 0,
		"purchases_granted": [],                # tokens already granted
		"owned_products": [],                   # non-consumable product ids owned
		"timestamps": {"last_seen": 0, "daily_claim": 0, "daily_streak": 0, "offline_farm": 0},
		"quests": {"day": 0, "items": [], "all_claimed_day": 0},   # v2: daily quests {id, progress, claimed}
		"stats": {"battles_played": 0, "battles_won": 0, "units_spawned": 0, "powers_used": 0},   # v2
		"seen": {},                                                # v2: one-shot flags (popups, intros)
	}

# ---------------------------------------------------------------- saving

func save() -> bool:
	profile["schema_version"] = current_version
	var payload := JSON.stringify(profile)
	var envelope := JSON.stringify({"checksum": _checksum(payload), "payload": payload})
	var f := FileAccess.open(tmp_path, FileAccess.WRITE)
	if f == null:
		return false
	f.store_string(envelope)
	f.flush()
	f.close()
	# Rolling backup: only copy the current main file over the backup if it is itself valid.
	if FileAccess.file_exists(path) and not _read_file(path).is_empty():
		DirAccess.copy_absolute(path, backup_path)
	var err := DirAccess.rename_absolute(tmp_path, path)
	if err != OK:
		DirAccess.remove_absolute(path)
		err = DirAccess.rename_absolute(tmp_path, path)
	if err != OK:
		return false
	saved.emit()
	return true

# ---------------------------------------------------------------- loading

func load_profile() -> Dictionary:
	var data := _read_file(path)
	load_source = "main"
	if data.is_empty():
		data = _read_file(backup_path)
		load_source = "backup"
	if data.is_empty():
		profile = default_profile()
		load_source = "default"
		loaded.emit(load_source)
		return profile
	var before := int(data.get("schema_version", 1))
	var migrated := _migrate(data)
	profile = _merge_defaults(default_profile(), migrated)
	if int(migrated.get("schema_version", 1)) != before or load_source == "backup":
		save()
	loaded.emit(load_source)
	return profile

func delete_all() -> void:
	for p in [path, backup_path, tmp_path]:
		if FileAccess.file_exists(p):
			DirAccess.remove_absolute(p)
	profile = default_profile()

## Returns the parsed profile, or {} when the file is missing, unparsable or the checksum does not match.
func _read_file(p: String) -> Dictionary:
	if not FileAccess.file_exists(p):
		return {}
	var f := FileAccess.open(p, FileAccess.READ)
	if f == null:
		return {}
	var text := f.get_as_text()
	f.close()
	var env = _parse(text)
	if typeof(env) != TYPE_DICTIONARY or not env.has("payload") or not env.has("checksum"):
		return {}
	var payload = env["payload"]
	if typeof(payload) != TYPE_STRING or _checksum(payload) != env["checksum"]:
		return {}
	var data = _parse(payload)
	if typeof(data) != TYPE_DICTIONARY:
		return {}
	return _normalize(data)

## JSON.parse_string logs an engine error on bad input; a JSON instance fails quietly.
func _parse(text: String):
	var j := JSON.new()
	if j.parse(text) != OK:
		return null
	return j.data

func _checksum(payload: String) -> String:
	return (payload + CHECKSUM_SALT).sha256_text()

## v1 -> v2 (phase 2): daily quests, lifetime stats, one-shot flags, and two squad presets at launch (spec 4.3).
func _migrate_1_to_2(data: Dictionary) -> Dictionary:
	if not data.has("quests"):
		data["quests"] = {"day": 0, "items": [], "all_claimed_day": 0}
	if not data.has("stats"):
		data["stats"] = {"battles_played": 0, "battles_won": 0, "units_spawned": 0, "powers_used": 0}
	if not data.has("seen"):
		data["seen"] = {}
	var lo: Dictionary = data.get("loadout", {})
	var presets: Array = lo.get("squad_presets", [])
	while presets.size() < 2:
		presets.append([])
	lo["squad_presets"] = presets
	data["loadout"] = lo
	return data


func _migrate(data: Dictionary) -> Dictionary:
	var v := int(data.get("schema_version", 1))
	while v < current_version:
		if not migrations.has(v):
			break
		var m = migrations[v]
		var out = m.call(data) if m is Callable else call(m, data)
		if typeof(out) == TYPE_DICTIONARY:
			data = out
		v += 1
		data["schema_version"] = v
	return data

## JSON turns every number into float; restore integers.
func _normalize(v):
	match typeof(v):
		TYPE_DICTIONARY:
			var d := {}
			for k in v:
				d[k] = _normalize(v[k])
			return d
		TYPE_ARRAY:
			var a := []
			for x in v:
				a.append(_normalize(x))
			return a
		TYPE_FLOAT:
			if is_finite(v) and v == floorf(v) and absf(v) < 9.0e15:
				return int(v)
	return v

## Fills keys missing from `data` with defaults (recursively) and keeps the default's number type.
func _merge_defaults(defaults: Dictionary, data: Dictionary) -> Dictionary:
	var out := data.duplicate(true)
	for k in defaults:
		if not out.has(k):
			out[k] = defaults[k]
		elif typeof(defaults[k]) == TYPE_DICTIONARY and typeof(out[k]) == TYPE_DICTIONARY and not (defaults[k] as Dictionary).is_empty():
			out[k] = _merge_defaults(defaults[k], out[k])
		elif typeof(defaults[k]) == TYPE_FLOAT and typeof(out[k]) == TYPE_INT:
			out[k] = float(out[k])
	return out
