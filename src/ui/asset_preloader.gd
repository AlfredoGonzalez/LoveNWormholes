class_name AssetPreloader
extends RefCounted
## Threaded preload of every texture the sprite manifest lists (animation sheets, statics, images, refs).
## Started once at boot (so the studio video time already counts); the title screen shows `progress()` and swaps
## the bar for the Play button when `is_done()`. With no manifest or no files it is done immediately.

static var _paths: Array = []
static var _started := false


static var _next := 0


static func start() -> void:
	if _started:
		return
	_started = true
	_next = 0
	_paths = _collect_paths()


static func reset() -> void:
	_paths = []
	_started = false
	_next = 0


## Loads textures one by one until `budget_ms` is spent, so a frame is never blocked for long (web has no threads:
## a threaded request there would freeze the whole screen and the progress bar could not move).
static func pump(budget_ms: float = 8.0) -> void:
	if not _started:
		return
	var t0 := Time.get_ticks_msec()
	while _next < _paths.size():
		ResourceLoader.load(str(_paths[_next]))   # cached by ResourceLoader; later `load()` calls are instant
		_next += 1
		if float(Time.get_ticks_msec() - t0) >= budget_ms:
			break


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
	return float(_next) / float(_paths.size())


static func is_done() -> bool:
	return progress() >= 1.0
