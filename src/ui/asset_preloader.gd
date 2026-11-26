class_name AssetPreloader
extends RefCounted
## Threaded preload of every texture the sprite manifest lists (animation sheets, statics, images, refs).
## Started once at boot (so the studio video time already counts); the title screen shows `progress()` and swaps
## the bar for the Play button when `is_done()`. With no manifest or no files it is done immediately.

static var _paths: Array = []
static var _started := false


static func start() -> void:
	if _started:
		return
	_started = true
	_paths = _collect_paths()
	var ok: Array = []
	for p in _paths:
		if ResourceLoader.load_threaded_request(p) == OK:
			ok.append(p)
	_paths = ok


static func reset() -> void:
	_paths = []
	_started = false


## Every texture path the manifest lists that exists as a resource.
static func _collect_paths() -> Array:
	var out := {}
	for id in SpriteManifest.ids():
		var e: Dictionary = SpriteManifest.get_entry(id)
		var candidates: Array = []
		if e.has("path"):
			candidates.append(str(e["path"]))
		var anims: Variant = e.get("anims", {})
		if anims is Dictionary:
			for a in (anims as Dictionary).values():
				if a is Dictionary and (a as Dictionary).has("path"):
					candidates.append(str((a as Dictionary)["path"]))
		for c in candidates:
			var res_path := SpriteManifest.resolve_path(c)
			if ResourceLoader.exists(res_path):
				out[res_path] = true
	return out.keys()


static func progress() -> float:
	if not _started or _paths.is_empty():
		return 1.0
	var done := 0
	for p in _paths:
		var st := ResourceLoader.load_threaded_get_status(p)
		if st != ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			done += 1
	return float(done) / float(_paths.size())


static func is_done() -> bool:
	return progress() >= 1.0
