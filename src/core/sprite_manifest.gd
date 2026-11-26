class_name SpriteManifest
extends RefCounted
## Loads assets/manifest.json (written by tools/process_sprites.py).
## Tolerates the file being missing, empty or malformed: lookups then return {}.

const DEFAULT_PATH := "res://assets/manifest.json"

static var _path := DEFAULT_PATH
static var _sprites: Dictionary = {}
static var _loaded := false
static var _refs: Dictionary = {}
## Bumped whenever the manifest is (re)pointed or injected: texture caches key off it.
static var generation := 0

## Point at another manifest file (tests) and drop the cache.
static func use_path(path: String) -> void:
	_path = path
	_loaded = false
	_sprites = {}
	_refs = {}
	generation += 1

static func reset() -> void:
	use_path(DEFAULT_PATH)

## Inject entries directly (tests / tools). Replaces whatever was loaded.
static func set_entries(entries: Dictionary) -> void:
	_sprites = entries.duplicate(true)
	_refs = {}
	_loaded = true
	generation += 1

static func _ensure_loaded() -> void:
	if _loaded:
		return
	_loaded = true
	_sprites = {}
	_refs = {}
	if not FileAccess.file_exists(_path):
		return
	var text := FileAccess.get_file_as_string(_path)
	if text.strip_edges() == "":
		return
	var json := JSON.new()
	if json.parse(text) != OK:  # malformed: stay empty (JSON.new().parse does not log an error)
		return
	var parsed: Variant = json.data
	if typeof(parsed) != TYPE_DICTIONARY:
		return
	var refs: Variant = (parsed as Dictionary).get("refs", {})
	if typeof(refs) == TYPE_DICTIONARY:
		_refs = refs
	var sprites: Variant = (parsed as Dictionary).get("sprites", {})
	if typeof(sprites) == TYPE_DICTIONARY:
		_sprites = sprites

static func has_entry(id: String) -> bool:
	_ensure_loaded()
	return _sprites.has(id)

## Returns the manifest entry for id, or {} when unknown.
static func get_entry(id: String) -> Dictionary:
	_ensure_loaded()
	var e: Variant = _sprites.get(id, {})
	return e if typeof(e) == TYPE_DICTIONARY else {}

## Path of the reference image of a character ("" when none), from the manifest "refs" map.
static func ref_path(id: String) -> String:
	_ensure_loaded()
	return str(_refs.get(id, ""))

static func ids() -> Array:
	_ensure_loaded()
	return _sprites.keys()

## True when the entry uses the per-animation format (one 5x5 sheet per animation).
static func is_anim_format(entry: Dictionary) -> bool:
	return typeof(entry.get("anims", null)) == TYPE_DICTIONARY

## Animation names present in the entry's art (per-animation format; legacy: its rows).
static func anim_names(id: String) -> Array:
	var e := get_entry(id)
	if is_anim_format(e):
		return (e["anims"] as Dictionary).keys()
	var rows: Variant = e.get("rows", [])
	return rows if typeof(rows) == TYPE_ARRAY else []

## Animation names the character is expected to have but whose art is not (yet) there.
static func missing_anims(id: String) -> Array:
	var e := get_entry(id)
	var out := []
	var expected: Variant = e.get("expected_anims", [])
	if typeof(expected) != TYPE_ARRAY:
		return out
	var have := anim_names(id)
	for a in expected:
		if not (a in have):
			out.append(a)
	return out

static func has_anim(id: String, anim: String) -> bool:
	return anim in anim_names(id)

## Per-animation info (path, frame_w, frame_h, anchor, frames, fps, loop, ...) or {}.
static func get_anim(id: String, anim: String) -> Dictionary:
	var e := get_entry(id)
	if not is_anim_format(e):
		return {}
	var a: Variant = (e["anims"] as Dictionary).get(anim, {})
	return a if typeof(a) == TYPE_DICTIONARY else {}

## Entry paths are "assets/..." relative to the project; res:// and user:// pass through.
static func resolve_path(path: String) -> String:
	if path.begins_with("res://") or path.begins_with("user://") or path.begins_with("/"):
		return path
	return "res://" + path
