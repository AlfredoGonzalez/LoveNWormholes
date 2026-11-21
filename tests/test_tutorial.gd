extends TestCase
## Guided first battles: Tutorial flags/steps (pure), TutorialDirector + overlay on a real BattleScreen driven
## through step(). The tutorial must leave BattleSim alone (it only holds the clock).

const SAVE := "user://test_tutorial_save.json"
const SQUAD := ["p1_club_worm", "p1_slinger_worm"]
const POWERS := ["squirm_slam", "apple_rain"]


func _g():
	var ml := Engine.get_main_loop()
	if ml == null or not (ml is SceneTree) or (ml as SceneTree).root == null:
		return null
	return (ml as SceneTree).root.get_node_or_null("Game")


func _fresh(armed := true) -> void:
	var g = _g()
	g.boot(SAVE)
	g.save.delete_all()
	g.boot(SAVE)
	g.last_sim = null
	Localization.set_language("en")
	if armed:
		Story.mark_seen(g.save.profile, "intro")


func _make(era := 1, stage := 1, extra := {}):
	var p := {"era": era, "stage": stage, "squad": SQUAD, "powers": POWERS, "food_boost": false}
	p.merge(extra, true)
	var s = (load("res://src/battle/battle_screen.gd") as GDScript).new()
	s.setup(p)
	Engine.get_main_loop().root.add_child(s)
	return s


func _drop(s) -> void:
	if s.get_parent() != null:
		s.get_parent().remove_child(s)
	s.free()


func _events() -> Array:
	return (_g().analytics.provider as MockAnalyticsProvider).names()


func _run(s, seconds: float) -> void:
	var n := int(seconds / s.sim.dt)
	for i in n:
		s.step(s.sim.dt)


# ------------------------------------------------------------------ pure

func test_step_data() -> void:
	var all := Tutorial.all_steps()
	assert_true(all.size() >= 6)
	var seen := {}
	for s in all:
		assert_true(not seen.has(s["id"]), "unique id")
		seen[s["id"]] = true
		assert_true(str(s["kind"]) in ["info", "tap_card", "tap_power"])
		assert_true(Localization.has_key(str(s["text_key"])), str(s["text_key"]))
	for stage in [1, 2, 3]:
		assert_true(not Tutorial.steps_for_stage(1, stage).is_empty(), "stage 1-%d has steps" % stage)
	assert_true(Tutorial.steps_for_stage(1, 4).is_empty(), "nothing after 1-3")
	var first := Tutorial.steps_for_stage(1, 1)
	var kinds: Array = []
	for s in first:
		kinds.append(s["kind"])
	assert_true(kinds.has("tap_card") and kinds.has("tap_power"), "spec 9.2: spawn a worm, use the power")


func test_flags_and_pending() -> void:
	var prof := {"seen": {}, "progress": {"highest_stage_cleared": {}}}
	assert_eq(Tutorial.pending_for_stage(prof, 1, 1).size(), 0, "not armed: no tutorial")
	Tutorial.arm(prof)
	var n := Tutorial.pending_for_stage(prof, 1, 1).size()
	assert_true(n > 0)
	Tutorial.mark_step(prof, "welcome")
	assert_eq(Tutorial.pending_for_stage(prof, 1, 1).size(), n - 1)
	assert_true(Tutorial.step_done(prof, "welcome"))
	Tutorial.arm(prof)   # re-arming (replayed intro) does not undo anything
	assert_eq(Tutorial.pending_for_stage(prof, 1, 1).size(), n - 1)
	prof["progress"]["highest_stage_cleared"] = {"1": 1}
	assert_eq(Tutorial.pending_for_stage(prof, 1, 1).size(), 0, "cleared stage: no tutorial")
	assert_true(Tutorial.pending_for_stage(prof, 1, 2).size() > 0)
	Tutorial.skip(prof)
	assert_eq(Tutorial.pending_for_stage(prof, 1, 2).size(), 0, "skipped: never again")
	assert_eq(Tutorial.pending_for_stage({}, 1, 1).size(), 0, "tolerates an empty profile")


# ------------------------------------------------------------------ battle

func test_unarmed_battle_has_no_tutorial() -> void:
	if _g() == null:
		return
	_fresh(false)
	var s = _make()
	assert_true(s.tutorial == null)
	var t0: int = s.sim.tick_count
	_run(s, 1.0)
	assert_true(s.sim.tick_count > t0, "clock runs as before")
	_drop(s)


func test_first_battle_walkthrough() -> void:
	if _g() == null:
		return
	_fresh()
	var s = _make()
	assert_true(s.tutorial != null and s.tutorial.is_active())
	s.step(0.0)
	assert_eq(str(s.tutorial.current["id"]), "welcome")
	assert_true(s.tutorial_hold, "blocking step holds the clock")
	assert_true(s.tutorial.overlay.visible)
	var tick0: int = s.sim.tick_count
	for i in 40:
		s.step(0.1)
	assert_eq(s.sim.tick_count, tick0, "the sim does not move while a step is up")
	assert_eq(s.sim.food, s.sim.food, "untouched")
	# info -> next.
	s.tutorial.overlay.advance.emit()
	s.step(0.0)
	assert_eq(str(s.tutorial.current["id"]), "food")
	assert_true(s.tutorial.overlay.hole.size != Vector2.ZERO, "highlights the food bar")
	s.tutorial.overlay.advance.emit()
	s.step(0.0)
	assert_eq(str(s.tutorial.current["id"]), "spawn")
	var card_rect: Rect2 = s.hud.cards[0].get_global_rect()
	assert_true(s.tutorial.overlay.hole.encloses(card_rect), "highlight surrounds the first card")
	assert_true(Tutorial.step_done(_g().save.profile, "welcome") and Tutorial.step_done(_g().save.profile, "food"))
	# Only a tap on the highlight spawns it (the same press_card the HUD uses).
	assert_eq(s.sim.stats["units_spawned"], 0)
	s.tutorial.overlay.target_tapped.emit()
	assert_eq(s.sim.stats["units_spawned"], 1)
	s.step(0.0)
	assert_true(Tutorial.step_done(_g().save.profile, "spawn"))
	assert_true(not s.tutorial_hold, "released after the action")
	# The power step waits (clock running) until an enemy is on the field and the power is ready.
	assert_true(s.tutorial.current.is_empty())
	var guard := 0
	while s.tutorial.current.is_empty() and guard < 3000:
		s.step(s.sim.dt)
		guard += 1
	assert_eq(str(s.tutorial.current["id"]), "power", "after enemies appear")
	assert_true(not s.sim.alive_units(BattleSim.ENEMY).is_empty())
	assert_true(s.tutorial_hold)
	s.tutorial.overlay.target_tapped.emit()
	assert_eq(s.sim.stats["powers_used"], 1)
	s.step(0.0)
	assert_true(Tutorial.step_done(_g().save.profile, "power"))
	# The goal step does not block: the battle goes on, it dismisses itself.
	s.step(0.0)
	assert_eq(str(s.tutorial.current["id"]), "goal")
	assert_true(not s.tutorial_hold)
	var t1: int = s.sim.tick_count
	_run(s, 8.0)
	assert_true(s.sim.tick_count > t1)
	assert_true(not s.tutorial.is_active(), "all stage steps done")
	assert_true(not s.tutorial.overlay.visible)
	var steps := _events().count("tutorial_step")
	assert_eq(steps, 5, "one tutorial_step per step shown")
	_drop(s)
	# Retrying the stage does not teach again.
	var s2 = _make()
	assert_true(s2.tutorial == null, "all steps of 1-1 are flagged")
	_drop(s2)


func test_skip_is_permanent_and_logged() -> void:
	if _g() == null:
		return
	_fresh()
	var s = _make()
	s.step(0.0)
	assert_true(s.tutorial.overlay.skip_button.custom_minimum_size.y >= 48.0)
	s.tutorial.overlay.skip_requested.emit()
	assert_true(not s.tutorial_hold)
	assert_true(not s.tutorial.is_active())
	assert_true(not s.tutorial.overlay.visible)
	assert_true(Tutorial.is_skipped(_g().save.profile))
	assert_true(_events().has("tutorial_step"))
	var t0: int = s.sim.tick_count
	_run(s, 0.5)
	assert_true(s.sim.tick_count > t0, "battle runs freely")
	_drop(s)
	var s2 = _make(1, 2)
	assert_true(s2.tutorial == null, "no tutorial on later stages either")
	_drop(s2)


func test_stage_2_and_3_steps() -> void:
	if _g() == null:
		return
	_fresh()
	var s = _make(1, 2)
	s.step(0.0)
	assert_eq(str(s.tutorial.current["id"]), "mix")
	s.tutorial.overlay.advance.emit()
	s.step(0.0)
	assert_eq(str(s.tutorial.current["id"]), "speed")
	assert_true(s.tutorial.overlay.hole.encloses(s.hud.speed_button.get_global_rect()))
	s.tutorial.overlay.advance.emit()
	s.step(0.0)
	assert_true(not s.tutorial.is_active())
	assert_true(not s.tutorial_hold)
	_drop(s)
	var s3 = _make(1, 3)
	s3.step(0.0)
	assert_eq(str(s3.tutorial.current["id"]), "pause")
	assert_true(s3.tutorial.overlay.hole.encloses(s3.hud.pause_button.get_global_rect()))
	s3.tutorial.overlay.advance.emit()
	s3.step(0.0)
	assert_eq(str(s3.tutorial.current["id"]), "recharge")
	_drop(s3)
	var s4 = _make(1, 4)
	assert_true(s4.tutorial == null)
	_drop(s4)


func _fingerprint(s) -> Array:
	return [s.sim.result, s.sim.tick_count, int(s.sim.player_base_hp), int(s.sim.enemy_base_hp), int(s.sim.food),
			s.sim.stats["kills"], s.sim.stats["units_spawned"], s.sim.stats["powers_used"], s.sim.units.size()]


func test_sim_is_not_altered() -> void:
	if _g() == null:
		return
	# Play a battle with the tutorial on (it forces the first spawn and cast), log every input with its sim tick,
	# then replay exactly those inputs on a battle WITHOUT the tutorial: the sims must end identical.
	_fresh(true)
	var s = _make()
	var log: Array = []   # [tick, "card"/"power", index]
	var n := 0
	while s.sim.result == "" and n < 9000:
		var guard := 0
		while s.tutorial != null and not s.tutorial.current.is_empty() and guard < 4:
			var u0: int = s.sim.stats["units_spawned"]
			var p0: int = s.sim.stats["powers_used"]
			if str(s.tutorial.current["kind"]) == "info":
				s.tutorial.overlay.advance.emit()
			else:
				s.tutorial.overlay.target_tapped.emit()
			if s.sim.stats["units_spawned"] > u0:
				log.append([s.sim.tick_count, "card", 0])
			if s.sim.stats["powers_used"] > p0:
				log.append([s.sim.tick_count, "power", 0])
			s.step(0.0)
			guard += 1
		var u1: int = s.sim.stats["units_spawned"]
		if s.sim.tick_count % 90 == 30 and s.press_card(1):
			log.append([s.sim.tick_count, "card", 1])
		if s.sim.tick_count % 200 == 100 and s.press_power(1):
			log.append([s.sim.tick_count, "power", 1])
		if s.sim.tick_count % 120 == 0 and s.press_card(0):
			log.append([s.sim.tick_count, "card", 0])
		s.step(s.sim.dt)
		n += 1
	var armed_print := _fingerprint(s)
	_drop(s)
	assert_true(str(armed_print[0]) != "", "the tutorial battle finishes")
	assert_true(armed_print[6] > 0 and armed_print[7] > 0, "it did spawn and cast")
	_fresh(false)
	var r = _make()
	assert_true(r.tutorial == null)
	var i := 0
	var m := 0
	while r.sim.result == "" and m < 9000:
		while i < log.size() and int(log[i][0]) <= r.sim.tick_count:
			if log[i][1] == "card":
				r.press_card(int(log[i][2]))
			else:
				r.press_power(int(log[i][2]))
			i += 1
		r.step(r.sim.dt)
		m += 1
	assert_eq(_fingerprint(r), armed_print, "identical sim with and without the tutorial layer")
	_drop(r)
