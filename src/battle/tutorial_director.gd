class_name TutorialDirector
extends RefCounted
## Drives the guided first battles (stages 1-1..1-3) on top of a BattleScreen. READ ONLY on the sim: it looks at
## sim.food / stats / cards / powers / units and never calls a method that changes them; the only thing it does to
## the screen is `tutorial_hold` (the screen stops feeding ticks to the sim while a blocking step is shown), and the
## only thing the player does through it is the same press_card / press_power the HUD buttons use.
## Steps and flags: Tutorial (data/tutorial.json, profile.seen["tutorial"]). Analytics: tutorial_step.

var screen   # BattleScreen (untyped: this file is loaded by it)
var overlay: TutorialOverlay
var pending: Array = []
var current: Dictionary = {}
var _start_count := 0
var _timer := 0.0
var _done := false


## Returns a director when the stage has tutorial steps left, else null.
static func make(p_screen) -> TutorialDirector:
	var steps := Tutorial.pending_for_stage(Game.save.profile, p_screen.era, p_screen.stage)
	if steps.is_empty():
		return null
	var d := TutorialDirector.new()
	d.screen = p_screen
	d.pending = steps
	d.overlay = TutorialOverlay.new()
	p_screen.add_child(d.overlay)
	d.overlay.advance.connect(d._on_advance)
	d.overlay.target_tapped.connect(d._on_target_tapped)
	d.overlay.skip_requested.connect(d.skip)
	return d


func is_active() -> bool:
	return not _done


## Called by the screen every step(), before it decides whether to tick the sim.
func update(dt: float) -> void:
	if _done:
		return
	var sim: BattleSim = screen.sim
	if sim == null or screen.finished or screen.failed or screen.ending or sim.result != "":
		_hide()
		return
	if screen.paused:
		return
	if current.is_empty():
		_pick_next()
		if current.is_empty():
			if pending.is_empty():
				_finish()
			return
	if _completed(sim):
		_complete()
		return
	if str(current.get("kind", "info")) == "info" and not bool(current.get("hold", true)):
		_timer -= dt
		if _timer <= 0.0:
			_complete()


func _pick_next() -> void:
	while not pending.is_empty():
		var s: Dictionary = pending[0]
		if not _applicable(s):
			pending.pop_front()   # nothing to point at (e.g. no powers equipped): skipped for this battle only
			continue
		if not _can_show(s):
			return                # wait (the battle keeps running) until it makes sense
		pending.pop_front()
		_show(s)
		return


func _applicable(s: Dictionary) -> bool:
	match str(s.get("target", "none")):
		"card0", "cards":
			return not screen.hud.cards.is_empty()
		"power0", "powers":
			return not screen.hud.power_buttons.is_empty()
	return true


func _can_show(s: Dictionary) -> bool:
	var sim: BattleSim = screen.sim
	match str(s.get("needs", "")):
		"card_ready":
			return sim.card_ready(0)
		"power_ready_enemy":
			return sim.power_ready(0) and not sim.alive_units(BattleSim.ENEMY).is_empty()
	return true


func _show(s: Dictionary) -> void:
	current = s
	var sim: BattleSim = screen.sim
	_start_count = int(sim.stats["units_spawned"]) if str(s["kind"]) == "tap_card" else int(sim.stats["powers_used"])
	_timer = float(s.get("seconds", 6.0))
	var hold := bool(s.get("hold", true))
	var arg := ""
	match str(s["kind"]):
		"tap_card":
			arg = Game.t("unit.%s.name" % str(sim.cards[0]["stats"]["id"]))
		"tap_power":
			arg = Game.t("power.%s.name" % str(sim.powers[0]["id"]))
	overlay.show_step(Game.t(str(s["text_key"]), [arg]), _rect_of(str(s.get("target", "none"))), str(s["kind"]), hold)
	screen.tutorial_hold = hold
	Game.analytics.tutorial_step(str(s["id"]), int(s.get("index", 0)))


func _completed(sim: BattleSim) -> bool:
	match str(current.get("kind", "info")):
		"tap_card":
			return int(sim.stats["units_spawned"]) > _start_count
		"tap_power":
			return int(sim.stats["powers_used"]) > _start_count
	return false


func _complete() -> void:
	if current.is_empty():
		return
	Tutorial.mark_step(Game.save.profile, str(current["id"]))
	Game.save.save()
	current = {}
	screen.tutorial_hold = false
	overlay.hide_step()
	if pending.is_empty():
		_finish()


func _finish() -> void:
	_done = true
	_hide()


func _hide() -> void:
	screen.tutorial_hold = false
	if overlay != null and is_instance_valid(overlay):
		overlay.hide_step()


## Skip is permanent: every future tutorial step (all stages) is off.
func skip() -> void:
	if _done:
		return
	Tutorial.skip(Game.save.profile)
	Game.save.save()
	Game.analytics.tutorial_step("skip", int(current.get("index", 0)))
	pending.clear()
	current = {}
	_finish()


func _on_advance() -> void:
	if not current.is_empty() and str(current.get("kind", "info")) == "info":
		_complete()


## A tap on the highlighted control: do what the real button would do.
func _on_target_tapped() -> void:
	match str(current.get("kind", "")):
		"tap_card":
			screen.press_card(0)
		"tap_power":
			screen.press_power(0)


## Highlight rect in overlay coordinates for a target name.
func _rect_of(target: String) -> Rect2:
	var hud: BattleHud = screen.hud
	var nodes: Array = []
	match target:
		"card0":
			nodes = [hud.cards[0]] if not hud.cards.is_empty() else []
		"power0":
			nodes = [hud.power_buttons[0]] if not hud.power_buttons.is_empty() else []
		"cards":
			nodes = hud.cards
		"powers":
			nodes = hud.power_buttons
		"food":
			nodes = [hud.food_bar]
		"enemy_base":
			nodes = [hud.enemy_bar]
		"speed":
			nodes = [hud.speed_button]
		"pause":
			nodes = [hud.pause_button]
	var out := Rect2()
	var first := true
	var origin: Vector2 = overlay.global_position
	for n in nodes:
		var c: Control = n
		var r := Rect2(c.global_position - origin, c.size)
		out = r if first else out.merge(r)
		first = false
	return out
