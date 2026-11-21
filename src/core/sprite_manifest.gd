class_name SpriteManifest
extends RefCounted
## Loads assets/manifest.json (written by tools/process_sprites.py).
## Tolerates the file being missing, empty or malformed: lookups then return {}.

const DEFAULT_PATH := "res://assets/manifest.json"

static var _path := DEFAULT_PATH
static var _sprites: Dictionary = {}
static var _loaded := false

## Point at another manifest file (tests) and drop the cache.
static func use_path(path: String) -> void:
	_path = path
	_loaded = false
	_sprites = {}

static func reset() -> void:
	use_path(DEFAULT_PATH)

## Inject entries directly (tests / tools). Replaces whatever was loaded.
static func set_entries(entries: Dictionary) -> void:
	_sprites = entries.duplicate(true)
	_loaded = true

static func _ensure_loaded() -> void:
	if _loaded:
		return
	_loaded = true
	_sprites = {}
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

static func ids() -> Array:
	_ensure_loaded()
	return _sprites.keys()

## Entry paths are "assets/..." relative to the project; res:// and user:// pass through.
static func resolve_path(path: String) -> String:
	if path.begins_with("res://") or path.begins_with("user://") or path.begins_with("/"):
		return path
	return "res://" + path
