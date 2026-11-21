class_name BattleSim
extends RefCounted
## Deterministic lane-battle simulation (spec 4, 8.4). No nodes, no rendering, no randomness:
## the same setup and the same inputs always give the same result, so x2 speed is just more ticks
## and the balance simulator can run it headless. The presentation layer reads `units`,
## `projectiles`, the bases and `drain_events()`.
##
## Setup dictionary (built by BattleSetup from DataDB, or by hand in tests):
##   player_base_hp, enemy_base_hp : float
##   food_start, food_income, food_cap : float
##   squad : Array of unit stats (DataDB.unit_stats output) in card order
##   enemy_units : Dictionary id -> stats (enemies and bosses; bosses carry is_boss = true)
##   boss_defs : Dictionary boss id -> {telegraph: {...}, phase2: {...}}
##   spawns : Array of {t: seconds, id: enemy/boss id} sorted by t (the director script)
##   powers : Array of {id, cooldown, effect: Dictionary} (DataDB.power_params output), slot order
##   rule : stage era rule, {type: "none"} or {type: "sand_patch", patches: [{x, w}, ...]} (x = left edge, lane px)

const PLAYER := 0
const ENEMY := 1
const SPAWN_CD_EPS := 0.0001

var dt := 1.0 / 30.0
var lane := 1000.0
var range_unit := 40.0
var time := 0.0
var tick_count := 0
var result := ""               # "" while running, then "win" or "lose"

var player_base_hp := 1000.0
var player_base_max := 1000.0
var enemy_base_hp := 1000.0
var enemy_base_max := 1000.0
var player_shield := 0.0       # Dirt Shield: remaining absorb
var player_shield_t := 0.0
var player_shield_max := 0.0   # size of the shield when it was cast (for the view)

var food := 0.0
var food_cap := 500.0
var food_income := 8.0
var _food_pool := 0.0          # Apple Rain food still to be delivered
var _food_pool_rate := 0.0

var units: Array = []          # Array[SimUnit], creation order (= uid order)
var projectiles: Array = []    # Array of Dictionary
var cards: Array = []          # {stats, cd}
var powers: Array = []         # {id, cooldown, effect, cd, stolen_t}
var events: Array = []
var rule: Dictionary = {"type": "none"}   # era rule of the stage (read by the view)
var patches: Array = []        # sand patches as {x, w} (left edge and width in lane px); empty unless rule is sand_patch
var _sand_slow := 0.0          # speed fraction lost on a patch (balance.json era_rules.sand_patch.slow_fraction)
var stats := {"kills": 0, "units_spawned": 0, "powers_used": 0, "player_losses": 0}

var _enemy_units: Dictionary = {}
var _boss_defs: Dictionary = {}
var _spawns: Array = []
var _spawn_i := 0
var _next_uid := 1
var _death_log: Array = []     # player deaths for Rewind: {t, stats, x}
var _enemy_speed_mult := 1.0
var _player_speed_mult := 1.0  # Fast-Forward (movement and attack speed)
var _player_haste_t := 0.0
var _global_slow := 0.0        # Sandstorm (boss phase 2): slows every unit of both sides
var _sandstorm_boss := 0
var _melee_px := 40.0
var _base_reach := 30.0
var _windup := 0.167
var _die_time := 0.6
var _proj_speed := 360.0
var _pop_cap := 40
var _overtime_after := 240.0
var _overtime_mult := 1.2
var _kill_food := 0.25
var _speed_scale := 1.0


func _init(setup: Dictionary) -> void:
	var b: Dictionary = DataDB.balance()
	dt = 1.0 / float(DataDB.bal_f("sim.ticks_per_second", 30.0))
	lane = DataDB.bal_f("sim.lane_length_px", 1000.0)
	range_unit = DataDB.bal_f("sim.range_unit_px", 40.0)
	_melee_px = range_unit * 1.5
	_base_reach = DataDB.bal_f("sim.base_reach_px", 30.0)
	_windup = DataDB.bal_f("sim.attack_windup_s", 0.167)
	_die_time = DataDB.bal_f("sim.die_time_s", 0.6)
	_proj_speed = DataDB.bal_f("sim.projectile_speed_px", 360.0)
	_pop_cap = DataDB.bal_i("battle.pop_cap_per_side", 40)
	_overtime_after = DataDB.bal_f("battle.overtime_after_seconds", 240.0)
	_overtime_mult = DataDB.bal_f("battle.overtime_attack_mult", 1.2)
	_kill_food = DataDB.bal_f("battle.kill_food_return", 0.25)
	if b.is_empty():
		push_error("BattleSim: balance data missing")
	player_base_max = float(setup.get("player_base_hp", 1000.0))
	player_base_hp = player_base_max
	enemy_base_max = float(setup.get("enemy_base_hp", 1000.0))
	enemy_base_hp = enemy_base_max
	food = float(setup.get("food_start", 100.0))
	food_income = float(setup.get("food_income", 8.0))
	food_cap = float(setup.get("food_cap", 500.0))
	for s in setup.get("squad", []):
		cards.append({"stats": s, "cd": 0.0})
	_enemy_units = setup.get("enemy_units", {})
	_boss_defs = setup.get("boss_defs", {})
	_spawns = setup.get("spawns", [])
	var r = setup.get("rule", {})
	if r is Dictionary and not (r as Dictionary).is_empty():
		rule = (r as Dictionary).duplicate(true)
	if str(rule.get("type", "none")) == "sand_patch":
		_sand_slow = DataDB.bal_f("era_rules.sand_patch.slow_fraction", 0.3)
		for pt in rule.get("patches", []):
			patches.append({"x": float(pt["x"]), "w": float(pt["w"])})
	for p in setup.get("powers", []):
		var pw: Dictionary = (p as Dictionary).duplicate(true)
		pw["cd"] = 0.0
		pw["stolen_t"] = 0.0
		powers.append(pw)


# ------------------------------------------------------------------ player inputs

func card_ready(i: int) -> bool:
	if result != "" or i < 0 or i >= cards.size():
		return false
	var c: Dictionary = cards[i]
	return c["cd"] <= SPAWN_CD_EPS and food >= float(c["stats"]["cost"]) and _alive_count(PLAYER) < _pop_cap


## Spend Food and put the unit on the field. The card then cools down (spec 4.2, decision 6).
func spawn_player(i: int) -> bool:
	if not card_ready(i):
		return false
	var c: Dictionary = cards[i]
	var st: Dictionary = c["stats"]
	food -= float(st["cost"])
	c["cd"] = float(st["spawn_cooldown"])
	var u := _add_unit(st, PLAYER)
	stats["units_spawned"] += 1
	_emit("spawn", {"uid": u.uid, "side": PLAYER, "id": u.id})
	return true


func power_ready(i: int) -> bool:
	if result != "" or i < 0 or i >= powers.size():
		return false
	var p: Dictionary = powers[i]
	return p["cd"] <= SPAWN_CD_EPS and p["stolen_t"] <= 0.0


## Casts the power in slot i. Returns false if it is cooling down or has nothing to act on.
func cast_power(i: int) -> bool:
	if not power_ready(i):
		return false
	var p: Dictionary = powers[i]
	var e: Dictionary = p["effect"]
	match str(p["id"]):
		"squirm_slam":
			var front := _front_enemy()
			if front == null:
				return false
			var radius := float(e.get("radius_units", 3.0)) * range_unit
			for u in units:
				if u.side == ENEMY and u.alive() and absf(u.x - front.x) <= radius:
					_damage_unit(u, float(e.get("damage", 0.0)), null, false, false)
					u.stun = maxf(u.stun, float(e.get("stun_seconds", 0.0)))
			_emit("power", {"id": "squirm_slam", "x": front.x, "radius": radius})
		"apple_rain":
			_food_pool += float(e.get("food", 0.0))
			_food_pool_rate = float(e.get("food", 0.0)) / maxf(0.1, float(e.get("duration_s", 5.0)))
			_emit("power", {"id": "apple_rain"})
		"time_freeze":
			for u in units:
				if u.side == ENEMY and u.alive():
					var d := float(e.get("boss_duration_s", 1.5)) if u.is_boss else float(e.get("duration_s", 3.0))
					u.freeze = maxf(u.freeze, d)
			_emit("power", {"id": "time_freeze"})
		"rewind":
			var window := float(e.get("window_s", 6.0))
			var revived := 0
			for d in _death_log:
				if time - float(d["t"]) <= window and _alive_count(PLAYER) < _pop_cap:
					var u := _add_unit(d["stats"], PLAYER, float(d["x"]))
					u.hp = u.max_hp * float(e.get("hp_fraction", 0.5))
					revived += 1
			_death_log.clear()
			_emit("power", {"id": "rewind", "revived": revived})
		"dirt_shield":
			player_shield = player_base_max * float(e.get("absorb_fraction", 0.25))
			player_shield_max = player_shield
			player_shield_t = float(e.get("duration_s", 8.0))
			_emit("power", {"id": "dirt_shield"})
		"fast_forward":
			_player_speed_mult = 1.0 + float(e.get("speed_bonus", 0.3))
			_player_haste_t = float(e.get("duration_s", 8.0))
			_emit("power", {"id": "fast_forward"})
		_:
			return false
	p["cd"] = float(p["cooldown"])
	stats["powers_used"] += 1
	return true


# ------------------------------------------------------------------ main loop

func run(seconds: float) -> void:
	var n := int(ceil(seconds / dt))
	for _i in n:
		if result != "":
			return
		tick()


func tick() -> void:
	if result != "":
		return
	tick_count += 1
	time += dt
	_update_economy()
	_director()
	_reset_auras()
	_apply_auras()
	for u in units:
		_update_unit(u)
	_update_projectiles()
	_boss_logic()
	_cleanup()
	_check_end()


## Second Wind (rewarded ad): the player base comes back with `fraction` of its max HP and the battle goes on.
func revive_base(fraction: float) -> void:
	if result != "lose":
		return
	player_base_hp = player_base_max * clampf(fraction, 0.01, 1.0)
	result = ""
	_emit("revived", {"fraction": fraction})


func drain_events() -> Array:
	var out := events
	events = []
	return out


# ------------------------------------------------------------------ economy and timers

func _update_economy() -> void:
	food = minf(food_cap, food + food_income * dt)
	if _food_pool > 0.0:
		var add := minf(_food_pool, _food_pool_rate * dt)
		_food_pool -= add
		food = minf(food_cap, food + add)
	for c in cards:
		c["cd"] = maxf(0.0, float(c["cd"]) - dt)
	for p in powers:
		p["cd"] = maxf(0.0, float(p["cd"]) - dt)
		p["stolen_t"] = maxf(0.0, float(p["stolen_t"]) - dt)
	if player_shield_t > 0.0:
		player_shield_t -= dt
		if player_shield_t <= 0.0:
			player_shield = 0.0
	if _player_haste_t > 0.0:
		_player_haste_t -= dt
		if _player_haste_t <= 0.0:
			_player_speed_mult = 1.0


func _director() -> void:
	while _spawn_i < _spawns.size() and float(_spawns[_spawn_i]["t"]) <= time:
		if _alive_count(ENEMY) >= _pop_cap:
			return
		var id := str(_spawns[_spawn_i]["id"])
		_spawn_i += 1
		if not _enemy_units.has(id):
			continue
		var u := _add_unit(_enemy_units[id], ENEMY)
		if u.is_boss:
			u.telegraph_cd = DataDB.bal_f("boss.telegraph_interval_s", 10.0)
		_emit("spawn", {"uid": u.uid, "side": ENEMY, "id": u.id, "boss": u.is_boss})


func _add_unit(st: Dictionary, side: int, at_x := -1.0) -> SimUnit:
	var spawn_x := 30.0 if side == PLAYER else lane - 30.0
	if at_x >= 0.0:
		spawn_x = at_x
	var u := SimUnit.from_stats(st, side, _next_uid, spawn_x, _melee_px)
	_next_uid += 1
	units.append(u)
	return u


# ------------------------------------------------------------------ auras (support roles, spec 4.4)

func _reset_auras() -> void:
	for u in units:
		u.dmg_buff = 0.0
		u.slow = 0.0
		u.in_sand = _on_sand(u.x)


func _apply_auras() -> void:
	for s in units:
		if not s.alive() or s.freeze > 0.0:
			continue
		var ab: Dictionary = s.abilities
		if ab.has("damage_aura"):
			for a in units:
				if a.side == s.side and a.alive() and absf(a.x - s.x) <= s.range_px:
					a.dmg_buff = maxf(a.dmg_buff, float(ab["damage_aura"]))
		if ab.has("heal_fraction_per_sec"):
			for a in units:
				if a.side == s.side and a.alive() and a != s and absf(a.x - s.x) <= s.range_px:
					a.hp = minf(a.max_hp, a.hp + a.max_hp * float(ab["heal_fraction_per_sec"]) * dt)
		if ab.has("slow_fraction"):
			for e in units:
				if e.side != s.side and e.alive() and absf(e.x - s.x) <= s.range_px:
					e.slow = maxf(e.slow, float(ab["slow_fraction"]))


# ------------------------------------------------------------------ unit behaviour

func _update_unit(u: SimUnit) -> void:
	u.age += dt
	u.hit_flash = maxf(0.0, u.hit_flash - dt)
	if u.state == SimUnit.State.DIE:
		u.die_t += dt
		return
	if u.stun > 0.0:
		u.stun -= dt
		return
	if u.freeze > 0.0:
		u.freeze -= dt
		return
	var haste := _player_speed_mult if u.side == PLAYER else 1.0
	u.atk_cd = maxf(0.0, u.atk_cd - dt * haste)
	if u.state == SimUnit.State.ATTACK:
		u.windup -= dt * haste
		if u.windup <= 0.0:
			_resolve_attack(u)
			u.state = SimUnit.State.WALK
		return
	if u.damage <= 0.0 and u.role == "support":
		_walk(u, true)
		return
	var tgt := _pick_target(u)
	if tgt == 0:   # nothing in range
		u.attack_target_uid = -1
		_walk(u, false)
		return
	u.attack_target_uid = tgt if tgt != -2 else -2
	if u.atk_cd <= 0.0:
		u.state = SimUnit.State.ATTACK
		u.windup = _windup
		u.atk_cd = u.interval


func _walk(u: SimUnit, support: bool) -> void:
	# Supports keep walking until the enemy base is in their range (they never attack it).
	var dir := 1.0 if u.side == PLAYER else -1.0
	var enemy_base_x := lane if u.side == PLAYER else 0.0
	if absf(enemy_base_x - u.x) <= u.range_px + _base_reach and not support:
		return
	if support and absf(enemy_base_x - u.x) <= 60.0 + _base_reach:
		return
	var spd := u.speed * (1.0 - clampf(u.slow, 0.0, 0.9)) * (1.0 - _global_slow)
	if u.in_sand:
		spd *= 1.0 - _sand_slow
	if u.side == PLAYER:
		spd *= _player_speed_mult
	else:
		spd *= _enemy_speed_mult
	u.x = clampf(u.x + dir * spd * dt, 0.0, lane)


## Returns a unit uid, -2 for the enemy base, or 0 when nothing is in range.
func _pick_target(u: SimUnit) -> int:
	var best: SimUnit = null
	var best_score := -1.0e9
	for e in units:
		if e.side == u.side or not e.alive():
			continue
		if e.is_air and not _can_hit_air(u):
			continue
		var d := absf(e.x - u.x)
		if d > u.range_px:
			continue
		var score := -d
		var pri := str(u.abilities.get("target_priority", ""))
		if str(u.abilities.get("target", "")) == "highest_hp":
			score = e.hp * 10.0 - d * 0.001
		elif pri != "" and e.role == pri:
			score = 1.0e6 - d
		elif e.role == "support":
			score = 5.0e5 - d
		elif e.role == "shooter":
			score = 2.5e5 - d
		if score > best_score:
			best_score = score
			best = e
	if best != null:
		return best.uid
	var base_x := lane if u.side == PLAYER else 0.0
	if absf(base_x - u.x) <= u.range_px + _base_reach:
		return -2
	return 0


func _can_hit_air(u: SimUnit) -> bool:
	return DataDB.can_hit(u.role, true)


func _resolve_attack(u: SimUnit) -> void:
	var t := _find(u.attack_target_uid)
	var to_base := u.attack_target_uid == -2
	if not to_base and (t == null or not t.alive() or absf(t.x - u.x) > u.range_px * 1.25):
		# The target died or left during the wind-up: look again right away.
		var again := _pick_target(u)
		if again == 0:
			return
		to_base = again == -2
		t = _find(again) if again > 0 else null
	var raw := u.damage * (1.0 + u.dmg_buff)
	if u.side == ENEMY and time >= _overtime_after:
		raw *= _overtime_mult
	if not u.first_hit_done:
		u.first_hit_done = true
		raw *= 1.0 + float(u.abilities.get("first_hit_bonus", 0.0))
	if u.ranged:
		var tx := lane if (to_base and u.side == PLAYER) else (0.0 if to_base else t.x)
		var travel := absf(tx - u.x) / _proj_speed
		projectiles.append({"side": u.side, "x0": u.x, "x1": tx, "t": 0.0, "dur": maxf(0.05, travel),
				"target": -2 if to_base else t.uid, "damage": raw, "role": u.role, "src": u.uid})
		_emit("shot", {"uid": u.uid, "x": u.x})
	else:
		_apply_hit(u, t, to_base, raw)
	if u.ranged and not to_base and u.abilities.has("jump_back_units"):
		_jump_back(u, float(u.abilities["jump_back_units"]))
	if u.abilities.has("splash_radius_units") and t != null:
		var r := float(u.abilities["splash_radius_units"]) * range_unit
		for o in units:
			if o != t and o.side != u.side and o.alive() and not o.is_air and absf(o.x - t.x) <= r:
				_damage_unit(o, raw * 0.5, u, false, true)


## Locust Archer: after shooting it hops back `units` range units, away from the enemy, never past its own
## base side (the spawn point of its side).
func _jump_back(u: SimUnit, units_back: float) -> void:
	var dir := -1.0 if u.side == PLAYER else 1.0
	var limit_lo := 30.0 if u.side == PLAYER else 0.0
	var limit_hi := lane if u.side == PLAYER else lane - 30.0
	var from := u.x
	u.x = clampf(u.x + dir * units_back * range_unit, limit_lo, limit_hi)
	if absf(u.x - from) > 0.0:
		_emit("jump_back", {"uid": u.uid, "x": from, "to": u.x})


func _on_sand(x: float) -> bool:
	for pt in patches:
		if x >= float(pt["x"]) and x <= float(pt["x"]) + float(pt["w"]):
			return true
	return false


func _apply_hit(src: SimUnit, tgt: SimUnit, to_base: bool, raw: float, ranged := false) -> void:
	if to_base:
		_damage_base(1 - src.side, raw, src.x)
	elif tgt != null and tgt.alive():
		_damage_unit(tgt, raw, src, ranged, true)


func _update_projectiles() -> void:
	var keep: Array = []
	for p in projectiles:
		p["t"] += dt
		if p["t"] < p["dur"]:
			keep.append(p)
			continue
		var src := _find(int(p["src"]))
		if int(p["target"]) == -2:
			_damage_base(1 - int(p["side"]), float(p["damage"]), float(p["x1"]))
		else:
			var tgt := _find(int(p["target"]))
			if tgt != null and tgt.alive():
				_damage_unit(tgt, float(p["damage"]), src, true, true)
	projectiles = keep


# ------------------------------------------------------------------ damage

func _damage_unit(tgt: SimUnit, raw: float, src: SimUnit, ranged: bool, use_counter: bool) -> void:
	if not tgt.alive():
		return
	var d := raw
	if use_counter and src != null:
		d *= DataDB.counter_multiplier(src.role, tgt.role)
	if ranged and tgt.abilities.has("block_ranged_fraction"):
		d *= 1.0 - float(tgt.abilities["block_ranged_fraction"])
	if tgt.abilities.has("frontal_armor_fraction") and src != null and absf(src.x - tgt.x) > 0.0:
		var from_front := (src.x > tgt.x) == (tgt.side == PLAYER)
		if from_front:
			d *= 1.0 - float(tgt.abilities["frontal_armor_fraction"])
	tgt.hp -= d
	tgt.hit_flash = 0.12
	_emit("hit", {"uid": tgt.uid, "damage": d, "x": tgt.x})
	if tgt.hp <= 0.0:
		tgt.hp = 0.0
		tgt.state = SimUnit.State.DIE
		tgt.die_t = 0.0
		tgt.attack_target_uid = -1
		_emit("death", {"uid": tgt.uid, "side": tgt.side, "id": tgt.id, "x": tgt.x})
		if tgt.side == ENEMY:
			stats["kills"] += 1
			food = minf(food_cap, food + tgt.cost * _kill_food)
		else:
			stats["player_losses"] += 1
			var st := _stats_for_player_unit(tgt.id)
			if not st.is_empty():
				_death_log.append({"t": time, "stats": st, "x": tgt.x})


func _damage_base(side: int, raw: float, x: float) -> void:
	var d := raw
	if side == PLAYER:
		if player_shield > 0.0:
			var absorbed := minf(player_shield, d)
			player_shield -= absorbed
			d -= absorbed
		player_base_hp = maxf(0.0, player_base_hp - d)
	else:
		enemy_base_hp = maxf(0.0, enemy_base_hp - d)
	_emit("base_hit", {"side": side, "damage": d, "x": x})


func _stats_for_player_unit(id: String) -> Dictionary:
	for c in cards:
		if str(c["stats"]["id"]) == id:
			return c["stats"]
	return {}


# ------------------------------------------------------------------ bosses (spec 4.7, 5.3)

func _boss_logic() -> void:
	if _sandstorm_boss > 0:
		var sb := _find(_sandstorm_boss)
		if sb == null or not sb.alive():
			_global_slow = 0.0   # the storm dies with the Pharaoh
			_sandstorm_boss = 0
	for u in units:
		if not u.is_boss or not u.alive():
			continue
		var def: Dictionary = _boss_defs.get(u.id, {})
		if def.is_empty() or u.stun > 0.0 or u.freeze > 0.0:
			continue
		if not u.phase2 and u.hp <= u.max_hp * DataDB.bal_f("boss.phase2_hp_fraction", 0.5):
			u.phase2 = true
			var p2: Dictionary = def.get("phase2", {})
			match str(p2.get("id", "")):
				"roar":
					_enemy_speed_mult = float(p2.get("enemy_speed_mult", 1.2))
				"sandstorm":
					_global_slow = float(p2.get("slow_fraction", 0.3))
					_sandstorm_boss = u.uid
				"take_flight":
					u.is_air = true
			_emit("phase2", {"uid": u.uid, "id": str(p2.get("id", ""))})
		u.telegraph_cd -= dt
		var warn := DataDB.bal_f("boss.telegraph_warning_s", 1.5)
		if u.telegraph_warn <= 0.0 and u.telegraph_cd <= warn and u.telegraph_cd > 0.0:
			u.telegraph_warn = warn
			_emit("telegraph", {"uid": u.uid, "x": u.x, "id": str((def.get("telegraph", {}) as Dictionary).get("id", ""))})
		if u.telegraph_cd <= 0.0:
			u.telegraph_cd = DataDB.bal_f("boss.telegraph_interval_s", 10.0)
			u.telegraph_warn = 0.0
			_boss_attack(u, def.get("telegraph", {}))


func _boss_attack(boss: SimUnit, t: Dictionary) -> void:
	match str(t.get("id", "")):
		"stomp":
			var reach := float(t.get("reach_units", 3.0)) * range_unit
			for a in units:
				if a.side == PLAYER and a.alive() and absf(a.x - boss.x) <= reach:
					a.stun = maxf(a.stun, float(t.get("stun_seconds", 1.0)))
			_emit("boss_attack", {"uid": boss.uid, "id": "stomp", "x": boss.x, "reach": reach})
		"summon":
			var eid := str(t.get("enemy", ""))
			if _enemy_units.has(eid):
				for _i in int(t.get("count", 1)):
					if _alive_count(ENEMY) < _pop_cap:
						_add_unit(_enemy_units[eid], ENEMY, boss.x)
			_emit("boss_attack", {"uid": boss.uid, "id": "summon", "x": boss.x})
		_:
			_emit("boss_attack", {"uid": boss.uid, "id": str(t.get("id", "")), "x": boss.x})


# ------------------------------------------------------------------ helpers

func _cleanup() -> void:
	var keep: Array = []
	for u in units:
		if u.state == SimUnit.State.DIE and u.die_t >= _die_time:
			continue
		keep.append(u)
	units = keep


func _check_end() -> void:
	if enemy_base_hp <= 0.0:
		result = "win"
		_emit("result", {"result": "win"})
	elif player_base_hp <= 0.0:
		result = "lose"
		_emit("result", {"result": "lose"})


func _alive_count(side: int) -> int:
	var n := 0
	for u in units:
		if u.side == side and u.alive():
			n += 1
	return n


func _find(uid: int) -> SimUnit:
	if uid <= 0:
		return null
	for u in units:
		if u.uid == uid:
			return u
	return null


## The enemy closest to the player base (the front of the enemy army).
func _front_enemy() -> SimUnit:
	var best: SimUnit = null
	for u in units:
		if u.side == ENEMY and u.alive() and (best == null or u.x < best.x):
			best = u
	return best


func alive_units(side: int) -> Array:
	var out: Array = []
	for u in units:
		if u.side == side and u.alive():
			out.append(u)
	return out


func _emit(type: String, data: Dictionary) -> void:
	data["type"] = type
	data["t"] = time
	events.append(data)
