class_name BaseView
extends Node2D
## A base on the lane end: coloured rectangle with a label and an HP bar above it (blue = player,
## red = enemy). Origin is the bottom-centre. Dirt Shield shows as a dome around the player base.

const K := BattleWorld.SCALE
const W := 68.0 * K
const H := 112.0 * K
const ART_W := 150.0 * K      ## width of the base art in world px (its outer edge sits on the world edge)
const WORLD_W := BattleWorld.WORLD_W

var side := 0
var caption := ""
var hp_frac := 1.0
var shield_frac := 0.0
var flash := 0.0
var art: Texture2D = null     ## base_p<era> / base_e<era> when the manifest has it, else the code-drawn base
var art_flip := false
var _art_h := H


func setup(p_side: int, p_caption: String, era := 1) -> void:
	side = p_side
	caption = p_caption
	var id := "base_%s%d" % ["p" if side == BattleSim.PLAYER else "e", era]
	art = SpriteFactory.texture_of(id)
	if art != null:
		var want := "right" if side == BattleSim.PLAYER else "left"
		art_flip = want != SpriteFactory.facing_of(id)
		_art_h = ART_W * float(art.get_height()) / maxf(1.0, float(art.get_width()))
	queue_redraw()


func update_from(hp: float, hp_max: float, shield: float, shield_max: float, dt: float) -> void:
	hp_frac = clampf(hp / maxf(1.0, hp_max), 0.0, 1.0)
	shield_frac = clampf(shield / maxf(1.0, shield_max), 0.0, 1.0) if shield > 0.0 else 0.0
	flash = maxf(0.0, flash - dt)
	queue_redraw()


## Y (negative = up) of the top of the base, for floating numbers.
func top_y() -> float:
	return -_art_h if art != null else -H


func hit() -> void:
	flash = 0.15


func _draw() -> void:
	if art != null:
		_draw_art()
		return
	var accent: Color = UI.BLUE if side == BattleSim.PLAYER else UI.RED
	var body: Color = Color("B07A4A") if side == BattleSim.PLAYER else Color("A5703E")
	if flash > 0.0:
		body = body.lerp(Color.WHITE, 0.6)
	var r := Rect2(-W / 2.0, -H, W, H)
	draw_rect(r, body)
	draw_rect(r, UI.BORDER, false, 3.0)
	draw_rect(Rect2(-9 * K, -34 * K, 18 * K, 34 * K), UI.INK)
	draw_rect(Rect2(-W / 2.0, -H, W, 12 * K), accent)
	draw_line(Vector2(0, -H), Vector2(0, -H - 22 * K), UI.BORDER, 3.0 * K)
	var dir := 1.0 if side == BattleSim.PLAYER else -1.0
	draw_colored_polygon(PackedVector2Array([Vector2(0, -H - 22 * K), Vector2(0, -H - 8 * K), Vector2(18.0 * K * dir, -H - 15 * K)]), accent)
	var font := ThemeDB.fallback_font
	var pos := Vector2(-W / 2.0, -H / 2.0 - 4)
	draw_string_outline(font, pos, caption, HORIZONTAL_ALIGNMENT_CENTER, W, 18, 5, Color(0, 0, 0, 0.8))
	draw_string(font, pos, caption, HORIZONTAL_ALIGNMENT_CENTER, W, 18, Color.WHITE)
	# HP bar above the flag.
	var bw := W
	var br := Rect2(-bw / 2.0, -H - 38.0 * K, bw, 8.0 * K)
	draw_rect(br.grow(2.0), Color(0, 0, 0, 0.75))
	draw_rect(Rect2(br.position, Vector2(bw * hp_frac, br.size.y)), accent.lightened(0.15))
	if shield_frac > 0.0:
		draw_arc(Vector2(0, -H * 0.45), H * 0.75, 0.0, TAU, 40, Color(0.7, 0.5, 0.25, 0.35 + 0.5 * shield_frac), 4.0 * K)


func _draw_art() -> void:
	var accent: Color = UI.BLUE if side == BattleSim.PLAYER else UI.RED
	var cx := ART_W / 2.0 - position.x if side == BattleSim.PLAYER else (WORLD_W - ART_W / 2.0) - position.x
	var w := -ART_W if art_flip else ART_W
	var tint := Color.WHITE.lerp(Color(2, 2, 2), 0.5) if flash > 0.0 else Color.WHITE
	draw_texture_rect(art, Rect2(cx - w / 2.0, -_art_h, w, _art_h), false, tint)
	var font := ThemeDB.fallback_font
	var pos := Vector2(cx - ART_W / 2.0, -10.0 * K)
	draw_string_outline(font, pos, caption, HORIZONTAL_ALIGNMENT_CENTER, ART_W, 18, 5, Color(0, 0, 0, 0.8))
	draw_string(font, pos, caption, HORIZONTAL_ALIGNMENT_CENTER, ART_W, 18, Color.WHITE)
	var br := Rect2(cx - ART_W / 2.0 + 20.0 * K, -_art_h - 16.0 * K, ART_W - 40.0 * K, 8.0 * K)
	draw_rect(br.grow(2.0), Color(0, 0, 0, 0.75))
	draw_rect(Rect2(br.position, Vector2(br.size.x * hp_frac, br.size.y)), accent.lightened(0.15))
	if shield_frac > 0.0:
		draw_arc(Vector2(cx, -_art_h * 0.45), _art_h * 0.75, 0.0, TAU, 40, Color(0.7, 0.5, 0.25, 0.35 + 0.5 * shield_frac), 4.0 * K)
