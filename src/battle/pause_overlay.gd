class_name PauseOverlay
extends Control
## Pause menu (docs/mockup/Pause.dc.html): dimmed screen, panel with Resume, Restart, Quit, and music /
## sound toggles. The battle screen owns the clock; this only reports what the player chose.

signal resume_requested
signal restart_requested
signal quit_requested

var music_button: Button
var sound_button: Button
var quit_button: Button
var _main: Control
var _confirm: Control


func _init() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_STOP
	name = "PauseOverlay"


func _ready() -> void:
	var dim := ColorRect.new()
	dim.color = Color(0.08, 0.05, 0.02, 0.62)
	dim.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(dim)
	var center := CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(center)
	var panel := UI.panel()
	panel.custom_minimum_size = Vector2(380, 0)
	center.add_child(panel)
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 12)
	panel.add_child(box)
	_main = box
	box.add_child(UI.label(Game.t("pause.title"), 34, UI.INK, HORIZONTAL_ALIGNMENT_CENTER))
	var resume := UI.button(Game.t("pause.resume"), "primary", Vector2(0, 60), 26)
	resume.pressed.connect(func(): resume_requested.emit())
	box.add_child(resume)
	var restart := UI.button(Game.t("pause.restart"), "teal", Vector2(0, 54))
	restart.pressed.connect(func(): restart_requested.emit())
	box.add_child(restart)
	quit_button = UI.button(Game.t("pause.quit"), "ghost", Vector2(0, 54))
	quit_button.pressed.connect(_ask_quit)
	box.add_child(quit_button)
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 10)
	box.add_child(row)
	music_button = UI.button("", "ghost", Vector2(0, UI.MIN_TOUCH), 18)
	music_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	music_button.pressed.connect(_toggle_music)
	row.add_child(music_button)
	sound_button = UI.button("", "ghost", Vector2(0, UI.MIN_TOUCH), 18)
	sound_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	sound_button.pressed.connect(_toggle_sound)
	row.add_child(sound_button)
	_refresh_toggles()
	# Confirmation for leaving (leaving counts as a loss).
	_confirm = UI.panel()
	_confirm.visible = false
	_confirm.custom_minimum_size = Vector2(380, 0)
	center.add_child(_confirm)
	var cbox := VBoxContainer.new()
	cbox.add_theme_constant_override("separation", 12)
	_confirm.add_child(cbox)
	cbox.add_child(UI.label(Game.t("pause.quit_confirm"), 22, UI.INK, HORIZONTAL_ALIGNMENT_CENTER))
	var stay := UI.button(Game.t("pause.stay"), "primary", Vector2(0, 54))
	stay.pressed.connect(_cancel_quit)
	cbox.add_child(stay)
	var leave := UI.button(Game.t("pause.leave"), "ghost", Vector2(0, 54))
	leave.pressed.connect(func(): quit_requested.emit())
	cbox.add_child(leave)


func _ask_quit() -> void:
	_main.get_parent().visible = false
	_confirm.visible = true


func _cancel_quit() -> void:
	_main.get_parent().visible = true
	_confirm.visible = false


func is_confirming() -> bool:
	return _confirm != null and _confirm.visible


func music_on() -> bool:
	return float(_settings().get("music", 0.7)) > 0.0


func sound_on() -> bool:
	return float(_settings().get("sfx", 1.0)) > 0.0


func _settings() -> Dictionary:
	return Game.save.profile["settings"]


func _toggle_music() -> void:
	var s := _settings()
	var on := not music_on()
	s["music"] = float(Game.save.default_profile()["settings"]["music"]) if on else 0.0
	Game.audio.apply_settings(s)
	Game.save.save()
	_refresh_toggles()


func _toggle_sound() -> void:
	var s := _settings()
	var on := not sound_on()
	s["sfx"] = float(Game.save.default_profile()["settings"]["sfx"]) if on else 0.0
	Game.audio.apply_settings(s)
	Game.save.save()
	_refresh_toggles()


func _refresh_toggles() -> void:
	music_button.text = Game.t("pause.music_on" if music_on() else "pause.music_off")
	sound_button.text = Game.t("pause.sound_on" if sound_on() else "pause.sound_off")
