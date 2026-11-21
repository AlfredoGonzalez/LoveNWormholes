class_name RuleLayer
extends Node2D
## Draws the stage rule on the lane (placeholder art): Era 2 sand patches as sandy translucent strips, and the
## other rule types (walls, steam vents, gravity wells) as simple tinted zones. Reads the sim defensively:
## `sim.rule` (Dictionary with `type`) and `sim.patches` (Array of {x, w} in lane px) may not exist yet or
## may hold unknown types; nothing here ever crashes on that.

const SAND := Color(0.93, 0.78, 0.40, 0.55)
const SAND_EDGE := Color(0.62, 0.45, 0.15, 0.8)
const ZONE_TINTS := {
	"sand_patch": Color(0.93, 0.78, 0.40, 0.55),
	"walls": Color(0.55, 0.55, 0.6, 0.5),
	"steam_vent": Color(0.85, 0.95, 1.0, 0.45),
	"gravity_well": Color(0.55, 0.3, 0.85, 0.4),
}
## Other zone arrays a rule may expose, by the tint they get (entries are {x, w}; w defaults to DEFAULT_W).
const ZONE_FIELDS := {"walls": "walls", "vents": "steam_vent", "steam_vents": "steam_vent", "wells": "gravity_well", "gravity_wells": "gravity_well"}
const DEFAULT_W := 36.0

var x0 := 70.0
var px_scale := 0.4
var lane_y := 557.0
var rule_type := "none"
var zones: Array = []   # [{x, w, kind}] in sim px
var _t := 0.0


func setup(p_x0: float, p_scale: float, p_lane_y: float) -> void:
	x0 = p_x0
	px_scale = p_scale
	lane_y = p_lane_y
	name = "RuleLayer"


## sim.rule, tolerant of a missing field. Always a Dictionary.
static func rule_of(sim) -> Dictionary:
	if sim == null:
		return {}
	var r: Variant = sim.get("rule")
	return (r as Dictionary) if r is Dictionary else {}


## sim.patches, tolerant: only well-formed {x, w} entries with w > 0 are kept.
static func patches_of(sim) -> Array:
	var out: Array = []
	if sim == null:
		return out
	var p: Variant = sim.get("patches")
	if p is Array:
		for e in p:
			if e is Dictionary and (e as Dictionary).has("x") and float((e as Dictionary).get("w", 0.0)) > 0.0:
				out.append(e)
	return out


static func on_patch(patches: Array, x: float) -> bool:
	for e in patches:
		var px := float(e["x"])
		if x >= px and x <= px + float(e["w"]):
			return true
	return false


func sync(sim) -> void:
	var r := rule_of(sim)
	var t := str(r.get("type", "none"))
	var z: Array = []
	for e in patches_of(sim):
		z.append({"x": float(e["x"]), "w": float(e["w"]), "kind": "sand_patch"})
	for field in ZONE_FIELDS:
		var arr: Variant = r.get(field)
		if arr is Array:
			for e in arr:
				if e is Dictionary and (e as Dictionary).has("x"):
					z.append({"x": float(e["x"]), "w": float(e.get("w", DEFAULT_W)), "kind": str(ZONE_FIELDS[field])})
	if t != rule_type or z.size() != zones.size() or str(z) != str(zones):
		rule_type = t
		zones = z
		queue_redraw()
	if rule_type == "steam_vent" or rule_type == "gravity_well":
		queue_redraw()   # these pulse


func _process(delta: float) -> void:
	_t += delta


func _draw() -> void:
	for z in zones:
		var kind := str(z["kind"])
		var tint: Color = ZONE_TINTS.get(kind, Color(1, 0, 1, 0.25))   # unknown types: neutral magenta tint, no crash
		var sx := x0 + float(z["x"]) * px_scale
		var w := maxf(2.0, float(z["w"]) * px_scale)
		var r := Rect2(sx, lane_y - 38.0, w, 76.0)
		if kind == "gravity_well" or kind == "steam_vent":
			tint.a *= 0.75 + 0.25 * sin(_t * 4.0)
		draw_rect(r, tint)
		if kind == "sand_patch":
			draw_rect(r, SAND_EDGE, false, 2.0)
			var d := 10.0
			var y := r.position.y + 8.0
			while y < r.end.y - 4.0:
				var xx := r.position.x + 6.0 + fmod(y * 1.7, maxf(8.0, w - 12.0))
				draw_circle(Vector2(xx, y), 1.6, SAND_EDGE)
				y += d
		else:
			draw_rect(r, Color(tint.r, tint.g, tint.b, 0.9), false, 2.0)
