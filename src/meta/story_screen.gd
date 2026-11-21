class_name StoryScreen
extends Screen
## Comic story panels (spec 3, 9.1 row 15): one panel at a time, a caption under it, Next / Continue, and Skip
## ALWAYS available. Art comes from the sprite manifest (panel "art" id); without it a colour + caption placeholder.
## params: {seq: "intro" | "era_2_open" | ... | "replay", next: "home", next_params: {}}
##   seq "replay" plays every sequence Story.replay_ids allows (Settings > View story) and flags nothing new.
## A sequence is flagged as seen when it is shown (never loops), through Story.mark_seen.

const ART_SIZE := Vector2(480, 470)

var panels: Array = []
var index := 0
var next_button: Button
var skip_button: Button
var progress_label: Label
var text_label: Label
var art_holder: Control
var _built := false


func _ready() -> void:
	ensure_built()


func ensure_built() -> void:
	if _built:
		return
	_built = true
	var seq := str(params.get("seq", "intro"))
	if seq == Story.REPLAY:
		for id in Story.replay_ids(Game.save.profile):
			panels.append_array(Story.panels(str(id)))
	else:
		panels = Story.panels(seq)
		Story.mark_seen(Game.save.profile, seq)
		Game.save.save()
	var v := MetaUI.scaffold(self, 16)
	v.add_theme_constant_override("separation", 12)
	var top := HBoxContainer.new()
	v.add_child(top)
	progress_label = UI.label("", 18, UI.LOCKED_INK)
	progress_label.autowrap_mode = TextServer.AUTOWRAP_OFF
	progress_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	progress_label.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	top.add_child(progress_label)
	skip_button = UI.button(Game.t("story.skip"), "ghost", Vector2(120, UI.MIN_TOUCH), 20)
	skip_button.name = "skip_button"
	skip_button.pressed.connect(skip)
	top.add_child(skip_button)
	var frame := UI.panel(UI.PANEL)
	frame.name = "frame"
	frame.size_flags_vertical = Control.SIZE_EXPAND_FILL
	v.add_child(frame)
	var inner := VBoxContainer.new()
	inner.add_theme_constant_override("separation", 10)
	frame.add_child(inner)
	art_holder = Control.new()
	art_holder.custom_minimum_size = ART_SIZE
	art_holder.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	art_holder.size_flags_vertical = Control.SIZE_EXPAND_FILL
	art_holder.clip_contents = true
	art_holder.mouse_filter = Control.MOUSE_FILTER_PASS
	art_holder.gui_input.connect(_on_art_input)
	inner.add_child(art_holder)
	var cap := UI.panel(Color("FFFDF5"))
	cap.custom_minimum_size = Vector2(0, 150)
	inner.add_child(cap)
	text_label = UI.label("", 22)
	text_label.name = "caption"
	text_label.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	cap.add_child(text_label)
	next_button = UI.button("", "primary", Vector2(0, 64), 26)
	next_button.name = "next_button"
	next_button.pressed.connect(next_panel)
	v.add_child(next_button)
	if panels.is_empty():
		call_deferred("finish")   # nothing to show: never trap the player here
		return
	_show_panel()


func _on_art_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and (event as InputEventMouseButton).pressed \
			and (event as InputEventMouseButton).button_index == MOUSE_BUTTON_LEFT:
		next_panel()


func _show_panel() -> void:
	var p: Dictionary = panels[index]
	for c in art_holder.get_children():
		art_holder.remove_child(c)
		c.queue_free()
	var tex: Texture2D = SpriteFactory._load_texture(SpriteManifest.get_entry(str(p.get("art", ""))))
	if tex != null:
		var tr := TextureRect.new()
		tr.texture = tex
		tr.set_anchors_preset(Control.PRESET_FULL_RECT)
		tr.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		tr.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
		tr.mouse_filter = Control.MOUSE_FILTER_IGNORE
		art_holder.add_child(tr)
	else:
		var col := Color.from_string(str(p.get("color", "#F2B632")), UI.GOLD)
		var ph := UI.placeholder(str(p.get("caption", "")), col, ART_SIZE)
		ph.set_anchors_preset(Control.PRESET_FULL_RECT)
		ph.mouse_filter = Control.MOUSE_FILTER_IGNORE
		art_holder.add_child(ph)
		for c in ph.get_children():
			if c is Label:
				(c as Label).add_theme_font_size_override("font_size", 24)
	text_label.text = Game.t(str(p.get("text_key", "")))
	progress_label.text = Game.t("story.progress", [index + 1, panels.size()])
	next_button.text = Game.t("story.continue") if is_last() else Game.t("story.next")


func is_last() -> bool:
	return index >= panels.size() - 1


func next_panel() -> void:
	if panels.is_empty():
		return
	if is_last():
		finish()
		return
	index += 1
	_show_panel()


func skip() -> void:
	finish()


var _left := false

func finish() -> void:
	if _left:
		return
	_left = true
	Game.nav.go(str(params.get("next", "home")), params.get("next_params", {}))
