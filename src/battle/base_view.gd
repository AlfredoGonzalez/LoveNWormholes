class_name BaseView
extends Node2D
## A base on the lane end: coloured rectangle with a label and an HP bar above it (blue = player,
## red = enemy). Origin is the bottom-centre. Dirt Shield shows as a dome around the player base.

const W := 68.0
const H := 112.0

var side := 0
var caption := ""
var hp_frac := 1.0
var shield_frac := 0.0
var flash := 0.0


func setup(p_side: int, p_caption: String) -> void:
	side = p_side
	caption = p_caption
	queue_redraw()


func update_from(hp: float, hp_max: float, shield: float, shield_max: float, dt: float) -> void:
	hp_frac = clampf(hp / maxf(1.0, hp_max), 0.0, 1.0)
	shield_frac = clampf(shield / maxf(1.0, shield_max), 0.0, 1.0) if shield > 0.0 else 0.0
	flash = maxf(0.0, flash - dt)
	queue_redraw()


func hit() -> void:
	flash = 0.15


func _draw() -> void:
	var accent: Color = UI.BLUE if side == BattleSim.PLAYER else UI.RED
	var body: Color = Color("B07A4A") if side == BattleSim.PLAYER else Color("A5703E")
	if flash > 0.0:
		body = body.lerp(Color.WHITE, 0.6)
	var r := Rect2(-W / 2.0, -H, W, H)
	draw_rect(r, body)
	draw_rect(r, UI.BORDER, false, 3.0)
	draw_rect(Rect2(-9, -34, 18, 34), UI.INK)
	draw_rect(Rect2(-W / 2.0, -H, W, 12), accent)
	draw_line(Vector2(0, -H), Vector2(0, -H - 22), UI.BORDER, 3.0)
	var dir := 1.0 if side == BattleSim.PLAYER else -1.0
	draw_colored_polygon(PackedVector2Array([Vector2(0, -H - 22), Vector2(0, -H - 8), Vector2(18.0 * dir, -H - 15)]), accent)
	var font := ThemeDB.fallback_font
	var pos := Vector2(-W / 2.0, -H / 2.0 - 4)
	draw_string_outline(font, pos, caption, HORIZONTAL_ALIGNMENT_CENTER, W, 13, 4, Color(0, 0, 0, 0.8))
	draw_string(font, pos, caption, HORIZONTAL_ALIGNMENT_CENTER, W, 13, Color.WHITE)
	# HP bar above the flag.
	var bw := W
	var br := Rect2(-bw / 2.0, -H - 38.0, bw, 8.0)
	draw_rect(br.grow(2.0), Color(0, 0, 0, 0.75))
	draw_rect(Rect2(br.position, Vector2(bw * hp_frac, br.size.y)), accent.lightened(0.15))
	if shield_frac > 0.0:
		draw_arc(Vector2(0, -H * 0.45), H * 0.75, 0.0, TAU, 40, Color(0.7, 0.5, 0.25, 0.35 + 0.5 * shield_frac), 4.0)
