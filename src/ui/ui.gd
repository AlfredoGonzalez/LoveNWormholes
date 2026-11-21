class_name UI
extends RefCounted
## Tiny code-only UI toolkit with the mockup's look (docs/mockup): cream paper, brown outlines,
## orange primary buttons, teal secondary. All colours and sizes live here so every screen matches.
## Viewport is 540 x 960 (portrait). Touch targets are >= 48 px (spec 9.3).

const BG := Color("F6EBD3")
const PANEL := Color("FFF7E6")
const INK := Color("3B2A1E")
const BORDER := Color("5B3A22")
const ORANGE := Color("F28C28")
const TEAL := Color("15707A")
const GOLD := Color("F2B632")
const GREEN := Color("8FBF6A")
const RED := Color("C8453B")
const BLUE := Color("2F6DB5")
const LOCKED := Color("D9CDB4")
const LOCKED_INK := Color("6B5A48")
const MIN_TOUCH := 48.0


static func style(bg: Color, border := BORDER, radius := 18, border_w := 3, shadow := true) -> StyleBoxFlat:
	var sb := StyleBoxFlat.new()
	sb.bg_color = bg
	sb.border_color = border
	sb.set_border_width_all(border_w)
	sb.set_corner_radius_all(radius)
	sb.content_margin_left = 14
	sb.content_margin_right = 14
	sb.content_margin_top = 6
	sb.content_margin_bottom = 6
	if shadow:
		sb.shadow_color = Color(border, 0.35)
		sb.shadow_size = 0
		sb.shadow_offset = Vector2(0, 4)
	return sb


static func label(text: String, size := 20, color := INK, align := HORIZONTAL_ALIGNMENT_LEFT) -> Label:
	var l := Label.new()
	l.text = text
	l.add_theme_font_size_override("font_size", size)
	l.add_theme_color_override("font_color", color)
	l.horizontal_alignment = align
	l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	return l


## kind: "primary" (orange), "teal", "ghost" (cream), "off" (greyed). Emits `pressed`.
static func button(text: String, kind := "primary", min_size := Vector2(0, MIN_TOUCH), font_size := 22) -> Button:
	var b := Button.new()
	b.text = text
	b.custom_minimum_size = Vector2(maxf(min_size.x, 0.0), maxf(min_size.y, MIN_TOUCH))
	b.add_theme_font_size_override("font_size", font_size)
	var bg := ORANGE
	var fg := INK
	match kind:
		"teal":
			bg = TEAL
			fg = Color.WHITE
		"ghost":
			bg = PANEL
		"off":
			bg = LOCKED
			fg = LOCKED_INK
	b.add_theme_stylebox_override("normal", style(bg))
	b.add_theme_stylebox_override("hover", style(bg.lightened(0.08)))
	b.add_theme_stylebox_override("pressed", style(bg.darkened(0.12), BORDER, 18, 3, false))
	b.add_theme_stylebox_override("disabled", style(LOCKED, LOCKED_INK))
	for c in ["font_color", "font_hover_color", "font_pressed_color", "font_focus_color"]:
		b.add_theme_color_override(c, fg)
	b.add_theme_color_override("font_disabled_color", LOCKED_INK)
	if kind == "off":
		b.disabled = true
	return b


static func panel(bg := PANEL) -> PanelContainer:
	var p := PanelContainer.new()
	p.add_theme_stylebox_override("panel", style(bg, BORDER, 16))
	return p


## Currency chip like the top bar of the mockup: "icon value".
static func chip(icon_text: String, value: String) -> PanelContainer:
	var p := PanelContainer.new()
	p.add_theme_stylebox_override("panel", style(PANEL, BORDER, 18, 2, false))
	var l := label("%s %s" % [icon_text, value], 18)
	l.autowrap_mode = TextServer.AUTOWRAP_OFF
	p.add_child(l)
	return p


## A coloured rectangle with a caption: the placeholder used wherever art is still missing.
static func placeholder(caption: String, color: Color, size: Vector2) -> Control:
	var c := ColorRect.new()
	c.color = Color(color, 0.55)
	c.custom_minimum_size = size
	var l := label(caption, 12, INK, HORIZONTAL_ALIGNMENT_CENTER)
	l.set_anchors_preset(Control.PRESET_FULL_RECT)
	l.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	c.add_child(l)
	return c


## Full-screen cream background for menu screens.
static func background(color := BG) -> ColorRect:
	var r := ColorRect.new()
	r.color = color
	r.set_anchors_preset(Control.PRESET_FULL_RECT)
	r.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return r


## "Unlocks at level N" placeholder used by every locked feature (decision 5).
static func locked_note(level: int) -> Label:
	return label(Game.t("ui.unlocks_level", [level]), 14, LOCKED_INK, HORIZONTAL_ALIGNMENT_CENTER)
