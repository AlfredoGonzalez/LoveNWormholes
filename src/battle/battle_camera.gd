class_name BattleCamera
extends RefCounted
## Horizontal battle camera. It FOLLOWS the action (a target x computed from the front of the player's units and
## the nearest enemy) and can be DRAGGED: a drag (inertia from HomeCamera) takes manual control and the follow
## resumes MANUAL_HOLD seconds after the last touch, easing back smoothly. Deterministic: only step() advances it.
## x = world px of the left edge of the view, in [0, max_x].

const MANUAL_HOLD := 3.0       ## seconds without touching before the camera follows again
const FOLLOW_RATE := 4.0       ## follow easing (1/s): x += (target - x) * (1 - exp(-rate * dt))
const LEAD := 70.0             ## the leader is shown this far left of the view centre (see what is ahead)
const SPAN_FULL := 280.0       ## leader-enemy distance up to which the view centres between them
const SPAN_NONE := 400.0       ## beyond this the enemy is ignored (blends linearly in between)
const DRAG_THRESHOLD := 8.0    ## px before a press becomes a drag

var drag: HomeCamera           ## position + inertia holder (no overscroll here)
var view_w := 540.0
var manual := false
var manual_t := 0.0            ## seconds since the last manual input
var _focus_x := 0.0
var _focus_t := 0.0


func _init(p_world_w := BattleWorld.WORLD_W, p_view_w := BattleWorld.SCREEN_W) -> void:
	view_w = p_view_w
	drag = HomeCamera.new(maxf(0.0, p_world_w - p_view_w), 0.0)


var x: float:
	get:
		return drag.x
	set(v):
		drag.x = clampf(v, 0.0, drag.max_x)


var max_x: float:
	get:
		return drag.max_x


func is_dragging() -> bool:
	return drag.dragging


## Screen x of a parallax layer's left edge (layer-local 0) for a factor; factor 1.0 = the world itself.
func layer_x(factor: float) -> float:
	return -drag.x * factor


## Camera x that centres world x `wx`, clamped.
func x_for_center(wx: float) -> float:
	return clampf(wx - view_w * 0.5, 0.0, drag.max_x)


## Follow target (camera x) from the leading player x and the nearest enemy x (< 0 = none), world px.
static func target_for(leader_x: float, enemy_x: float, view := BattleWorld.SCREEN_W, max_cam := BattleWorld.MAX_CAM) -> float:
	var center := leader_x + LEAD
	if enemy_x >= 0.0:
		var d := absf(enemy_x - leader_x)
		var w := clampf((SPAN_NONE - d) / (SPAN_NONE - SPAN_FULL), 0.0, 1.0)
		center = lerpf(center, (leader_x + enemy_x) * 0.5, w)
	return clampf(center - view * 0.5, 0.0, max_cam)


## Instant jump to a camera x; back to following.
func recenter(target_x: float) -> void:
	drag.vel = 0.0
	drag.dragging = false
	drag.x = clampf(target_x, 0.0, drag.max_x)
	manual = false
	manual_t = 0.0
	_focus_t = 0.0


## Brief pan to a world x (boss telegraph, a base falling). `force` also overrides manual control.
func focus(world_x: float, seconds: float, force := false) -> void:
	if manual and not force:
		return
	if force:
		manual = false
		drag.vel = 0.0
	_focus_x = world_x
	_focus_t = seconds


func begin_drag() -> void:
	drag.begin_drag()
	manual = true
	manual_t = 0.0
	_focus_t = 0.0


func drag_move(finger_dx: float) -> void:
	drag.drag_move(finger_dx)
	manual_t = 0.0


func end_drag() -> void:
	drag.end_drag()
	manual_t = 0.0


## Radar / direct control: centre the view on world x and keep manual control for MANUAL_HOLD.
func pan_to_center(world_x: float) -> void:
	drag.vel = 0.0
	drag.x = x_for_center(world_x)
	manual = true
	manual_t = 0.0
	_focus_t = 0.0


## Advances by dt. `target_x` = follow target (camera x) from the screen.
func step(dt: float, target_x: float) -> void:
	if dt <= 0.0:
		return
	if drag.dragging:
		manual_t = 0.0
		drag.step(dt)
		return
	if manual:
		drag.step(dt)   # inertia
		manual_t += dt
		if manual_t < MANUAL_HOLD:
			return
		manual = false
		drag.vel = 0.0
	var tx := target_x
	if _focus_t > 0.0:
		_focus_t -= dt
		tx = x_for_center(_focus_x)
	var k := 1.0 - exp(-FOLLOW_RATE * dt)
	drag.x = clampf(drag.x + (tx - drag.x) * k, 0.0, drag.max_x)
