class_name BattleEffects
extends Node2D
## All transient battle visuals in ONE node drawn with _draw (no node churn): floating damage numbers,
## hit sparks, puffs, rings (squirm slam, stomp), boss warning icons, screen flashes, apple rain and the
## projectile dots. Time advances only through advance(dt), so pausing the battle freezes it.

const MAX_FX := 160

var fx: Array = []
var projectiles: Array = []     # [{pos: Vector2, side: int}] set by the screen every frame
var flash_rect := Rect2(0, 0, 540, 960)
var _rain_t := 0.0
var _rain_dur := 0.0
var _rain_span := Vector2.ZERO  # x0, x1
var _rain_y := Vector2.ZERO     # top, ground
var _rain_acc := 0.0


func count() -> int:
	return fx.size()


func count_kind(kind: String) -> int:
	var n := 0
	for e in fx:
		if e["k"] == kind:
			n += 1
	return n


func clear_all() -> void:
	fx.clear()
	projectiles = []
	_rain_t = 0.0
	queue_redraw()


func _push(e: Dictionary) -> void:
	if fx.size() >= MAX_FX:
		fx.pop_front()
	e["t"] = 0.0
	fx.append(e)


func add_number(pos: Vector2, text: String, color: Color = Color.WHITE) -> void:
	_push({"k": "num", "p": pos, "s": text, "c": color, "d": 0.7})


func add_spark(pos: Vector2, color: Color = Color(1, 0.9, 0.4)) -> void:
	_push({"k": "spark", "p": pos, "c": color, "d": 0.25})


func add_puff(pos: Vector2, color: Color = Color(1, 1, 1, 0.8)) -> void:
	_push({"k": "puff", "p": pos, "c": color, "d": 0.45})


func add_ring(pos: Vector2, radius: float, color: Color, dur := 0.5) -> void:
	_push({"k": "ring", "p": pos, "r": radius, "c": color, "d": dur})


func add_warning(pos: Vector2, dur := 1.5) -> void:
	_push({"k": "warn", "p": pos, "d": dur})


func add_flash(color: Color, dur := 0.5) -> void:
	_push({"k": "flash", "c": color, "d": dur})


func add_text_burst(pos: Vector2, text: String, color: Color, dur := 1.0) -> void:
	_push({"k": "num", "p": pos, "s": text, "c": color, "d": dur})


func start_rain(x0: float, x1: float, y_top: float, y_ground: float, duration: float) -> void:
	_rain_t = duration
	_rain_dur = duration
	_rain_span = Vector2(x0, x1)
	_rain_y = Vector2(y_top, y_ground)


func advance(dt: float) -> void:
	if _rain_t > 0.0:
		_rain_t -= dt
		_rain_acc += dt * 14.0
		while _rain_acc >= 1.0:
			_rain_acc -= 1.0
			var rx := randf_range(_rain_span.x, _rain_span.y)
			_push({"k": "apple", "p": Vector2(rx, _rain_y.x), "g": _rain_y.y - randf_range(0.0, 14.0), "d": 0.55})
	var keep: Array = []
	for e in fx:
		e["t"] = float(e["t"]) + dt
		if float(e["t"]) < float(e["d"]):
			keep.append(e)
	fx = keep
	queue_redraw()


func _draw() -> void:
	var font := ThemeDB.fallback_font
	for e in fx:
		var f := clampf(float(e["t"]) / float(e["d"]), 0.0, 1.0)
		match str(e["k"]):
			"num":
				var p: Vector2 = e["p"] + Vector2(0, -34.0 * f)
				var c: Color = e["c"]
				c.a = 1.0 - f * f
				draw_string_outline(font, p, str(e["s"]), HORIZONTAL_ALIGNMENT_CENTER, 120.0, 18, 5, Color(0, 0, 0, c.a))
				draw_string(font, p - Vector2(0, 0), str(e["s"]), HORIZONTAL_ALIGNMENT_CENTER, 120.0, 18, c)
			"spark":
				var c2: Color = e["c"]
				c2.a = 1.0 - f
				var p2: Vector2 = e["p"]
				var r := 6.0 + 10.0 * f
				for i in 4:
					var ang := PI / 4.0 + float(i) * PI / 2.0
					draw_line(p2 + Vector2(cos(ang), sin(ang)) * r * 0.4, p2 + Vector2(cos(ang), sin(ang)) * r, c2, 2.0)
			"puff":
				var c3: Color = e["c"]
				c3.a *= 1.0 - f
				draw_circle(e["p"], 6.0 + 14.0 * f, c3)
			"ring":
				var c4: Color = e["c"]
				c4.a = 0.8 * (1.0 - f)
				var rad := float(e["r"]) * (0.25 + 0.75 * f)
				draw_arc(e["p"], rad, 0.0, TAU, 40, c4, 5.0)
				c4.a *= 0.35
				draw_circle(e["p"], rad, c4)
			"warn":
				var p5: Vector2 = e["p"]
				var pulse := 0.75 + 0.25 * sin(float(e["t"]) * 14.0)
				var s := 22.0 * pulse
				var tri := PackedVector2Array([p5 + Vector2(0, -s), p5 + Vector2(s, s * 0.8), p5 + Vector2(-s, s * 0.8)])
				draw_colored_polygon(tri, Color(1.0, 0.8, 0.1))
				var tri2 := tri.duplicate()
				tri2.append(tri[0])
				draw_polyline(tri2, Color(0.55, 0.1, 0.05), 3.0)
				draw_string(font, p5 + Vector2(-20, s * 0.55), "!", HORIZONTAL_ALIGNMENT_CENTER, 40.0, int(s * 1.2), Color(0.55, 0.1, 0.05))
			"flash":
				var c6: Color = e["c"]
				c6.a *= 0.5 * (1.0 - f)
				draw_rect(flash_rect, c6)
			"apple":
				var p7: Vector2 = e["p"]
				var y := lerpf(p7.y, float(e["g"]), f)
				draw_circle(Vector2(p7.x, y), 6.0, Color("D9362B"))
				draw_line(Vector2(p7.x, y - 6), Vector2(p7.x + 2, y - 10), UI.BORDER, 2.0)
	for pr in projectiles:
		var col: Color = UI.BLUE.lightened(0.3) if int(pr["side"]) == BattleSim.PLAYER else UI.RED.lightened(0.2)
		draw_circle(pr["pos"], 5.0, col)
		draw_arc(pr["pos"], 5.0, 0.0, TAU, 12, Color(0.1, 0.1, 0.1), 1.5)
