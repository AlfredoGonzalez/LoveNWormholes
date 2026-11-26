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
var _art := false              # real title art present (bg_home + logo): art layout, otherwise the code-drawn one
var _sign: TextureRect


func _ready() -> void:
	_art = SpriteFactory.texture_of("bg_home") != null and SpriteFactory.texture_of("logo") != null
	if _art:
		var bg := TextureRect.new()
		bg.texture = SpriteFactory.texture_of("bg_home")
		bg.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		bg.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
		bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
		add_child(bg)
	else:
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

	_title = UI.label("", 46, UI.INK, HORIZONTAL_ALIGNMENT_CENTER)
	_subtitle = UI.label("", 26, UI.TEAL, HORIZONTAL_ALIGNMENT_CENTER)
	_tagline = UI.label("", 16, UI.LOCKED_INK, HORIZONTAL_ALIGNMENT_CENTER)
	if _art:
		# The logo already carries the name and "Lost in Time": no texts, just the art.
		var logo_rect := TextureRect.new()
		logo_rect.name = "logo"
		logo_rect.texture = SpriteFactory.texture_of("logo")
		logo_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		logo_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		logo_rect.custom_minimum_size = Vector2(0, 330)
		logo_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
		v.add_child(logo_rect)
		v.add_child(_spacer(true))
		for hidden_label in [_title, _subtitle, _tagline]:   # kept in the tree (texts refresh) but not shown
			hidden_label.visible = false
			v.add_child(hidden_label)
	else:
		v.add_child(_spacer(true))
		v.add_child(UI.placeholder("LOGO", UI.GOLD, Vector2(0, 150)))
		v.add_child(_title)
		v.add_child(_subtitle)
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
	if _art and (SpriteFactory.texture_of("play_en") != null or SpriteFactory.texture_of("play_es") != null):
		# The wooden sign is the button: flat button whose content is the sign art (ES or EN by language).
		play_button.flat = true
		play_button.custom_minimum_size = Vector2(0, 190)
		for st in ["normal", "hover", "pressed", "focus", "disabled"]:
			play_button.add_theme_stylebox_override(st, StyleBoxEmpty.new())
		_sign = TextureRect.new()
		_sign.name = "sign"
		_sign.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		_sign.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		_sign.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		_sign.mouse_filter = Control.MOUSE_FILTER_IGNORE
		play_button.add_child(_sign)
	_set_loading(not AssetPreloader.is_done())
	settings_button = UI.button("", "ghost", Vector2(0, UI.MIN_TOUCH), 20)
	settings_button.name = "settings_button"
	settings_button.pressed.connect(func(): Game.nav.go("settings"))
	if _art:
		# Art layout: settings top-left, language top-right, nothing heavy over the bottom of the picture.
		settings_button.custom_minimum_size = Vector2(120, UI.MIN_TOUCH)
		settings_button.add_theme_font_size_override("font_size", 18)
		var gap := _spacer(true)
		gap.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		top.add_child(gap)
		top.add_child(settings_button)
		top.move_child(settings_button, 0)
		top.move_child(gap, 1)
	else:
		v.add_child(settings_button)
	_version = UI.label("", 14, UI.LOCKED_INK, HORIZONTAL_ALIGNMENT_CENTER)
	if _art:
		_version.add_theme_font_size_override("font_size", 12)
		_version.add_theme_color_override("font_color", UI.PANEL)
		_version.add_theme_color_override("font_outline_color", UI.INK)
		_version.add_theme_constant_override("outline_size", 4)
	v.add_child(_version)
	refresh_texts()


func _set_loading(loading: bool) -> void:
	progress_bar.visible = loading
	_loading_label.visible = loading
	play_button.visible = not loading
	set_process(loading)
	if not loading and _sign != null and is_inside_tree():
		play_button.pivot_offset = play_button.size * 0.5
		play_button.scale = Vector2(0.85, 0.85)
		create_tween().tween_property(play_button, "scale", Vector2.ONE, 0.25).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)


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
	play_button.text = "" if _sign != null else Game.t("title.play")
	if _sign != null:
		var lang := Localization.get_language()
		var tex := SpriteFactory.texture_of("play_" + lang)
		_sign.texture = tex if tex != null else (SpriteFactory.texture_of("play_en") if SpriteFactory.texture_of("play_en") != null else SpriteFactory.texture_of("play_es"))
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
