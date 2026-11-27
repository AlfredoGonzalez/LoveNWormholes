class_name RecenterButton
extends Button
## Small "centre the camera" button. Art id `icon_recenter` when it exists, else a code-drawn target mark.

var art: Texture2D = null


func _init() -> void:
	name = "RecenterButton"
	focus_mode = Control.FOCUS_NONE
	custom_minimum_size = Vector2(UI.MIN_TOUCH, UI.MIN_TOUCH)
	size = custom_minimum_size
	art = SpriteFactory.texture_of("icon_recenter")
	var st := UI.style(Color(UI.PANEL, 0.85), UI.BORDER, 24, 3, false)
	for s in ["normal", "hover", "pressed", "focus"]:
		add_theme_stylebox_override(s, st)


func _draw() -> void:
	var c := size * 0.5
	if art != null:
		var s := minf(size.x, size.y) - 12.0
		draw_texture_rect(art, Rect2(c - Vector2(s, s) * 0.5, Vector2(s, s)), false)
		return
	draw_arc(c, 11.0, 0.0, TAU, 24, UI.INK, 3.0)
	draw_circle(c, 3.5, UI.INK)
	for a in 4:
		var dir := Vector2.RIGHT.rotated(float(a) * PI * 0.5)
		draw_line(c + dir * 8.0, c + dir * 17.0, UI.INK, 3.0)
