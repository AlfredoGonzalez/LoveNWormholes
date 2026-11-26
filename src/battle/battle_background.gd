class_name BattleBackground
extends Node2D
## Placeholder parallax background built from coloured layers (sky, far hills, mid hills, road, grass).
## Real art (one tall 9:16 image + props) replaces this later through the manifest; the layer scroll hook
## `drift(dt)` keeps clouds and hills gently moving.

const SKY := [
	[Color("BFE6F2"), Color("F9E6B8"), Color("CFE3A0")],   # era 1
	[Color("F6D9A0"), Color("F9E6B8"), Color("E8CF8E")],   # era 2 desert
	[Color("B9C9E8"), Color("E8E1D0"), Color("B8D08A")],   # era 3
	[Color("B9B0A5"), Color("D9C7A8"), Color("A9A590")],   # era 4
	[Color("2A1D4F"), Color("5B3C8F"), Color("2E6A8E")],   # era 5
]

var size := Vector2(540, 960)
var lane_y := 557.0
var era := 1
var _t := 0.0
var art: Texture2D = null   ## bg_era<N> from the manifest (one tall 9:16 image); null = code-drawn background
const ART_ZOOM := 1.04      ## slight overscan so the sway never shows an edge
var _clouds: Array = [Vector2(60, 90), Vector2(300, 150), Vector2(470, 70)]


func setup(p_size: Vector2, p_lane_y: float, p_era: int) -> void:
	size = p_size
	lane_y = p_lane_y
	era = clampi(p_era, 1, 5)
	art = SpriteFactory.texture_of("bg_era%d" % era)
	queue_redraw()


func drift(dt: float) -> void:
	_t += dt
	queue_redraw()


## Cover rect for the art: fills the screen without distortion, centred, with a slow horizontal sway.
func _art_rect() -> Rect2:
	var ts := Vector2(art.get_width(), art.get_height())
	var sc := maxf(size.x / ts.x, size.y / ts.y) * ART_ZOOM
	var dsz := ts * sc
	var slack := dsz - size
	var sway := sin(_t * 0.15) * 0.5 * slack.x
	return Rect2(Vector2(-slack.x * 0.5 + sway, -slack.y * 0.5), dsz)


func _draw() -> void:
	if art != null:
		draw_texture_rect(art, _art_rect(), false)
		return
	var pal: Array = SKY[era - 1]
	var top: Color = pal[0]
	var mid: Color = pal[1]
	var grass: Color = pal[2]
	# Sky gradient.
	var horizon := lane_y - 40.0
	draw_polygon(PackedVector2Array([Vector2(0, 0), Vector2(size.x, 0), Vector2(size.x, horizon), Vector2(0, horizon)]),
			PackedColorArray([top, top, mid, mid]))
	# Clouds drifting slowly.
	for c in _clouds:
		var cx := fposmod((c as Vector2).x + _t * 6.0, size.x + 160.0) - 80.0
		draw_circle(Vector2(cx, c.y), 22, Color(1, 1, 1, 0.55))
		draw_circle(Vector2(cx + 22, c.y + 4), 17, Color(1, 1, 1, 0.55))
		draw_circle(Vector2(cx - 22, c.y + 6), 15, Color(1, 1, 1, 0.55))
	# Far hills (slow), mid hills (a bit faster).
	_hills(horizon + 6.0, 90.0, Color(top.lerp(grass, 0.5), 1.0).darkened(0.1), 0.017, _t * 1.5)
	_hills(horizon + 18.0, 55.0, Color(grass, 1.0).darkened(0.05), 0.027, _t * 3.0 + 40.0)
	# Ground, road (the lane), foreground grass.
	draw_rect(Rect2(0, horizon + 14.0, size.x, size.y - horizon), grass)
	var road := Rect2(0, lane_y - 38.0, size.x, 76.0)
	draw_rect(road, Color("C9A26B"))
	draw_line(road.position, road.position + Vector2(size.x, 0), UI.BORDER, 4.0)
	draw_line(road.position + Vector2(0, road.size.y), road.position + road.size, UI.BORDER, 4.0)
	# Dashes along the road so movement reads.
	for i in 14:
		var dx := fposmod(float(i) * 44.0 - _t * 12.0, size.x + 44.0) - 22.0
		draw_rect(Rect2(dx, lane_y + 20.0, 20, 3), Color(0.35, 0.22, 0.1, 0.35))
	draw_rect(Rect2(0, road.end.y + 2.0, size.x, size.y - road.end.y), grass.darkened(0.08))


func _hills(base_y: float, amp: float, color: Color, freq: float, shift: float) -> void:
	var pts := PackedVector2Array()
	pts.append(Vector2(0, base_y + 30.0))
	var x := 0.0
	while x <= size.x + 12.0:
		pts.append(Vector2(x, base_y - amp * (0.5 + 0.5 * sin((x + shift) * freq)) ))
		x += 12.0
	pts.append(Vector2(size.x, base_y + 30.0))
	draw_colored_polygon(pts, color)
