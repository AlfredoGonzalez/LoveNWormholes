class_name NineStyle
extends StyleBox
## A 9-slice StyleBox from a painted frame (assets/images/ui/ui_*.png). Unlike StyleBoxTexture the margins are
## given in SOURCE pixels and drawn at `draw_scale` (display px per source px), so a 850 px painted pill can be a
## 36 px chip with its borders in proportion. The centre is stretched; corners keep their shape.

## Source-pixel margin (all four sides) of each frame: the radius where the painted corner ends.
const MARGINS := {
	"ui_chip": 149.0, "ui_tag": 156.0, "ui_btn_play": 119.0, "ui_panel_stage": 70.0,
	"ui_btn_square": 130.0, "ui_tab": 130.0, "ui_tab_active": 120.0, "ui_tab_locked": 140.0, "ui_badge": 280.0,
}

var texture: Texture2D
var src_margin := 100.0
var draw_scale := 0.1
var tint := Color.WHITE


## A style for frame `id` whose corners are `corner` display px; null when the art is not there.
static func make(id: String, corner: float, pad := Vector2(10, 4)) -> NineStyle:
	var t := SpriteFactory.texture_of(id)
	if t == null:
		return null
	var s := NineStyle.new()
	s.texture = t
	s.src_margin = float(MARGINS.get(id, 100.0))
	s.draw_scale = corner / s.src_margin
	s.content_margin_left = pad.x
	s.content_margin_right = pad.x
	s.content_margin_top = pad.y
	s.content_margin_bottom = pad.y
	return s


func _draw(to_canvas_item: RID, rect: Rect2) -> void:
	if texture == null:
		return
	var sz := texture.get_size()
	var m := minf(src_margin, minf(sz.x, sz.y) * 0.5)
	var d := m * draw_scale
	var dx := minf(d, rect.size.x * 0.5)
	var dy := minf(d, rect.size.y * 0.5)
	var xs := [rect.position.x, rect.position.x + dx, rect.end.x - dx, rect.end.x]
	var ys := [rect.position.y, rect.position.y + dy, rect.end.y - dy, rect.end.y]
	var sx := [0.0, m, sz.x - m, sz.x]
	var sy := [0.0, m, sz.y - m, sz.y]
	var rid := texture.get_rid()
	for j in 3:
		for i in 3:
			var dst := Rect2(xs[i], ys[j], xs[i + 1] - xs[i], ys[j + 1] - ys[j])
			if dst.size.x <= 0.0 or dst.size.y <= 0.0:
				continue
			RenderingServer.canvas_item_add_texture_rect_region(to_canvas_item, dst, rid,
				Rect2(sx[i], sy[j], sx[i + 1] - sx[i], sy[j + 1] - sy[j]), tint)


func _get_draw_rect(rect: Rect2) -> Rect2:
	return rect
