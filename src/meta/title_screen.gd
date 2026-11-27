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

# ---- Art layout "v2" (background + logo + loader/progress + wooden language switch + Play sign). All sizes are
# fractions of the screen width/height so it adapts to any phone; tune them here.
const ART2_IDS := ["background", "logo", "jugar_en", "jugar_es", "language", "slider", "loader", "progress"]
const LOGO_W := 0.60            # logo width / screen width
const LOGO_TOP := 0.10          # logo top / screen height
const LANG_W := 0.28            # language switch width / screen width
const LANG_TOP := 0.025
const LANG_RIGHT := 0.03
const FLAG_X_ES := 0.36         # flag centres inside language.png (fraction of its size)
const FLAG_X_EN := 0.66
const FLAG_Y := 0.54
const CORK_D := 0.285           # cork (slider) diameter / language width
const LOADER_W := 0.66          # loader width / screen width
const BAR_Y := 0.80             # loader / sign centre / screen height
const FILL_X := 0.066           # progress fill inside the loader (fractions of the loader size)
const FILL_W := 0.868
const SIGN_W := 0.52            # Play sign width / screen width

var _art2 := false
var _bg_rect: TextureRect
var _logo_rect: TextureRect
var _lang_root: Control
var _cork: TextureRect
var _loader_root: Control
var _fill_clip: Control
var _fill_rect: TextureRect
var _shown := 0.0               # displayed progress (eases toward the real one)
var _leaving := false


func _ready() -> void:
	_art2 = true
	for id in ART2_IDS:
		if SpriteFactory.texture_of(id) == null:
			_art2 = false
	if _art2:
		_build_art2()
		return
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
	if _art2:
		return
	progress_bar.visible = loading
	_loading_label.visible = loading
	play_button.visible = not loading
	set_process(loading)
	if not loading and _sign != null and is_inside_tree():
		play_button.pivot_offset = play_button.size * 0.5
		play_button.scale = Vector2(0.85, 0.85)
		create_tween().tween_property(play_button, "scale", Vector2.ONE, 0.25).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)


func _process(delta: float) -> void:
	AssetPreloader.pump(8.0)
	var p := AssetPreloader.progress()
	if _art2:
		_shown = move_toward(_shown, p, delta * 0.9)    # the fill eases forward, never jumps
		_update_fill()
		if _shown >= 1.0:
			_finish_loading()
		return
	progress_bar.value = p
	if p >= 1.0:
		_set_loading(false)


func _spacer(expand: bool) -> Control:
	var c := Control.new()
	c.size_flags_vertical = Control.SIZE_EXPAND_FILL
	c.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return c


func refresh_texts() -> void:
	if _art2:
		_sign.texture = SpriteFactory.texture_of("jugar_" + Localization.get_language())
		_version.text = Game.t("title.version", [str(ProjectSettings.get_setting("application/config/version", "0.1.0"))])
		_title.text = Game.t("app.title")
		settings_button.text = Game.t("title.settings")
		lang_button.text = ""
		return
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
	if _art2:
		_move_cork(true)
		_pop_sign()


func consent_state() -> String:
	return Game.consent.state()


func _on_play() -> void:
	if _art2 and not _leaving and is_inside_tree() and DisplayServer.get_name() != "headless":
		_leaving = true
		_play_start_animation(_go)
		return
	_go()


func _go() -> void:
	var dest := Story.route(Game.save.profile, "intro", "home")   # the intro comic plays once, after consent
	if Game.consent.needs_prompt():
		Game.nav.go("consent", {"next": dest[0], "next_params": dest[1]})
	else:
		Game.nav.go(dest[0], dest[1])


# ================= Art layout v2 =================

func _tex_rect(id: String, name_: String) -> TextureRect:
	var r := TextureRect.new()
	r.name = name_
	r.texture = SpriteFactory.texture_of(id)
	r.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	r.stretch_mode = TextureRect.STRETCH_SCALE
	r.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return r


func _build_art2() -> void:
	_bg_rect = _tex_rect("background", "background")
	_bg_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	add_child(_bg_rect)
	_logo_rect = _tex_rect("logo", "logo")
	add_child(_logo_rect)

	# Language switch: the pill (ES flag | EN flag) and a wooden cork that covers the flag NOT selected.
	_lang_root = Control.new()
	_lang_root.name = "language_switch"
	_lang_root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_lang_root)
	_lang_root.add_child(_tex_rect("language", "language"))
	_cork = _tex_rect("slider", "cork")
	_lang_root.add_child(_cork)
	lang_button = Button.new()
	lang_button.name = "lang_button"
	lang_button.flat = true
	for st in ["normal", "hover", "pressed", "focus", "disabled"]:
		lang_button.add_theme_stylebox_override(st, StyleBoxEmpty.new())
	lang_button.pressed.connect(func():
		UI._tap_sound()
		toggle_language())
	add_child(lang_button)   # transparent touch area (>= 48 px) over the switch

	# Loader: empty frame + green fill revealed left to right (a clipped copy of progress.png).
	_loader_root = Control.new()
	_loader_root.name = "loader"
	_loader_root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_loader_root)
	_loader_root.add_child(_tex_rect("loader", "frame"))
	_fill_clip = Control.new()
	_fill_clip.name = "fill_clip"
	_fill_clip.clip_contents = true
	_fill_clip.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_loader_root.add_child(_fill_clip)
	_fill_rect = _tex_rect("progress", "fill")
	_fill_clip.add_child(_fill_rect)

	# Play sign: it is the button.
	play_button = Button.new()
	play_button.name = "play_button"
	play_button.flat = true
	play_button.custom_minimum_size = Vector2(0, UI.MIN_TOUCH)
	for st in ["normal", "hover", "pressed", "focus", "disabled"]:
		play_button.add_theme_stylebox_override(st, StyleBoxEmpty.new())
	play_button.pressed.connect(_on_play)
	add_child(play_button)
	_sign = _tex_rect("jugar_en", "sign")
	_sign.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	play_button.add_child(_sign)

	# Kept in the tree but hidden: texts for refresh_texts and the settings route (Home has the gear).
	_title = UI.label("", 20)
	_subtitle = UI.label("", 20)
	_tagline = UI.label("", 20)
	_loading_label = UI.label("", 20)
	settings_button = UI.button("", "ghost")
	settings_button.name = "settings_button"
	settings_button.pressed.connect(func(): Game.nav.go("settings"))
	for hidden in [_title, _subtitle, _tagline, _loading_label, settings_button]:
		hidden.visible = false
		add_child(hidden)
	_version = UI.label("", 12, UI.PANEL, HORIZONTAL_ALIGNMENT_CENTER)
	_version.add_theme_color_override("font_outline_color", UI.INK)
	_version.add_theme_constant_override("outline_size", 4)
	add_child(_version)

	resized.connect(_layout_art2)
	refresh_texts()
	_layout_art2()
	_move_cork(false)
	if AssetPreloader.is_done():
		_shown = 1.0
		_loader_root.visible = false
		play_button.visible = true
		set_process(false)
	else:
		play_button.visible = false
		_update_fill()


func _aspect(id: String) -> float:
	var t := SpriteFactory.texture_of(id)
	return float(t.get_height()) / float(maxi(t.get_width(), 1)) if t != null else 1.0


func _layout_art2() -> void:
	var w := size.x
	var h := size.y
	_bg_rect.position = Vector2.ZERO
	_bg_rect.size = size
	var lw := w * LOGO_W
	_logo_rect.size = Vector2(lw, lw * _aspect("logo"))
	_logo_rect.position = Vector2((w - lw) * 0.5, h * LOGO_TOP)
	_logo_rect.pivot_offset = _logo_rect.size * 0.5
	var gw := w * LANG_W
	_lang_root.size = Vector2(gw, gw * _aspect("language"))
	_lang_root.position = Vector2(w - gw - w * LANG_RIGHT, h * LANG_TOP)
	for c in _lang_root.get_children():
		if c != _cork:
			(c as Control).size = _lang_root.size
	_cork.size = Vector2.ONE * gw * CORK_D
	_cork.pivot_offset = _cork.size * 0.5
	lang_button.size = Vector2(maxf(_lang_root.size.x, 96.0), maxf(_lang_root.size.y, 56.0))
	lang_button.position = _lang_root.position + (_lang_root.size - lang_button.size) * 0.5
	var ldw := w * LOADER_W
	_loader_root.size = Vector2(ldw, ldw * _aspect("loader"))
	_loader_root.position = Vector2((w - ldw) * 0.5, h * BAR_Y - _loader_root.size.y * 0.5)
	for c in _loader_root.get_children():
		if c.name == "frame":
			(c as Control).size = _loader_root.size
	var fw := ldw * FILL_W
	var fh := fw * _aspect("progress")
	_fill_clip.position = Vector2(ldw * FILL_X, (_loader_root.size.y - fh) * 0.5)
	_fill_clip.size = Vector2(fw * _shown, fh)
	_fill_rect.size = Vector2(fw, fh)
	var sw := w * SIGN_W
	play_button.size = Vector2(sw, sw * _aspect("jugar_en"))
	play_button.position = Vector2((w - sw) * 0.5, h * BAR_Y - play_button.size.y * 0.5)
	play_button.pivot_offset = play_button.size * 0.5
	_version.size = Vector2(w, 20)
	_version.position = Vector2(0, h - 26)
	_move_cork(false)


func _update_fill() -> void:
	if _fill_rect == null:
		return
	_fill_clip.size.x = _fill_rect.size.x * clampf(_shown, 0.0, 1.0)


## Cork over the flag that is NOT selected (ES selected -> it covers EN), rolling when animated.
func _move_cork(animated: bool) -> void:
	if _cork == null:
		return
	var es := Localization.get_language() == "es"
	var cx := _lang_root.size.x * (FLAG_X_EN if es else FLAG_X_ES)
	var target := Vector2(cx - _cork.size.x * 0.5, _lang_root.size.y * FLAG_Y - _cork.size.y * 0.5)
	if not animated or not is_inside_tree():
		_cork.position = target
		return
	var dir := 1.0 if es else -1.0
	var tw := create_tween().set_parallel(true)
	tw.tween_property(_cork, "position", target, 0.30).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tw.tween_property(_cork, "rotation_degrees", _cork.rotation_degrees + 220.0 * dir, 0.30).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)


func _pop_sign() -> void:
	if not play_button.visible or not is_inside_tree():
		return
	play_button.scale = Vector2(0.88, 0.88)
	create_tween().tween_property(play_button, "scale", Vector2.ONE, 0.25).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)


## Loader fades out, then the Play sign pops in.
func _finish_loading() -> void:
	set_process(false)
	if not is_inside_tree() or DisplayServer.get_name() == "headless":
		_loader_root.visible = false
		play_button.visible = true
		return
	var tw := create_tween()
	tw.tween_property(_loader_root, "modulate:a", 0.0, 0.30)
	tw.tween_callback(func():
		_loader_root.visible = false
		play_button.visible = true
		play_button.modulate.a = 0.0
		play_button.scale = Vector2(0.7, 0.7))
	tw.tween_property(play_button, "modulate:a", 1.0, 0.18)
	tw.parallel().tween_property(play_button, "scale", Vector2.ONE, 0.35).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)


## Play tap: the sign squashes, then grows and fades while the scene brightens, and only then the next screen opens.
func _play_start_animation(done: Callable) -> void:
	if Game.audio != null:
		Game.audio.play_sfx("ui_tap")
	play_button.disabled = true
	lang_button.disabled = true
	var tw := create_tween()
	tw.tween_property(play_button, "scale", Vector2(0.88, 0.82), 0.09).set_ease(Tween.EASE_OUT)
	tw.tween_property(play_button, "scale", Vector2(1.5, 1.5), 0.28).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tw.parallel().tween_property(play_button, "modulate:a", 0.0, 0.28).set_delay(0.06)
	tw.parallel().tween_property(_logo_rect, "scale", Vector2(1.08, 1.08), 0.28)
	tw.parallel().tween_property(self, "modulate", Color(1.4, 1.35, 1.2, 1.0), 0.28)
	tw.tween_callback(done)
