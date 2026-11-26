class_name TitleScreen
extends Screen
## Title: logo placeholder, Play, language toggle, settings, version. Consent is asked by ConsentScreen right
## after the intro (Main); if it is somehow still unknown at Play, Play routes there before Home.

var play_button: Button
var progress_bar: ProgressBar
var _loading_label: Label
var lang_button: Button
var settings_button: Button
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

	# One screen for loading and title: the bar fills while the art preloads, then Play takes its place.
	progress_bar = UI.progress_bar(Vector2(0, 26))
	progress_bar.name = "progress_bar"
	v.add_child(progress_bar)
	_loading_label = UI.label("", 18, UI.INK, HORIZONTAL_ALIGNMENT_CENTER)
	v.add_child(_loading_label)
	play_button = UI.button("", "primary", Vector2(0, 72), 32)
	play_button.name = "play_button"
	play_button.pressed.connect(_on_play)
	v.add_child(play_button)
	_set_loading(not AssetPreloader.is_done())
	settings_button = UI.button("", "ghost", Vector2(0, UI.MIN_TOUCH), 20)
	settings_button.name = "settings_button"
	settings_button.pressed.connect(func(): Game.nav.go("settings"))
	v.add_child(settings_button)
	_version = UI.label("", 14, UI.LOCKED_INK, HORIZONTAL_ALIGNMENT_CENTER)
	v.add_child(_version)
	refresh_texts()


func _set_loading(loading: bool) -> void:
	progress_bar.visible = loading
	_loading_label.visible = loading
	play_button.visible = not loading
	set_process(loading)


func _process(_delta: float) -> void:
	AssetPreloader.pump(8.0)
	var p := AssetPreloader.progress()
	progress_bar.value = p
	if p >= 1.0:
		_set_loading(false)


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
	_loading_label.text = Game.t("title.loading")
	settings_button.text = Game.t("title.settings")
	var other := "es" if Localization.get_language() == "en" else "en"
	lang_button.text = Game.t("settings.lang_" + other)
	_version.text = Game.t("title.version", [str(ProjectSettings.get_setting("application/config/version", "0.1.0"))])


func toggle_language() -> void:
	Game.set_language("es" if Localization.get_language() == "en" else "en")
	refresh_texts()


func consent_state() -> String:
	return Game.consent.state()


func _on_play() -> void:
	var dest := Story.route(Game.save.profile, "intro", "home")   # the intro comic plays once, after consent
	if Game.consent.needs_prompt():
		Game.nav.go("consent", {"next": dest[0], "next_params": dest[1]})
	else:
		Game.nav.go(dest[0], dest[1])
