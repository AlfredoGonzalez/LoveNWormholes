class_name HomeCamera
extends RefCounted
## Horizontal camera of the sliding Home: position x in [0, max_x] (a soft overscroll of `over` px on each side),
## drag with inertia and spring-back. Deterministic: only step(dt) advances it. Layers read layer_x(factor).

const FRICTION := 3.5          ## inertia decay rate (1/s): velocity *= exp(-FRICTION * dt)
const STOP_SPEED := 8.0        ## px/s below which the inertia stops
const SPRING_K := 220.0        ## edge spring stiffness
const SPRING_C := 26.0         ## edge spring damping (about critical)
const EDGE_RESIST := 0.4       ## drag gain while past an edge
const VEL_SMOOTH := 0.5        ## blend of the new sample into the drag velocity
const MAX_SPEED := 6000.0

var max_x := 0.0
var over := 60.0
var x := 0.0
var vel := 0.0
var dragging := false
var _acc := 0.0                ## camera movement accumulated by drag_move since the last step


func _init(p_max_x := 0.0, p_over := 60.0) -> void:
	max_x = maxf(0.0, p_max_x)
	over = maxf(0.0, p_over)


## Screen x of a layer's left edge for a parallax factor (layer-local x 0 sits at screen -(x + over) * factor).
func layer_x(factor: float) -> float:
	return -(x + over) * factor


func overscrolled() -> bool:
	return x < 0.0 or x > max_x


func begin_drag() -> void:
	dragging = true
	vel = 0.0
	_acc = 0.0


## `finger_dx`: finger movement in px; the world follows the finger, so the camera moves the opposite way.
func drag_move(finger_dx: float) -> void:
	var gain := EDGE_RESIST if overscrolled() else 1.0
	var nx := clampf(x - finger_dx * gain, -over, max_x + over)
	_acc += nx - x
	x = nx


func end_drag() -> void:
	dragging = false


func step(dt: float) -> void:
	if dt <= 0.0:
		return
	if dragging:
		vel = clampf(lerpf(vel, _acc / dt, VEL_SMOOTH), -MAX_SPEED, MAX_SPEED)
		_acc = 0.0
		return
	if overscrolled():
		var bound := 0.0 if x < 0.0 else max_x
		vel += (-SPRING_K * (x - bound) - SPRING_C * vel) * dt
		x += vel * dt
		if absf(x - bound) < 0.05 and absf(vel) < 1.0:
			x = bound
			vel = 0.0
	else:
		vel *= exp(-FRICTION * dt)
		if absf(vel) < STOP_SPEED:
			vel = 0.0
		x += vel * dt
	x = clampf(x, -over, max_x + over)
