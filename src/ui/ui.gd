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
const FONT_TITLE := "res://assets/fonts/Baloo2-ExtraBold.ttf"   # titles, buttons, big numbers (body text: Quicksand, set in project settings)
const TITLE_FROM_SIZE := 22

static var _title_font: Font = null


const FONT_BODY := "res://assets/fonts/Quicksand-SemiBold.ttf"


## Makes Quicksand the default font of every control (done in code, not in the project settings, so a fresh
## checkout does not hit a "no loader" error before the font is imported).
static func install_fonts() -> void:
	if ResourceLoader.exists(FONT_BODY):
		var f := load(FONT_BODY) as Font
		if f != null:
			ThemeDB.fallback_font = f


## The display font (Baloo 2); null when the file is missing (the default font is used).
static func title_font() -> Font:
	if _title_font == null and ResourceLoader.exists(FONT_TITLE):
		_title_font = load(FONT_TITLE) as Font
	return _title_font



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
	if size >= TITLE_FROM_SIZE and title_font() != null:
		l.add_theme_font_override("font", title_font())
	l.horizontal_alignment = align
	l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	return l


## kind: "primary" (orange), "teal", "ghost" (cream), "off" (greyed). Emits `pressed`.
static func button(text: String, kind := "primary", min_size := Vector2(0, MIN_TOUCH), font_size := 22) -> Button:
	var b := Button.new()
	b.text = text
	b.custom_minimum_size = Vector2(maxf(min_size.x, 0.0), maxf(min_size.y, MIN_TOUCH))
	b.add_theme_font_size_override("font_size", font_size)
	if title_font() != null:
		b.add_theme_font_override("font", title_font())
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
	b.pressed.connect(_tap_sound)
	return b


## Dresses `b` with the painted frame `id` (normal / hover / pressed / disabled); false (unchanged) when the art is missing.
static func skin_button(b: Button, id: String, corner: float, pad := Vector2(10, 4), disabled_id := "") -> bool:
	var n := NineStyle.make(id, corner, pad)
	if n == null:
		return false
	var h := NineStyle.make(id, corner, pad)
	h.tint = Color(1.06, 1.06, 1.06)
	var d := NineStyle.make(id, corner, pad)
	d.tint = Color(0.86, 0.84, 0.8)
	var pr := NineStyle.make(id, corner, pad)
	pr.tint = Color(0.82, 0.80, 0.76)
	var off := NineStyle.make(disabled_id, corner, pad) if disabled_id != "" else null
	b.add_theme_stylebox_override("normal", n)
	b.add_theme_stylebox_override("hover", h)
	b.add_theme_stylebox_override("pressed", pr)
	b.add_theme_stylebox_override("disabled", off if off != null else d)
	b.add_theme_stylebox_override("focus", StyleBoxEmpty.new())
	return true


## Click feedback for every UI.button (no-op before the services are booted).
static func _tap_sound() -> void:
	if Game.audio != null:
		Game.audio.play_sfx("ui_tap")


static func panel(bg := PANEL) -> PanelContainer:
	var p := PanelContainer.new()
	p.add_theme_stylebox_override("panel", style(bg, BORDER, 16))
	return p


## Currency chip like the top bar of the mockup: "icon value". `icon_id` (manifest id such as
## icon_coin) replaces the symbol with the art when it exists; otherwise the symbol text stays.
static func chip(icon_text: String, value: String, icon_id := "") -> PanelContainer:
	var p := PanelContainer.new()
	var painted := NineStyle.make("ui_chip", 18.0, Vector2(14, 4))
	p.add_theme_stylebox_override("panel", painted if painted != null else style(PANEL, BORDER, 18, 2, false))
	var art := SpriteFactory.icon(icon_id, 26.0) if icon_id != "" else null
	if art == null:
		var l := label("%s %s" % [icon_text, value], 18)
		l.autowrap_mode = TextServer.AUTOWRAP_OFF
		p.add_child(l)
		return p
	var h := HBoxContainer.new()
	h.add_theme_constant_override("separation", 5)
	art.name = "IconArt"
	h.add_child(art)
	var l2 := label(value, 18)
	l2.autowrap_mode = TextServer.AUTOWRAP_OFF
	l2.name = "Value"
	h.add_child(l2)
	p.add_child(h)
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


## Progress bar in the game's palette (cream track, brown outline, orange fill), not the default blue theme.
static func progress_bar(size := Vector2(0, 22)) -> ProgressBar:
	var b := ProgressBar.new()
	b.custom_minimum_size = size
	b.max_value = 1.0
	b.show_percentage = false
	var track := StyleBoxFlat.new()
	track.bg_color = PANEL
	track.border_color = INK
	track.set_border_width_all(3)
	track.set_corner_radius_all(11)
	var fill := StyleBoxFlat.new()
	fill.bg_color = ORANGE
	fill.set_corner_radius_all(9)
	b.add_theme_stylebox_override("background", track)
	b.add_theme_stylebox_override("fill", fill)
	return b
