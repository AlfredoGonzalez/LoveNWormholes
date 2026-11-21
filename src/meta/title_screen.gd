class_name TitleScreen
extends Screen
## Title: logo placeholder, Play, language toggle, settings, version. The first Play shows the MOCK consent
## dialog (spec 8.7, UMP-style) once; the choice is stored in profile consent.state.

var play_button: Button
var lang_button: Button
var settings_button: Button
var consent_overlay: Control
var consent_accept: Button
var consent_options: Button
var _title: Label
var _subtitle: Label
var _tagline: Label
var _version: Label


func _ready() -> void:
	add_child(UI.background())
	var m := MarginContainer.new()
	m.set_anchors_preset(Control.PRESET_FULL_RECT)
	for side in ["left", "right", "top", "bottom"]:
		m.add_theme_constant_override("margin_" + side, 24)
	add_child(m)
	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", 14)
	m.add_child(v)

	var top := HBoxContainer.new()
	top.alignment = BoxContainer.ALIGNMENT_END
	lang_button = UI.button("", "ghost", Vector2(120, UI.MIN_TOUCH), 18)
	lang_button.name = "lang_button"
	lang_button.pressed.connect(toggle_language)
	top.add_child(lang_button)
	v.add_child(top)

	v.add_child(_spacer(true))
	var logo := UI.placeholder("LOGO", UI.GOLD, Vector2(0, 150))
	v.add_child(logo)
	_title = UI.label("", 46, UI.INK, HORIZONTAL_ALIGNMENT_CENTER)
	v.add_child(_title)
	_subtitle = UI.label("", 26, UI.TEAL, HORIZONTAL_ALIGNMENT_CENTER)
	v.add_child(_subtitle)
	_tagline = UI.label("", 16, UI.LOCKED_INK, HORIZONTAL_ALIGNMENT_CENTER)
	v.add_child(_tagline)
	v.add_child(_spacer(true))

	play_button = UI.button("", "primary", Vector2(0, 72), 32)
	play_button.name = "play_button"
	play_button.pressed.connect(_on_play)
	v.add_child(play_button)
	settings_button = UI.button("", "ghost", Vector2(0, UI.MIN_TOUCH), 20)
	settings_button.name = "settings_button"
	settings_button.pressed.connect(func(): Game.nav.go("settings"))
	v.add_child(settings_button)
	_version = UI.label("", 14, UI.LOCKED_INK, HORIZONTAL_ALIGNMENT_CENTER)
	v.add_child(_version)
	refresh_texts()


func _spacer(expand: bool) -> Control:
	var c := Control.new()
	c.size_flags_vertical = Control.SIZE_EXPAND_FILL
	c.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return c


func refresh_texts() -> void:
	_title.text = Game.t("app.title")
	_subtitle.text = Game.t("app.subtitle")
	_tagline.text = Game.t("title.tagline")
	play_button.text = Game.t("title.play")
	settings_button.text = Game.t("title.settings")
	var other := "es" if Localization.get_language() == "en" else "en"
	lang_button.text = Game.t("settings.lang_" + other)
	_version.text = Game.t("title.version", [str(ProjectSettings.get_setting("application/config/version", "0.1.0"))])
	if consent_overlay != null and is_instance_valid(consent_overlay):
		consent_overlay.queue_free()
		consent_overlay = null
		_show_consent()


func toggle_language() -> void:
	Game.set_language("es" if Localization.get_language() == "en" else "en")
	refresh_texts()


func consent_state() -> String:
	return str(Game.save.profile["consent"].get("state", "unknown"))


func _on_play() -> void:
	if consent_state() == "unknown":
		_show_consent()
	else:
		Game.nav.go("home")


func _show_consent() -> void:
	consent_overlay = Control.new()
	consent_overlay.name = "consent_overlay"
	consent_overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	var dim := ColorRect.new()
	dim.color = Color(0, 0, 0, 0.55)
	dim.set_anchors_preset(Control.PRESET_FULL_RECT)
	consent_overlay.add_child(dim)
	var center := CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	consent_overlay.add_child(center)
	var panel := UI.panel()
	panel.custom_minimum_size = Vector2(440, 0)
	center.add_child(panel)
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 12)
	panel.add_child(box)
	box.add_child(UI.label(Game.t("consent.title"), 26, UI.INK, HORIZONTAL_ALIGNMENT_CENTER))
	var body := UI.label(Game.t("consent.body"), 18)
	body.custom_minimum_size = Vector2(390, 0)
	box.add_child(body)
	consent_accept = UI.button(Game.t("consent.accept"), "primary", Vector2(0, 56), 22)
	consent_accept.name = "consent_accept"
	consent_accept.pressed.connect(func(): _finish_consent("granted"))
	box.add_child(consent_accept)
	consent_options = UI.button(Game.t("settings.privacy_options"), "ghost", Vector2(0, 52), 20)
	consent_options.name = "consent_options"
	consent_options.pressed.connect(func(): _finish_consent("limited"))
	box.add_child(consent_options)
	add_child(consent_overlay)


func _finish_consent(state: String) -> void:
	Game.save.profile["consent"]["state"] = state
	Game.save.save()
	if consent_overlay != null:
		consent_overlay.queue_free()
		consent_overlay = null
	Game.nav.go("home")
