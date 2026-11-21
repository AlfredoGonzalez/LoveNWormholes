class_name SimUnit
extends RefCounted
## One fighter inside BattleSim. Plain data, no nodes: the presentation layer mirrors it.

enum State { WALK, ATTACK, HIT, DIE }

var uid := 0
var side := 0                 # BattleSim.PLAYER / BattleSim.ENEMY
var id := ""
var role := "fighter"
var max_hp := 1.0
var hp := 1.0
var damage := 0.0
var interval := 1.0
var range_px := 40.0
var speed := 60.0
var cost := 0.0
var is_air := false
var is_boss := false
var ranged := false
var abilities: Dictionary = {}
var flags: Dictionary = {}

var x := 0.0
var state: int = State.WALK
var atk_cd := 0.0
var windup := 0.0
var attack_target_uid := -1   # -1 none, -2 the enemy base, otherwise a unit uid
var stun := 0.0
var freeze := 0.0
var slow := 0.0               # 0..1 speed reduction applied this tick
var dmg_buff := 0.0           # additive damage bonus applied this tick
var first_hit_done := false
var hit_flash := 0.0
var die_t := 0.0
var age := 0.0
var phase2 := false
var telegraph_cd := 0.0
var telegraph_warn := 0.0
var extra_cd := 0.0           # phase 2 periodic effects


func alive() -> bool:
	return state != State.DIE


static func from_stats(stats: Dictionary, p_side: int, p_uid: int, p_x: float, range_threshold_px: float) -> SimUnit:
	var u := SimUnit.new()
	u.uid = p_uid
	u.side = p_side
	u.id = str(stats["id"])
	u.role = str(stats["role"])
	u.max_hp = float(stats["hp"])
	u.hp = u.max_hp
	u.damage = float(stats["damage"])
	u.interval = maxf(0.05, float(stats["interval"]))
	u.range_px = float(stats["range_px"])
	u.speed = float(stats["speed"])
	u.cost = float(stats.get("cost", 0.0))
	u.flags = (stats.get("flags", {}) as Dictionary).duplicate()
	u.abilities = (stats.get("abilities", {}) as Dictionary).duplicate()
	u.is_air = u.role == "air" or bool(u.flags.get("air", false)) or bool(stats.get("is_air", false))
	u.is_boss = bool(stats.get("is_boss", false))
	u.ranged = u.range_px >= range_threshold_px
	u.x = p_x
	return u
