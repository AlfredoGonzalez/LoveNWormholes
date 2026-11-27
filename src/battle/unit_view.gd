class_name UnitView
extends Node2D
## Presentation of one SimUnit: sprite (placeholder until art), side marker, HP bar, tint and small pose
## offsets. Holds no rules; BattleScreen feeds it the sim state every frame.

const K := BattleWorld.SCALE
const MARKER_Y := 6.0 * K
const PLAYER_MARK := Color("2F6DB5")
const ENEMY_MARK := Color("C8453B")

var uid := 0
var side := 0
var unit_id := ""
var actor: Node2D
var hp_frac := 1.0
var show_hp := false
var base_scale := 1.0
var current_row := ""
var _last_state := -1
var _last_x := -1.0
var _time := 0.0
var _attack_t := 0.0
var _boss := false
var slowed := false      # standing on a sand patch
var _height := 70.0 * K
var _die_time := 0.6
var _die_view_t := 0.0   # own clock so the fade-out still plays while the sim is stopped


func setup(u: SimUnit) -> void:
	uid = u.uid
	side = u.side
	unit_id = u.id
	_boss = u.is_boss
	_die_time = maxf(0.01, DataDB.bal_f("sim.die_time_s", 0.6))
	var facing := "right" if side == BattleSim.PLAYER else "left"
	actor = SpriteFactory.make_animated(u.id, facing)
	add_child(actor)
	_height = (110.0 if _boss else 70.0) * K
	var fh := 0.0
	var fs: Variant = actor.get("frame_size")
	if fs is Vector2i:
		fh = float((fs as Vector2i).y)
	base_scale = _height / fh if fh > 1.0 else 0.3
	actor.scale = Vector2(base_scale, base_scale)
	_last_x = u.x


## Small slow icon (a snail shell) above the unit while it stands on a sand patch.
func set_slowed(on: bool) -> void:
	if on != slowed:
		slowed = on
		queue_redraw()


func screen_height() -> float:
	return _height


## u: sim unit. sx/sy: screen position of the feet. dt: real seconds since the last call.
func update_from(u: SimUnit, sx: float, sy: float, dt := 0.0) -> void:
	position = Vector2(sx, sy)
	_time += dt
	var dir := 1.0 if side == BattleSim.PLAYER else -1.0
	var moved := absf(u.x - _last_x) > 0.001
	_last_x = u.x
	var row := "idle"
	match u.state:
		SimUnit.State.ATTACK:
			row = "attack"
		SimUnit.State.DIE:
			row = "defeat"
		_:
			row = "walk" if moved else "idle"
	if u.hit_flash > 0.0 and u.state == SimUnit.State.WALK:
		row = "hurt"
	if row != current_row:
		if row == "attack":
			_attack_t = 0.0
		current_row = row
		if actor.has_method("play_row"):
			actor.call("play_row", row, true)
	_last_state = u.state
	# Pose offsets so the placeholder still reads as walking / attacking.
	var pose := Vector2.ZERO
	if u.state == SimUnit.State.ATTACK:
		_attack_t += dt
		pose.x = dir * 8.0 * K * sin(clampf(_attack_t / 0.17, 0.0, 1.0) * PI)
	elif moved and u.state == SimUnit.State.WALK:
		pose.y = -absf(sin(_time * 10.0)) * 3.0 * K
	actor.position = pose
	# Tint: stun yellow, freeze cyan, hit flash bright, death fade.
	var tint := Color.WHITE
	if u.freeze > 0.0:
		tint = Color(0.55, 0.85, 1.25)
	elif u.stun > 0.0:
		tint = Color(1.25, 1.15, 0.45)
	if u.hit_flash > 0.0:
		tint = Color(1.6, 1.6, 1.6)
	if u.state == SimUnit.State.DIE:
		_die_view_t += dt
		tint.a = clampf(1.0 - maxf(u.die_t, _die_view_t) / _die_time, 0.0, 1.0)
	actor.modulate = tint
	hp_frac = clampf(u.hp / maxf(1.0, u.max_hp), 0.0, 1.0)
	show_hp = u.hp < u.max_hp - 0.01 and u.state != SimUnit.State.DIE
	queue_redraw()


func _draw() -> void:
	var a := actor.modulate.a if actor != null else 1.0
	var col := PLAYER_MARK if side == BattleSim.PLAYER else ENEMY_MARK
	col.a = a
	var edge := Color(0.1, 0.1, 0.1, a)
	# Side marker under the feet: blue circle for the player, red diamond for the enemy (shape + colour).
	if side == BattleSim.PLAYER:
		draw_circle(Vector2(0, MARKER_Y), 5.0 * K, col)
		draw_arc(Vector2(0, MARKER_Y), 5.0 * K, 0.0, TAU, 14, edge, 1.5 * K)
	else:
		var pts := PackedVector2Array([Vector2(0, MARKER_Y - 6 * K), Vector2(6 * K, MARKER_Y), Vector2(0, MARKER_Y + 6 * K), Vector2(-6 * K, MARKER_Y)])
		draw_colored_polygon(pts, col)
		pts.append(pts[0])
		draw_polyline(pts, edge, 1.5 * K)
	if slowed:
		var c := Vector2(0, MARKER_Y + 12.0 * K)
		draw_circle(c, 6.0 * K, Color(0.93, 0.75, 0.3, a))
		draw_arc(c, 6.0 * K, 0.0, TAU, 14, Color(0.4, 0.25, 0.05, a), 1.5 * K)
		draw_arc(c, 2.5 * K, 0.0, TAU * 0.8, 8, Color(0.4, 0.25, 0.05, a), 1.2 * K)
		draw_line(c + Vector2(-6, 6) * K, c + Vector2(9, 6) * K, Color(0.4, 0.25, 0.05, a), 2.0 * K)
	if show_hp:
		var w := (70.0 if _boss else 40.0) * K
		var r := Rect2(-w / 2.0, -_height - 10.0 * K, w, 5.0 * K)
		draw_rect(r.grow(1.5), Color(0, 0, 0, 0.7))
		draw_rect(Rect2(r.position, Vector2(w * hp_frac, r.size.y)), UI.GREEN if hp_frac > 0.35 else UI.RED)
