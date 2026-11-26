class_name LoadingScreen
extends Control
## Loading screen shown right after the studio video: game name (or the logo art when it exists) and a progress
## bar while every texture listed in the sprite manifest is preloaded (threaded). Stays at least MIN_SECONDS so it
## never flashes. Emits `finished` once. Works without a manifest (nothing to load, just the minimum time).

signal finished

const MIN_SECONDS := 1.4

var bar: ProgressBar
var _paths: Array = []
var _requested := 0
var _elapsed := 0.0
var _done := false


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(UI.background())
	var box := VBoxContainer.new()
	box.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	box.alignment = BoxContainer.ALIGNMENT_CENTER
	box.add_theme_constant_override("separation", 18)
	add_child(box)
	var logo_tex: Texture2D = SpriteFactory.texture_of("logo")
	if logo_tex != null:
		var tr := TextureRect.new()
		tr.texture = logo_tex
		tr.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		tr.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		tr.custom_minimum_size = Vector2(0, 260)
		box.add_child(tr)
	else:
		var title := UI.label("Love 'n Wormholes", 44, UI.INK, HORIZONTAL_ALIGNMENT_CENTER)
		box.add_child(title)
		box.add_child(UI.label("Lost in Time", 26, UI.TEAL, HORIZONTAL_ALIGNMENT_CENTER))
	bar = ProgressBar.new()
	bar.custom_minimum_size = Vector2(300, 18)
	bar.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	bar.show_percentage = false
	bar.max_value = 1.0
	box.add_child(bar)
	box.add_child(UI.label(Game.t("loading.text") if Localization.has_key("loading.text") else "Loading...", 20, UI.INK, HORIZONTAL_ALIGNMENT_CENTER))
	_paths = _collect_paths()
	for p in _paths:
		if ResourceLoader.load_threaded_request(p) == OK:
			_requested += 1


## Every texture path the manifest lists (animation sheets, statics, images, refs) that exists as a resource.
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


func progress() -> float:
	if _requested == 0:
		return 1.0
	var done := 0
	for p in _paths:
		var st := ResourceLoader.load_threaded_get_status(p)
		if st == ResourceLoader.THREAD_LOAD_LOADED or st == ResourceLoader.THREAD_LOAD_FAILED \
				or st == ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
			done += 1
	return float(done) / float(_paths.size())


func _process(delta: float) -> void:
	_elapsed += delta
	var p := progress()
	bar.value = minf(p, _elapsed / MIN_SECONDS)
	if p >= 1.0 and _elapsed >= MIN_SECONDS and not _done:
		_done = true
		finished.emit()
