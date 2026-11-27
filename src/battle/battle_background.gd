class_name BattleBackground
extends Node2D
## Battle background with camera parallax. Three modes, best first:
##  "layers": per-era art bg_era<N>_sky / _far / _mid / _ground / _front (factors LAYER_FACTORS; front is drawn in
##            front of the units: take it with take_front() and add it above the world).
##  "single": the one-image bg_era<N> scaled to cover screen + travel and shifted at SINGLE_FACTOR.
##  "code":   the coloured placeholder (sky, clouds, hills, road) shifted by the same factors.
## `apply_camera(cam_x)` moves it all; `drift(dt)` keeps the code clouds moving.

const SKY := [
	[Color("BFE6F2"), Color("F9E6B8"), Color("CFE3A0")],   # era 1
	[Color("F6D9A0"), Color("F9E6B8"), Color("E8CF8E")],   # era 2 desert
	[Color("B9C9E8"), Color("E8E1D0"), Color("B8D08A")],   # era 3
	[Color("B9B0A5"), Color("D9C7A8"), Color("A9A590")],   # era 4
	[Color("2A1D4F"), Color("5B3C8F"), Color("2E6A8E")],   # era 5
]
const LAYER_SUFFIX := ["sky", "far", "mid", "ground", "front"]
const LAYER_FACTORS := {"sky": 0.10, "far": 0.25, "mid": 0.50, "ground": 1.0, "front": 1.0}
const SINGLE_FACTOR := 0.30

var size := Vector2(540, 960)
var lane_y := 557.0
var era := 1
var max_cam := BattleWorld.MAX_CAM
var cam_x := 0.0
var mode := "code"
var art: Texture2D = null          ## bg_era<N> (single image) when mode == "single"
var layers := {}                   ## suffix -> TextureRect when mode == "layers"
var _t := 0.0
var _clouds: Array = [Vector2(60, 90), Vector2(300, 150), Vector2(470, 70)]


func setup(p_size: Vector2, p_lane_y: float, p_era: int, p_max_cam := BattleWorld.MAX_CAM) -> void:
	size = p_size
	lane_y = p_lane_y
	era = clampi(p_era, 1, 5)
	max_cam = p_max_cam
	for l in layers.values():
		(l as Node).queue_free()
	layers.clear()
	art = null
	mode = "code"
	if _build_layers():
		mode = "layers"
	else:
		art = SpriteFactory.texture_of("bg_era%d" % era)
		if art != null:
			mode = "single"
	apply_camera(cam_x)
	queue_redraw()


static func layer_id(p_era: int, suffix: String) -> String:
	return "bg_era%d_%s" % [p_era, suffix]


## Cover scale of a texture for a parallax factor: fills the screen height and the width screen + travel * factor.
func cover_scale(tex: Texture2D, factor: float) -> float:
	return maxf(size.y / float(tex.get_height()), (size.x + max_cam * factor) / float(tex.get_width()))


func _build_layers() -> bool:
	var texs := {}
	for s in LAYER_SUFFIX:
		var t := SpriteFactory.texture_of(layer_id(era, s))
		if t == null:
			return false
		texs[s] = t
	for s in LAYER_SUFFIX:
		var t: Texture2D = texs[s]
		var sc := cover_scale(t, float(LAYER_FACTORS[s]))
		var r := TextureRect.new()
		r.name = "bg_" + s
		r.texture = t
		r.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		r.stretch_mode = TextureRect.STRETCH_SCALE
		r.size = Vector2(t.get_width(), t.get_height()) * sc
		r.position = Vector2(0.0, size.y - r.size.y)
		r.mouse_filter = Control.MOUSE_FILTER_IGNORE
		add_child(r)
		layers[s] = r
	return true


## Detaches the front layer (drawn over the units) so the screen can add it above the world; null without layers.
func take_front() -> TextureRect:
	var f: TextureRect = layers.get("front")
	if f != null and f.get_parent() == self:
		remove_child(f)
	return f


func apply_camera(p_cam_x: float) -> void:
	cam_x = p_cam_x
	for s in layers:
		(layers[s] as Control).position.x = -cam_x * float(LAYER_FACTORS[s])
	if mode != "layers":
		queue_redraw()


func drift(dt: float) -> void:
	_t += dt
	if mode == "code":
		queue_redraw()


## Cover rect of the single image: fills screen + travel at SINGLE_FACTOR without distortion, shifted with the camera.
func _art_rect() -> Rect2:
	var ts := Vector2(art.get_width(), art.get_height())
	var sc := cover_scale(art, SINGLE_FACTOR)
	var dsz := ts * sc
	return Rect2(Vector2(-cam_x * SINGLE_FACTOR, (size.y - dsz.y) * 0.5), dsz)


func _draw() -> void:
	if mode == "layers":
		return
	if mode == "single":
		draw_texture_rect(art, _art_rect(), false)
		return
	var pal: Array = SKY[era - 1]
	var top: Color = pal[0]
	var mid: Color = pal[1]
	var grass: Color = pal[2]
	var horizon := lane_y - 40.0 * BattleWorld.SCALE
	var road_h := 76.0 * BattleWorld.SCALE
	draw_polygon(PackedVector2Array([Vector2(0, 0), Vector2(size.x, 0), Vector2(size.x, horizon), Vector2(0, horizon)]),
			PackedColorArray([top, top, mid, mid]))
	for c in _clouds:
		var cx := fposmod((c as Vector2).x + _t * 6.0 - cam_x * LAYER_FACTORS["sky"], size.x + 160.0) - 80.0
		draw_circle(Vector2(cx, c.y), 22, Color(1, 1, 1, 0.55))
		draw_circle(Vector2(cx + 22, c.y + 4), 17, Color(1, 1, 1, 0.55))
		draw_circle(Vector2(cx - 22, c.y + 6), 15, Color(1, 1, 1, 0.55))
	_hills(horizon + 6.0, 90.0, Color(top.lerp(grass, 0.5), 1.0).darkened(0.1), 0.017, _t * 1.5 + cam_x * LAYER_FACTORS["far"])
	_hills(horizon + 18.0, 55.0, Color(grass, 1.0).darkened(0.05), 0.027, _t * 3.0 + 40.0 + cam_x * LAYER_FACTORS["mid"])
	draw_rect(Rect2(0, horizon + 14.0, size.x, size.y - horizon), grass)
	var road := Rect2(0, lane_y - road_h * 0.5, size.x, road_h)
	draw_rect(road, Color("C9A26B"))
	draw_line(road.position, road.position + Vector2(size.x, 0), UI.BORDER, 4.0)
	draw_line(road.position + Vector2(0, road.size.y), road.position + road.size, UI.BORDER, 4.0)
	for i in 14:   # dashes sit on the road (world speed): they scroll with the lane
		var dx := fposmod(float(i) * 66.0 - cam_x, 14.0 * 66.0) - 33.0
		draw_rect(Rect2(dx, lane_y + 30.0, 30, 4), Color(0.35, 0.22, 0.1, 0.35))
	draw_rect(Rect2(0, road.end.y + 2.0, size.x, size.y - road.end.y), grass.darkened(0.08))


func _hills(base_y: float, amp: float, color: Color, freq: float, shift: float) -> void:
	var pts := PackedVector2Array()
	pts.append(Vector2(0, base_y + 30.0))
	var x := 0.0
	while x <= size.x + 12.0:
		pts.append(Vector2(x, base_y - amp * (0.5 + 0.5 * sin((x + shift) * freq))))
		x += 12.0
	pts.append(Vector2(size.x, base_y + 30.0))
	draw_colored_polygon(pts, color)
