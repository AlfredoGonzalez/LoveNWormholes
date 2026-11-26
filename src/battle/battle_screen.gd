class_name BattleScreen
extends Screen
## The battle screen (spec 4, 8.4, 9.1 rows 6-7, 9.3). It builds a BattleSim from the stage and the
## player's levels, runs it on a fixed timestep and PRESENTS it: sprites, bases, HUD, effects, audio and
## analytics. It never decides game rules and never pays rewards (the result screen does).
##
## params: {era, stage, squad: [unit ids], powers: [power ids], food_boost: bool, resume: bool}
##   resume: true continues Game.last_sim with the player base at ads.second_wind_base_hp_fraction.
## Tests drive it without a frame loop: step(delta), press_card(i), press_power(i), pause(), resume_play().

signal battle_finished(result_params: Dictionary)   ## right before navigating to "result"
signal battle_left(kind: String)                     ## "quit" or "restart" (counts as a lost attempt)

const SCREEN_W := 540.0
const SCREEN_H := 960.0
const LANE_Y := 557.0              # 58% of the screen height
const LANE_X0 := 70.0              # screen x of sim x = 0
const LANE_X1 := 470.0             # screen x of sim x = lane
const PLAYER_BASE_X := 34.0
const ENEMY_BASE_X := 506.0
const END_DELAY := 1.0             # seconds the last animation plays before the result screen
const MAX_FRAME_DT := 0.25
const POWER_SFX := {
	"squirm_slam": "power_cast_1", "apple_rain": "power_cast_2", "time_freeze": "power_cast_3",
	"rewind": "power_cast_4", "dirt_shield": "power_cast_5", "fast_forward": "power_cast_6",
}

var sim: BattleSim
var era := 1
var stage := 1
var squad_ids: Array = []
var power_ids: Array = []
var food_boost := false
var speed := 1                     # 1 or 2, remembered in profile settings "battle_speed"
var paused := false
var ending := false                # sim finished, waiting END_DELAY
var finished := false              # left this screen (result, quit or restart)
var failed := false                # stage data missing
var last_exit := ""                # "", "result", "quit" or "restart"
var unit_views: Dictionary = {}    # uid -> UnitView
var hud: BattleHud
var effects: BattleEffects
var overlay: PauseOverlay
var rule_layer: RuleLayer
var tutorial: TutorialDirector     # guided first battles (null when there is nothing to teach)
var tutorial_hold := false         # a blocking tutorial step is up: the sim clock waits (view-only, the sim is untouched)

var _bg: BattleBackground
var _world: Node2D
var _unit_layer: Node2D
var _player_base: BaseView
var _enemy_base: BaseView
var _acc := 0.0
var _end_timer := 0.0
var _stage_end_logged := false
var _overtime_shown := false
var _sfx_last_t := -1.0
var _max_catchup := 5
var _px_scale := 0.4               # screen px per sim px
var _shield_max := 1.0
var _stage_id := ""


func _ready() -> void:
	_begin()


func _begin() -> void:
	era = int(params.get("era", 1))
	stage = int(params.get("stage", 1))
	squad_ids = (params.get("squad", []) as Array).duplicate()
	power_ids = (params.get("powers", []) as Array).duplicate()
	food_boost = bool(params.get("food_boost", false))
	_stage_id = Economy.stage_id(era, stage)
	_max_catchup = DataDB.bal_i("sim.max_catchup_ticks", 5)
	speed = 2 if int(Game.save.profile["settings"].get("battle_speed", 1)) == 2 else 1
	var resuming := bool(params.get("resume", false)) and Game.last_sim != null
	if resuming:
		sim = Game.last_sim
	else:
		var stage_def := DataDB.stage(era, stage)
		if stage_def.is_empty():
			push_warning("BattleScreen: no stage data for %d-%d" % [era, stage])
			failed = true
			Game.nav.go("levels")
			return
		if squad_ids.is_empty():
			squad_ids = _fallback_squad()
		sim = BattleSim.new(BattleSetup.make(stage_def, _make_opts()))
	_px_scale = (LANE_X1 - LANE_X0) / sim.lane
	Game.audio.play_music_for_battle(era, bool(DataDB.stage(era, stage).get("boss", false)))
	_shield_max = 1.0
	_build_ui()
	if resuming:
		squad_ids = []
		for c in sim.cards:
			squad_ids.append(str(c["stats"]["id"]))
		power_ids = []
		for p in sim.powers:
			power_ids.append(str(p["id"]))
		apply_second_wind()
	else:
		Game.analytics.log_event("stage_start", {"stage": _stage_id, "squad": squad_ids, "powers": power_ids,
				"tries": _tries(), "food_boost": food_boost})
		tutorial = TutorialDirector.make(self)
	_update_visuals(0.0)


func _fallback_squad() -> Array:
	var lo: Dictionary = Game.save.profile["loadout"]
	var presets: Array = lo.get("squad_presets", [])
	var idx := int(lo.get("active_preset", 0))
	if idx >= 0 and idx < presets.size() and not (presets[idx] as Array).is_empty():
		return (presets[idx] as Array).duplicate()
	return ["p1_club_worm"]


func _make_opts() -> Dictionary:
	var unit_levels := {}
	for id in squad_ids:
		unit_levels[id] = Game.economy.unit_level(str(id))
	var power_levels := {}
	for pid in power_ids:
		power_levels[pid] = Game.economy.power_level(str(pid))
	return {
		"squad": squad_ids, "unit_levels": unit_levels,
		"burrow_level": Game.economy.burrow_level(), "base_level": Game.economy.base_level(),
		"powers": power_ids, "power_levels": power_levels,
		"underdog_stacks": int(Game.economy.underdog(era, stage).get("stacks", 0)),
		"food_boost": food_boost, "relics": Relics.modifiers(Game.save.profile),
	}


func _tries() -> int:
	return Game.economy.loss_streak(era, stage) + 1


# ------------------------------------------------------------------ construction

func _build_ui() -> void:
	_bg = BattleBackground.new()
	_bg.setup(Vector2(SCREEN_W, SCREEN_H), LANE_Y, era)
	add_child(_bg)
	rule_layer = RuleLayer.new()
	rule_layer.setup(LANE_X0, _px_scale, LANE_Y)
	add_child(rule_layer)
	_world = Node2D.new()
	_world.name = "World"
	add_child(_world)
	_player_base = BaseView.new()
	_player_base.position = Vector2(PLAYER_BASE_X, LANE_Y + 30.0)
	_player_base.setup(BattleSim.PLAYER, Game.t("battle.base_player_short"), era)
	_world.add_child(_player_base)
	_enemy_base = BaseView.new()
	_enemy_base.position = Vector2(ENEMY_BASE_X, LANE_Y + 30.0)
	_enemy_base.setup(BattleSim.ENEMY, Game.t("era.%d.enemy_base" % era), era)
	_world.add_child(_enemy_base)
	_unit_layer = Node2D.new()
	_unit_layer.name = "Units"
	_unit_layer.y_sort_enabled = true
	_world.add_child(_unit_layer)
	effects = BattleEffects.new()
	effects.z_index = 700   # above the units (their z is their foot y, ~557)
	effects.flash_rect = Rect2(0, 0, SCREEN_W, SCREEN_H)
	_world.add_child(effects)
	hud = BattleHud.new()
	add_child(hud)
	hud.build(sim, squad_ids, power_ids, era)
	hud.set_underdog(int(Game.economy.underdog(era, stage).get("stacks", 0)))
	hud.card_pressed.connect(press_card)
	hud.power_pressed.connect(press_power)
	hud.pause_pressed.connect(pause)
	hud.speed_pressed.connect(toggle_speed)


# ------------------------------------------------------------------ time

func _process(delta: float) -> void:
	step(delta)


## Everything _process does, callable without a frame loop (tests, tools).
func step(delta: float) -> void:
	if sim == null or finished or failed:
		return
	var dt := clampf(delta, 0.0, MAX_FRAME_DT)
	hud.tick_toast(dt)
	if tutorial != null:
		tutorial.update(dt)
	if paused or tutorial_hold:
		return
	if ending:
		_end_timer -= dt
		if _end_timer <= 0.0:
			_finish()
			return
	else:
		_acc += dt * float(speed)
		var ticks := 0
		while _acc >= sim.dt and ticks < _max_catchup and sim.result == "":
			sim.tick()
			ticks += 1
			_acc -= sim.dt
			_drain_events()
		if ticks >= _max_catchup and _acc >= sim.dt:
			_acc = 0.0   # fell behind: drop the backlog instead of spiralling
		if not _overtime_shown and sim.time >= DataDB.bal_f("battle.overtime_after_seconds", 240.0):
			_overtime_shown = true
			hud.toast(Game.t("battle.overtime"), 2.5)
		if sim.result != "":
			_begin_end()
	_update_visuals(dt)


func toggle_speed() -> void:
	speed = 1 if speed == 2 else 2
	Game.save.profile["settings"]["battle_speed"] = speed
	Game.save.save()
	hud.refresh(sim, speed)


# ------------------------------------------------------------------ pause

func pause() -> void:
	if paused or finished or failed or ending:
		return
	paused = true
	overlay = PauseOverlay.new()
	overlay.resume_requested.connect(resume_play)
	overlay.restart_requested.connect(restart)
	overlay.quit_requested.connect(quit_to_levels)
	add_child(overlay)


func resume_play() -> void:
	if not paused:
		return
	paused = false
	if overlay != null:
		overlay.queue_free()
		overlay = null


func is_paused() -> bool:
	return paused


func _notification(what: int) -> void:
	if what == NOTIFICATION_APPLICATION_PAUSED or what == NOTIFICATION_APPLICATION_FOCUS_OUT \
			or what == NOTIFICATION_WM_WINDOW_FOCUS_OUT or what == NOTIFICATION_WM_GO_BACK_REQUEST:
		if sim != null:
			pause()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if paused:
			resume_play()
		else:
			pause()
		get_viewport().set_input_as_handled()


# ------------------------------------------------------------------ player input

func _can_input() -> bool:
	return sim != null and not paused and not ending and not finished and sim.result == ""


## Spawns the unit of card i. False (with a hint) when it cannot be spawned now.
func press_card(i: int) -> bool:
	if not _can_input():
		return false
	if i < 0 or i >= sim.cards.size():
		return false
	if sim.spawn_player(i):
		_drain_events()
		_update_visuals(0.0)
		return true
	var cost := float(sim.cards[i]["stats"]["cost"])
	if sim.food < cost:
		hud.toast(Game.t("battle.not_enough_food"))
	elif sim.alive_units(BattleSim.PLAYER).size() >= DataDB.bal_i("battle.pop_cap_per_side", 40):
		hud.toast(Game.t("battle.pop_cap"))
	return false


func press_power(i: int) -> bool:
	if not _can_input():
		return false
	if i < 0 or i >= sim.powers.size():
		return false
	var pid := str(sim.powers[i]["id"])
	if sim.cast_power(i):
		Game.analytics.log_event("power_used", {"power": pid, "stage": _stage_id, "time": snappedf(sim.time, 0.1)})
		_drain_events()
		_update_visuals(0.0)
		return true
	if sim.power_ready(i):
		hud.toast(Game.t("battle.power_no_target"))
	return false


# ------------------------------------------------------------------ ending

func _begin_end() -> void:
	if ending:
		return
	ending = true
	_end_timer = END_DELAY
	Game.audio.play_sfx("victory" if sim.result == "win" else "defeat")
	Game.audio.play_result_music(sim.result == "win")
	_log_stage_end(sim.result, false)


func _log_stage_end(result: String, quit: bool) -> void:
	if _stage_end_logged:
		return
	_stage_end_logged = true
	var p := {"stage": _stage_id, "result": result, "duration": snappedf(sim.time, 0.1), "squad": squad_ids,
			"tries": _tries()}
	if quit:
		p["quit"] = true
	Game.analytics.log_event("stage_end", p)


func _finish() -> void:
	if finished:
		return
	finished = true
	last_exit = "result"
	Game.last_sim = sim
	var out := {
		"result": sim.result, "era": era, "stage": stage, "stats": sim.stats, "time": sim.time,
		"base_hp_fraction": sim.player_base_hp / maxf(1.0, sim.player_base_max),
		# Extra data so the result screen can offer Retry / Second Wind without asking the prebattle again.
		"squad": squad_ids, "powers": power_ids, "food_boost": food_boost,
		"second_wind_used": bool(params.get("resume", false)),
	}
	battle_finished.emit(out)
	var route := Story.after_battle(Game.save.profile, sim.result, era, stage, out)   # boss: era closing comic first
	Game.nav.go(route[0], route[1])


## Second Wind (rewarded ad): the player base comes back at a fraction of its HP and the fight goes on.
## BattleSim.revive_base does the revive; views are rebuilt from the sim state.
func apply_second_wind() -> void:
	sim.revive_base(DataDB.bal_f("ads.second_wind_base_hp_fraction", 0.25))
	ending = false
	finished = false
	_stage_end_logged = false
	_acc = 0.0
	_rebuild_views()
	_update_visuals(0.0)


func _rebuild_views() -> void:
	for v in unit_views.values():
		(v as Node).queue_free()
	unit_views.clear()
	effects.clear_all()
	sim.drain_events()
	_sfx_last_t = -1.0


## Leaving counts as a lost attempt with no rewards: back to the level select.
func quit_to_levels() -> void:
	if finished:
		return
	_leave("quit")
	Game.nav.go("levels")


func restart() -> void:
	if finished:
		return
	_leave("restart")
	Game.nav.go("battle", {"era": era, "stage": stage, "squad": squad_ids, "powers": power_ids,
			"food_boost": food_boost, "resume": false})


func _leave(kind: String) -> void:
	finished = true
	last_exit = kind
	if sim != null and sim.result == "":
		_log_stage_end("lose", true)
	battle_left.emit(kind)


# ------------------------------------------------------------------ sim -> view

func _sx(sim_x: float) -> float:
	return LANE_X0 + sim_x * _px_scale


func _foot_y(uid: int) -> float:
	return LANE_Y + float(uid % 3 - 1) * 8.0


func _side_of(uid: int) -> int:
	if unit_views.has(uid):
		return (unit_views[uid] as UnitView).side
	for u in sim.units:
		if u.uid == uid:
			return u.side
	return BattleSim.ENEMY


func _update_visuals(dt: float) -> void:
	var seen := {}
	for u in sim.units:
		var v: UnitView = unit_views.get(u.uid)
		if v == null:
			v = UnitView.new()
			v.setup(u)
			_unit_layer.add_child(v)
			unit_views[u.uid] = v
		var fy := _foot_y(u.uid)
		v.update_from(u, _sx(u.x), fy, dt)
		v.set_slowed(_on_patch(u))
		v.z_index = int(fy)
		seen[u.uid] = true
	for uid in unit_views.keys():
		if not seen.has(uid):
			(unit_views[uid] as Node).queue_free()
			unit_views.erase(uid)
	_shield_max = maxf(1.0, sim.player_shield_max)
	_player_base.update_from(sim.player_base_hp, sim.player_base_max, sim.player_shield, _shield_max, dt)
	_enemy_base.update_from(sim.enemy_base_hp, sim.enemy_base_max, 0.0, 1.0, dt)
	var pr: Array = []
	for p in sim.projectiles:
		var f := clampf(float(p["t"]) / maxf(0.001, float(p["dur"])), 0.0, 1.0)
		var px := _sx(lerpf(float(p["x0"]), float(p["x1"]), f))
		var pd := {"pos": Vector2(px, LANE_Y - 30.0 - sin(f * PI) * 16.0), "side": int(p["side"])}
		var src_view: UnitView = unit_views.get(int(p.get("src", -1)))
		var art_id := BattleEffects.projectile_art_id(src_view.unit_id if src_view != null else "", era)
		if art_id != "":
			pd["tex"] = SpriteFactory.texture_of(art_id)
			pd["art_left"] = SpriteFactory.facing_of(art_id) == "left"
		pr.append(pd)
	effects.projectiles = pr
	effects.advance(dt)
	_bg.drift(dt)
	rule_layer.sync(sim)
	hud.refresh(sim, speed)


## True when the (non-air) unit stands on a sand patch (Era 2 rule): shown with a small slow icon.
func _on_patch(u: SimUnit) -> bool:
	if u.is_air or not u.alive():
		return false
	return RuleLayer.on_patch(RuleLayer.patches_of(sim), u.x)


func _drain_events() -> void:
	for e in sim.drain_events():
		_handle_event(e)


func _handle_event(e: Dictionary) -> void:
	var audio: AudioService = Game.audio
	match str(e["type"]):
		"spawn":
			var side := int(e["side"])
			var gx := _sx(30.0 if side == BattleSim.PLAYER else sim.lane - 30.0)
			effects.add_puff(Vector2(gx, LANE_Y), Color(1, 1, 1, 0.7))
			if side == BattleSim.PLAYER:
				audio.play_sfx("spawn")
			elif bool(e.get("boss", false)):
				audio.play_music_for_battle(era, true)
		"hit":
			var side2 := _side_of(int(e["uid"]))
			var pos := Vector2(_sx(float(e["x"])), LANE_Y - 50.0)
			var col := Color(1, 0.35, 0.3) if side2 == BattleSim.PLAYER else Color.WHITE
			effects.add_number(pos, str(int(round(float(e["damage"])))), col)
			effects.add_impact(pos + Vector2(0, 14), side2 == BattleSim.PLAYER)
			if _sfx_ready(float(e["t"])):
				audio.play_sfx("hit")
		"death":
			effects.add_puff(Vector2(_sx(float(e["x"])), LANE_Y - 14.0), Color(0.9, 0.9, 0.9, 0.8))
			audio.play_sfx("death")
		"base_hit":
			var side3 := int(e["side"])
			var base := _player_base if side3 == BattleSim.PLAYER else _enemy_base
			base.hit()
			var bpos := base.position + Vector2(0, base.top_y() - 4.0)
			effects.add_number(bpos, str(int(round(float(e["damage"])))), Color(1, 0.55, 0.2))
			effects.add_impact(base.position + Vector2(0, base.top_y() * 0.5), side3 == BattleSim.PLAYER, Color(1, 0.6, 0.2))
			if _sfx_ready(float(e["t"])):
				audio.play_sfx("base_hit")
		"power":
			_power_visual(e)
			audio.play_sfx(str(POWER_SFX.get(str(e["id"]), "power_cast_1")))
		"telegraph":
			var wx := _sx(float(e["x"]))
			var wdur := DataDB.bal_f("boss.telegraph_warning_s", 1.5)
			# Danger strip in front of the boss (toward the player side), clamped to the lane.
			var zx0 := maxf(LANE_X0 - 20.0, wx - 150.0 * _px_scale * 2.5)
			effects.add_warning(Vector2(wx, LANE_Y - 120.0), wdur, Rect2(zx0, LANE_Y - 42.0, maxf(0.0, wx - zx0), 84.0))
			hud.toast(Game.t("battle.boss_warning"), wdur + 0.5, true)
			audio.play_sfx("boss_warning")
		"boss_attack":
			var bx := _sx(float(e["x"]))
			if str(e["id"]) == "stomp":
				effects.add_ring(Vector2(bx, LANE_Y), float(e.get("reach", 120.0)) * _px_scale, Color(0.55, 0.35, 0.15), 0.5)
			else:
				effects.add_puff(Vector2(bx, LANE_Y - 20.0), Color(0.8, 0.3, 0.9, 0.8))
		"phase2":
			effects.add_flash(Color(0.9, 0.1, 0.1), 0.6)
		"teleport":   # Count Magpie 3000 hop (phase 2)
			effects.add_puff(Vector2(_sx(float(e["x"])), LANE_Y - 20.0), Color(0.3, 0.9, 1.0, 0.8))
			effects.add_puff(Vector2(_sx(float(e["to"])), LANE_Y - 20.0), Color(0.3, 0.9, 1.0, 0.8))
		"bomb_drop":
			var bdx := _sx(float(e["x"]))
			var bdur := float(e.get("delay", 1.0))
			effects.add_warning(Vector2(bdx, LANE_Y - 90.0), bdur, Rect2(bdx - 40.0 * _px_scale * 2.0, LANE_Y - 42.0, 80.0 * _px_scale * 2.0, 84.0))
		"bomb_hit":
			effects.add_ring(Vector2(_sx(float(e["x"])), LANE_Y), float(e.get("radius", 80.0)) * _px_scale, Color(1.0, 0.8, 0.2), 0.5)
			effects.add_flash(Color(1.0, 0.9, 0.5), 0.15)


## At most one hit / base_hit sound per 80 ms of sim time so a crowd does not turn into noise.
func _sfx_ready(sim_t: float) -> bool:
	if sim_t >= _sfx_last_t and sim_t - _sfx_last_t < 0.08:
		return false
	_sfx_last_t = sim_t
	return true


func _power_visual(e: Dictionary) -> void:
	var pid := str(e["id"])
	var base_pos := _player_base.position
	match pid:
		"squirm_slam":
			var r := float(e.get("radius", 120.0)) * _px_scale
			effects.add_ring(Vector2(_sx(float(e["x"])), LANE_Y), r, Color(0.6, 0.4, 0.2), 0.6)
			effects.add_flash(Color(1, 0.9, 0.6), 0.2)
		"apple_rain":
			var dur := 5.0
			for p in sim.powers:
				if str(p["id"]) == pid:
					dur = float((p["effect"] as Dictionary).get("duration_s", 5.0))
			effects.start_rain(LANE_X0, LANE_X1, 130.0, LANE_Y, dur)
		"time_freeze":
			effects.add_flash(Color(0.5, 0.85, 1.0), 0.8)
		"rewind":
			effects.add_flash(Color(0.6, 1.0, 0.7), 0.6)
			effects.add_ring(base_pos + Vector2(40, -20), 70.0, Color(0.4, 0.9, 0.5), 0.6)
		"dirt_shield":
			effects.add_ring(base_pos + Vector2(0, -50), 90.0, Color(0.7, 0.5, 0.25), 0.6)
		"fast_forward":
			effects.add_flash(Color(1.0, 0.9, 0.3), 0.5)
