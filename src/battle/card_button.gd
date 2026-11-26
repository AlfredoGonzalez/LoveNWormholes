class_name CardButton
extends Button
## A battle button (unit card or power button): name, cost / status line, and a cooldown sweep that
## shrinks from the top. Purely visual state; the screen tells it what to show via refresh().

signal activated

const TAP_MIN := 64.0           # >= UI.MIN_TOUCH (48) even after the screen is scaled down
const NAME_SIZE := 13
const NAME_SIZE_MIN := 9

var _name_label: Label
var _sub_label: Label
var _sweep: Control
var _cd_label: Label
var _state_key := ""
var _sweep_frac := 0.0
var _accent: Color = UI.BLUE
var _art: TextureRect = null


func _init(title := "", sub := "", accent: Color = UI.BLUE, min_size := Vector2(96, 112)) -> void:
	_accent = accent
	# Tap area never below TAP_MIN logical px (the 540x960 canvas shrinks on small phones).
	custom_minimum_size = Vector2(maxf(min_size.x, TAP_MIN), maxf(min_size.y, TAP_MIN))
	size = custom_minimum_size
	focus_mode = Control.FOCUS_NONE
	text = ""
	_name_label = UI.label(title, 13, UI.INK, HORIZONTAL_ALIGNMENT_CENTER)
	_name_label.set_anchors_preset(Control.PRESET_TOP_WIDE)
	_name_label.offset_left = 3
	_name_label.offset_right = -3
	_name_label.offset_top = 6
	_name_label.offset_bottom = 46
	_name_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_name_label.clip_text = true
	_name_label.max_lines_visible = 2
	_name_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	add_child(_name_label)
	fit_title()
	_sub_label = UI.label(sub, 20, UI.INK, HORIZONTAL_ALIGNMENT_CENTER)
	_sub_label.set_anchors_preset(Control.PRESET_BOTTOM_WIDE)
	_sub_label.offset_top = -38
	_sub_label.offset_bottom = -6
	_sub_label.autowrap_mode = TextServer.AUTOWRAP_OFF
	_sub_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_sub_label)
	_sweep = Control.new()
	_sweep.set_anchors_preset(Control.PRESET_FULL_RECT)
	_sweep.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_sweep.draw.connect(_draw_sweep)
	add_child(_sweep)
	_cd_label = UI.label("", 22, Color.WHITE, HORIZONTAL_ALIGNMENT_CENTER)
	_cd_label.set_anchors_preset(Control.PRESET_FULL_RECT)
	_cd_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_cd_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_cd_label.add_theme_color_override("font_outline_color", Color.BLACK)
	_cd_label.add_theme_constant_override("outline_size", 5)
	add_child(_cd_label)
	pressed.connect(func(): activated.emit())
	_apply_style("ready")


## Shows art on the card. mode "portrait": unit picture filling the card (cropped), texts get an outline;
## mode "icon": a centred power icon between the name and the status line. null removes the art.
func set_art(tex: Texture2D, mode := "portrait", flip := false) -> void:
	if _art != null:
		_art.queue_free()
		_art = null
	if tex == null:
		return
	_art = TextureRect.new()
	_art.name = "Art"
	_art.texture = tex
	_art.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_art.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_art.flip_h = flip
	_art.set_anchors_preset(Control.PRESET_FULL_RECT)
	if mode == "portrait":
		_art.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		_art.offset_left = 4
		_art.offset_right = -4
		_art.offset_top = 30
		_art.offset_bottom = -30
	else:
		_art.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		_art.offset_left = 8
		_art.offset_right = -8
		_art.offset_top = 22
		_art.offset_bottom = -26
	add_child(_art)
	move_child(_art, 0)   # behind the labels and the cooldown sweep
	for l in [_name_label, _sub_label]:
		l.add_theme_color_override("font_outline_color", Color(1, 1, 1, 0.9))
		l.add_theme_constant_override("outline_size", 4)
	_apply_style(_state_key if _state_key != "" else "ready")


func has_art() -> bool:
	return _art != null


func set_title(t: String) -> void:
	_name_label.text = t
	fit_title()


## Shrinks the name until it fits in two lines of the card (Spanish names are longer).
func fit_title() -> void:
	var w := maxf(10.0, size.x - 6.0)
	var font := _name_label.get_theme_font("font")
	if font == null:
		font = ThemeDB.fallback_font
	var sz := NAME_SIZE
	while sz > NAME_SIZE_MIN:
		var need := font.get_multiline_string_size(_name_label.text, HORIZONTAL_ALIGNMENT_CENTER, w, sz, 3)
		if need.y <= float(sz) * 2.5 and _longest_word_width(font, sz) <= w:
			break
		sz -= 1
	_name_label.add_theme_font_size_override("font_size", sz)


func _longest_word_width(font: Font, sz: int) -> float:
	var m := 0.0
	for word in _name_label.text.split(" "):
		m = maxf(m, font.get_string_size(word, HORIZONTAL_ALIGNMENT_LEFT, -1, sz).x)
	return m


func title_font_size() -> int:
	return _name_label.get_theme_font_size("font_size")


## state: "ready" | "wait" (cooling down) | "poor" (not enough Food) | "off" (blocked).
## cd_frac: remaining cooldown 0..1 (1 = just used). cd_text: seconds left, "" when none.
func refresh(state: String, sub: String, cd_frac: float, cd_text: String) -> void:
	_sub_label.text = sub
	_cd_label.text = cd_text
	if state != _state_key:
		_apply_style(state)
	if absf(cd_frac - _sweep_frac) > 0.004:
		_sweep_frac = cd_frac
		_sweep.queue_redraw()


func current_state() -> String:
	return _state_key


func _apply_style(state: String) -> void:
	_state_key = state
	var bg: Color = UI.PANEL
	var border: Color = _accent
	match state:
		"wait", "off", "poor":
			bg = UI.LOCKED
			border = UI.LOCKED_INK
	var sb := UI.style(bg, border, 14, 3, state == "ready")
	add_theme_stylebox_override("normal", sb)
	add_theme_stylebox_override("hover", sb)
	add_theme_stylebox_override("disabled", sb)
	add_theme_stylebox_override("pressed", UI.style(bg.darkened(0.12), border, 14, 3, false))
	add_theme_stylebox_override("focus", StyleBoxEmpty.new())
	var ink: Color = UI.INK if state == "ready" else UI.LOCKED_INK
	_name_label.add_theme_color_override("font_color", ink)
	_sub_label.add_theme_color_override("font_color", ink)
	if _art != null:
		_art.modulate = Color.WHITE if state == "ready" else Color(0.6, 0.6, 0.6, 0.8)


func _draw_sweep() -> void:
	if _sweep_frac <= 0.0:
		return
	var s := _sweep.size
	var h := s.y * clampf(_sweep_frac, 0.0, 1.0)
	_sweep.draw_rect(Rect2(3, 3, maxf(0.0, s.x - 6), maxf(0.0, h - 3)), Color(0, 0, 0, 0.45))
