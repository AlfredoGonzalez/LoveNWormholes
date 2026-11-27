class_name BattleRadar
extends Control
## Lane mini-bar (fixed HUD): a thin line from the player base (left) to the enemy base (right), the camera's
## visible window highlighted and every unit as a dot (blue player, red enemy, bigger boss). Tap or drag it to
## move the camera (emits `seek(world_x)`). Art id `ui_minimap` (optional) replaces the code-drawn track.

signal seek(world_x: float)

const PAD := 12.0
const TRACK_H := 6.0
const DOT_R := 3.0
const BOSS_R := 5.5

var window_u := Vector2(0.0, 1.0)   ## visible window as 0..1 along the track
var dots: Array = []                ## [{u: float, side: int, boss: bool}]
var art: Texture2D = null
var _pressed := false


func _init() -> void:
	name = "BattleRadar"
	mouse_filter = Control.MOUSE_FILTER_STOP
	custom_minimum_size = Vector2(300, 22)
	art = SpriteFactory.texture_of("ui_minimap")


## 0..1 along the track for a world x (clamped between the two bases).
static func u_of(world_x: float) -> float:
	return clampf((world_x - BattleWorld.PLAYER_BASE_X) / (BattleWorld.ENEMY_BASE_X - BattleWorld.PLAYER_BASE_X), 0.0, 1.0)


static func world_of(u: float) -> float:
	return lerpf(BattleWorld.PLAYER_BASE_X, BattleWorld.ENEMY_BASE_X, clampf(u, 0.0, 1.0))


func _track_w() -> float:
	return maxf(1.0, size.x - 2.0 * PAD)


## 0..1 along the track for a local x of this control.
func u_at(local_x: float) -> float:
	return clampf((local_x - PAD) / _track_w(), 0.0, 1.0)


## sim: BattleSim (read only); cam_x: left edge of the view in world px.
func refresh(sim, cam_x: float) -> void:
	window_u = Vector2(u_of(cam_x), u_of(cam_x + BattleWorld.SCREEN_W))
	var d: Array = []
	for u in sim.units:
		if not u.alive():
			continue
		d.append({"u": u_of(BattleWorld.sim_to_world(u.x, sim.lane)), "side": u.side, "boss": u.is_boss})
	dots = d
	queue_redraw()


func _draw() -> void:
	var cy := size.y * 0.5
	var w := _track_w()
	if art != null:
		draw_texture_rect(art, Rect2(0, 0, size.x, size.y), false)
	else:
		draw_rect(Rect2(0, 0, size.x, size.y), Color(UI.PANEL, 0.55))
		draw_rect(Rect2(0, 0, size.x, size.y), Color(UI.BORDER, 0.8), false, 2.0)
	draw_rect(Rect2(PAD, cy - TRACK_H * 0.5, w, TRACK_H), Color(UI.BORDER, 0.55))
	var wr := Rect2(PAD + window_u.x * w, 2.0, maxf(4.0, (window_u.y - window_u.x) * w), size.y - 4.0)
	draw_rect(wr, Color(UI.GOLD, 0.35))
	draw_rect(wr, UI.GOLD, false, 2.0)
	draw_rect(Rect2(PAD - 6.0, cy - 7.0, 10.0, 14.0), UI.BLUE)
	draw_rect(Rect2(PAD - 6.0, cy - 7.0, 10.0, 14.0), UI.BORDER, false, 1.5)
	draw_rect(Rect2(PAD + w - 4.0, cy - 7.0, 10.0, 14.0), UI.RED)
	draw_rect(Rect2(PAD + w - 4.0, cy - 7.0, 10.0, 14.0), UI.BORDER, false, 1.5)
	for d in dots:   # regular units first, bosses on top
		if not bool(d["boss"]):
			_dot(PAD + float(d["u"]) * w, cy, int(d["side"]), DOT_R)
	for d in dots:
		if bool(d["boss"]):
			_dot(PAD + float(d["u"]) * w, cy, int(d["side"]), BOSS_R)


func _dot(px: float, cy: float, side: int, r: float) -> void:
	var c: Color = UI.BLUE.lightened(0.25) if side == BattleSim.PLAYER else UI.RED.lightened(0.1)
	draw_circle(Vector2(px, cy), r, c)
	draw_arc(Vector2(px, cy), r, 0.0, TAU, 12, Color(0.1, 0.1, 0.1), 1.2)


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and (event as InputEventMouseButton).button_index == MOUSE_BUTTON_LEFT:
		_pressed = (event as InputEventMouseButton).pressed
		if _pressed:
			seek.emit(world_of(u_at(event.position.x)))
		accept_event()
	elif event is InputEventMouseMotion and _pressed:
		seek.emit(world_of(u_at(event.position.x)))
		accept_event()
