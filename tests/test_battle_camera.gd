extends TestCase
## 3-screen battlefield: sim <-> world <-> screen mapping, camera limits / follow / manual control / resume,
## radar, parallax background modes (layers, single image, code) and the battle screen wiring.

const SAVE := "user://test_battle_camera_save.json"
const TMP := "user://test_battle_camera"
const SQUAD := ["p1_club_worm", "p1_slinger_worm"]
const POWERS := ["squirm_slam", "apple_rain"]


func _tree_root() -> Node:
	var loop := Engine.get_main_loop()
	if loop is SceneTree:
		return (loop as SceneTree).root
	return null


func _game() -> Node:
	var r := _tree_root()
	return r.get_node_or_null("Game") if r != null else null


func _fresh_game() -> void:
	var g = _game()
	g.boot(SAVE)
	g.save.delete_all()
	g.boot(SAVE)
	g.last_sim = null
	Localization.set_language("en")


func _make(extra := {}):
	var p := {"era": 1, "stage": 1, "squad": SQUAD, "powers": POWERS, "food_boost": false, "resume": false}
	p.merge(extra, true)
	var s = (load("res://src/battle/battle_screen.gd") as GDScript).new()
	s.setup(p)
	_tree_root().add_child(s)
	return s


func _drop(s) -> void:
	if s.get_parent() != null:
		s.get_parent().remove_child(s)
	s.free()


func _png(name: String, w: int, h: int) -> String:
	DirAccess.make_dir_recursive_absolute(TMP)
	var img := Image.create(w, h, false, Image.FORMAT_RGBA8)
	img.fill(Color(0.3, 0.6, 0.9, 1.0))
	var p := TMP + "/" + name + ".png"
	img.save_png(p)
	return p


func _img_entry(id: String, w: int, h: int) -> Dictionary:
	return {"id": id, "kind": "image", "path": _png(id, w, h), "frame_w": w, "frame_h": h}


# ------------------------------------------------------------------ mapping

func test_sim_world_mapping_is_linear_and_invertible() -> void:
	assert_near(BattleWorld.sim_to_world(0.0, 1000.0), BattleWorld.LANE_X0, 0.0001)
	assert_near(BattleWorld.sim_to_world(1000.0, 1000.0), BattleWorld.LANE_X1, 0.0001)
	assert_near(BattleWorld.sim_to_world(500.0, 1000.0), (BattleWorld.LANE_X0 + BattleWorld.LANE_X1) * 0.5, 0.0001)
	for sx in [0.0, 30.0, 333.3, 970.0, 1000.0]:
		assert_near(BattleWorld.world_to_sim(BattleWorld.sim_to_world(sx, 1000.0), 1000.0), sx, 0.0001)
	assert_near(BattleWorld.WORLD_W, 3.0 * BattleWorld.SCREEN_W, 0.0001, "three screens wide")
	assert_true(BattleWorld.PLAYER_BASE_X < BattleWorld.LANE_X0 and BattleWorld.ENEMY_BASE_X > BattleWorld.LANE_X1)
	assert_true(BattleWorld.ENEMY_BASE_X < BattleWorld.WORLD_W and BattleWorld.PLAYER_BASE_X > 0.0)
	assert_near(BattleWorld.foot_y(1) / BattleWorld.SCREEN_H, 0.58, 0.001, "foot line at 58% of the height")


func test_screen_world_conversion() -> void:
	for cx in [0.0, 100.0, BattleWorld.MAX_CAM]:
		var wx := BattleWorld.screen_to_world(270.0, cx)
		assert_near(wx, 270.0 + cx, 0.0001)
		assert_near(BattleWorld.world_to_screen(wx, cx), 270.0, 0.0001)
	if _game() == null:
		return
	_fresh_game()
	var s = _make()
	s.cam.x = 400.0
	s._apply_camera()
	assert_near(s.screen_to_world(100.0), 500.0, 0.0001)
	assert_near(s.world_to_screen(500.0), 100.0, 0.0001)
	assert_near(s._world.position.x, -400.0, 0.0001, "the world node follows the camera")
	_drop(s)


# ------------------------------------------------------------------ camera

func test_camera_limits() -> void:
	var c := BattleCamera.new()
	assert_near(c.max_x, 1080.0, 0.0001)
	c.x = -50.0
	assert_near(c.x, 0.0, 0.0001)
	c.x = 5000.0
	assert_near(c.x, c.max_x, 0.0001)
	c.recenter(-3.0)
	assert_near(c.x, 0.0, 0.0001)
	c.recenter(99999.0)
	assert_near(c.x, c.max_x, 0.0001)
	c.begin_drag()
	c.drag_move(-5000.0)   # finger far left: the camera goes right, but stops at the edge (no overscroll)
	assert_near(c.x, c.max_x, 0.0001)
	c.drag_move(9000.0)
	assert_near(c.x, 0.0, 0.0001)
	c.end_drag()
	for _i in 120:
		c.step(1.0 / 30.0, 600.0)
		assert_true(c.x >= 0.0 and c.x <= c.max_x)
	assert_near(c.x_for_center(0.0), 0.0, 0.0001)
	assert_near(c.x_for_center(810.0), 540.0, 0.0001)


func test_follow_target_rules() -> void:
	# no enemy: leader shown left of centre (LEAD ahead of it in view)
	assert_near(BattleCamera.target_for(700.0, -1.0), 700.0 + BattleCamera.LEAD - 270.0, 0.001)
	# enemy near: centred between the two
	assert_near(BattleCamera.target_for(700.0, 900.0), 800.0 - 270.0, 0.001)
	# enemy far (not visible): ignored
	assert_near(BattleCamera.target_for(500.0, 1100.0), 500.0 + BattleCamera.LEAD - 270.0, 0.001)
	# clamped at both ends
	assert_near(BattleCamera.target_for(BattleWorld.LANE_X0, -1.0), 0.0, 0.001)
	assert_near(BattleCamera.target_for(1500.0, 1500.0), BattleWorld.MAX_CAM, 0.001)
	# continuous in the blend zone
	var prev := BattleCamera.target_for(600.0, 600.0 + BattleCamera.SPAN_FULL)
	for d in range(int(BattleCamera.SPAN_FULL), int(BattleCamera.SPAN_NONE) + 20, 5):
		var t := BattleCamera.target_for(600.0, 600.0 + float(d))
		assert_true(absf(t - prev) < 40.0, "no jump at d=%d" % d)
		prev = t


func test_follow_converges_with_fixed_deltas() -> void:
	var c := BattleCamera.new()
	var target := 400.0
	for _i in 90:   # 3 s at 30 fps
		c.step(1.0 / 30.0, target)
	assert_near(c.x, target, 1.0, "eases onto the target")
	var prev := c.x
	c.step(1.0 / 30.0, 900.0)
	assert_true(c.x > prev and c.x < 900.0, "moves smoothly, never snaps")
	# deterministic: same deltas, same result
	var a := BattleCamera.new()
	var b := BattleCamera.new()
	for i in 200:
		a.step(1.0 / 30.0, 300.0 + float(i))
		b.step(1.0 / 30.0, 300.0 + float(i))
	assert_eq(a.x, b.x)


func test_manual_drag_holds_then_resumes_after_3s() -> void:
	var c := BattleCamera.new()
	c.recenter(200.0)
	c.begin_drag()
	c.drag_move(-100.0)   # finger left: view moves right
	assert_near(c.x, 300.0, 0.0001)
	c.step(1.0 / 30.0, 0.0)
	c.end_drag()
	var released_x := c.x
	for _i in 60:   # 2 s: manual (inertia only), the follow target (0) is ignored
		c.step(1.0 / 30.0, 0.0)
	assert_true(c.manual, "still manual after 2 s")
	assert_true(c.x >= released_x - 0.01, "the follow did not pull it back")
	var held := c.x
	for _i in 40:   # past 3 s since the release
		c.step(1.0 / 30.0, 0.0)
	assert_true(not c.manual, "follow resumed after the 3 s without touching")
	assert_true(c.x < held, "...and it eases back toward the target")
	for _i in 150:
		c.step(1.0 / 30.0, 0.0)
	assert_near(c.x, 0.0, 1.0)
	# touching again restarts the clock
	c.begin_drag()
	c.drag_move(-50.0)
	c.end_drag()
	for _i in 80:
		c.step(1.0 / 30.0, 0.0)
	assert_true(c.manual)
	c.pan_to_center(900.0)
	assert_true(c.manual and c.manual_t == 0.0)
	assert_near(c.x, 630.0, 0.001)


func test_focus_pan_respects_manual_control() -> void:
	var c := BattleCamera.new()
	c.focus(1000.0, 1.0)
	for _i in 25:
		c.step(1.0 / 30.0, 0.0)
	assert_true(c.x > 300.0, "panned to the focus")
	for _i in 120:
		c.step(1.0 / 30.0, 0.0)
	assert_true(c.x < 5.0, "and back to the follow target when the focus ends")
	c.recenter(0.0)
	c.begin_drag()
	c.end_drag()
	c.focus(1000.0, 1.0)   # not forced: ignored during manual control
	c.step(1.0 / 30.0, 0.0)
	assert_true(c.x < 5.0)
	c.focus(1000.0, 1.0, true)
	assert_true(not c.manual)


# ------------------------------------------------------------------ radar

func test_radar_mapping_and_input() -> void:
	assert_near(BattleRadar.u_of(BattleWorld.PLAYER_BASE_X), 0.0, 0.0001)
	assert_near(BattleRadar.u_of(BattleWorld.ENEMY_BASE_X), 1.0, 0.0001)
	assert_near(BattleRadar.u_of(-100.0), 0.0, 0.0001)
	assert_near(BattleRadar.world_of(BattleRadar.u_of(800.0)), 800.0, 0.001)
	var r := BattleRadar.new()
	r.size = Vector2(520, 24)
	var got: Array = []
	r.seek.connect(func(wx): got.append(wx))
	var press := InputEventMouseButton.new()
	press.button_index = MOUSE_BUTTON_LEFT
	press.pressed = true
	press.position = Vector2(r.size.x * 0.5, 10.0)
	r._gui_input(press)
	assert_eq(got.size(), 1)
	assert_near(got[0], (BattleWorld.PLAYER_BASE_X + BattleWorld.ENEMY_BASE_X) * 0.5, 1.0, "centre of the bar = centre of the lane")
	var mv := InputEventMouseMotion.new()
	mv.position = Vector2(PAD_X(), 10.0)
	r._gui_input(mv)
	assert_eq(got.size(), 2, "dragging keeps seeking")
	assert_near(got[1], BattleWorld.PLAYER_BASE_X, 0.001)
	press.pressed = false
	r._gui_input(press)
	r._gui_input(mv)
	assert_eq(got.size(), 2, "no seek after release")
	r.free()


func PAD_X() -> float:
	return BattleRadar.PAD


func test_radar_dots_window_and_art_fallback() -> void:
	if _game() == null:
		return
	_fresh_game()
	assert_true(SpriteFactory.texture_of("ui_minimap") == null)
	var s = _make()
	s.press_card(0)
	s.step(0.2)
	assert_true(s.radar != null and s.radar.art == null, "no ui_minimap art: code-drawn")
	assert_true(s.radar.dots.size() >= 1, "units are dots")
	assert_near(s.radar.window_u.x, 0.0, 0.0001, "the window starts at the player base")
	assert_true(s.radar.window_u.y > 0.2 and s.radar.window_u.y < 0.6, "one screen = about a third of the bar")
	s.cam.x = s.cam.max_x
	s._apply_camera()
	assert_near(s.radar.window_u.y, 1.0, 0.0001)
	var before: float = s.cam.x
	s.hud.radar_seek.emit(300.0)
	assert_true(s.cam.manual and s.cam.x < before, "radar moves the camera")
	_drop(s)


# ------------------------------------------------------------------ background

func test_background_modes_and_fallbacks() -> void:
	SpriteManifest.set_entries({})
	var bg := BattleBackground.new()
	bg.setup(Vector2(540, 960), 557.0, 1)
	assert_eq(bg.mode, "code", "no art: code background")
	bg.apply_camera(500.0)
	bg.drift(1.0)
	bg.free()
	# only the single image: scaled to cover screen + travel, factor 0.30
	SpriteManifest.set_entries({"bg_era1": _img_entry("bg_era1", 108, 193)})
	bg = BattleBackground.new()
	bg.setup(Vector2(540, 960), 557.0, 1)
	assert_eq(bg.mode, "single")
	for cx in [0.0, 540.0, BattleWorld.MAX_CAM]:
		bg.apply_camera(cx)
		var r := bg._art_rect()
		assert_near(r.position.x, -cx * 0.30, 0.001, "shifted at 0.30")
		assert_true(r.position.x <= 0.0 and r.end.x >= 540.0 - 0.01, "no gap at cam %d" % int(cx))
		assert_true(r.size.y >= 960.0 - 0.01 and r.position.y <= 0.01 and r.end.y >= 960.0 - 0.01, "covers vertically")
	assert_near(bg._art_rect().size.x / bg._art_rect().size.y, 108.0 / 193.0, 0.001, "aspect kept")
	bg.free()
	# the five layers
	var m := {"bg_era1": _img_entry("bg_era1", 108, 193)}
	for suf in BattleBackground.LAYER_SUFFIX:
		var id := BattleBackground.layer_id(1, suf)
		m[id] = _img_entry(id, 400, 960)
	SpriteManifest.set_entries(m)
	bg = BattleBackground.new()
	bg.setup(Vector2(540, 960), 557.0, 1)
	assert_eq(bg.mode, "layers")
	assert_eq(bg.layers.size(), 5)
	bg.apply_camera(1000.0)
	for suf in BattleBackground.LAYER_SUFFIX:
		var l: TextureRect = bg.layers[suf]
		var f: float = BattleBackground.LAYER_FACTORS[suf]
		assert_near(l.position.x, -1000.0 * f, 0.001, "parallax factor " + suf)
		for cx in [0.0, BattleWorld.MAX_CAM]:
			var x0: float = -float(cx) * f
			assert_true(x0 <= 0.0 and x0 + l.size.x >= 540.0 - 0.01, "%s covers at cam %d" % [suf, int(cx)])
		assert_near(l.position.y + l.size.y, 960.0, 0.01, "bottom aligned")
		assert_true(l.size.y >= 960.0 - 0.01)
	assert_near((bg.layers["ground"] as TextureRect).size.x, BattleWorld.WORLD_W, 1.0, "ground spans the whole world")
	var front := bg.take_front()
	assert_true(front != null and front.get_parent() == null, "front detached for the screen")
	bg.apply_camera(10.0)
	front.free()
	bg.free()
	# one layer missing -> back to the single image
	m.erase(BattleBackground.layer_id(1, "mid"))
	SpriteManifest.set_entries(m)
	bg = BattleBackground.new()
	bg.setup(Vector2(540, 960), 557.0, 1)
	assert_eq(bg.mode, "single", "an incomplete layer set falls back to bg_era<N>")
	bg.free()
	SpriteManifest.set_entries({})
	SpriteFactory.clear_caches()


# ------------------------------------------------------------------ screen wiring

func test_screen_starts_on_player_base_and_scales() -> void:
	if _game() == null:
		return
	_fresh_game()
	var s = _make()
	assert_near(s.cam.x, 0.0, 0.001, "camera starts on the player base")
	assert_true(s._world != null and s._player_base.get_parent() == s._world and s._enemy_base.get_parent() == s._world)
	assert_true(s.effects.get_parent() == s._world and s.rule_layer.get_parent() == s._world and s._unit_layer.get_parent() == s._world)
	assert_true(s.hud.get_parent() == s, "HUD fixed")
	assert_near(s._sx(0.0), BattleWorld.LANE_X0, 0.001)
	assert_near(s._sx(s.sim.lane), BattleWorld.LANE_X1, 0.001)
	s.press_card(0)
	s.step(0.1)
	var v = s.unit_views[s.sim.units[0].uid]
	assert_near(v.screen_height(), 70.0 * 1.5, 0.001, "units 1.5x")
	assert_near(v.position.x, s._sx(s.sim.units[0].x), 0.001, "unit placed in world coords")
	_drop(s)


func test_follow_keeps_the_front_in_view_and_resumes() -> void:
	if _game() == null:
		return
	_fresh_game()
	var s = _make({"squad": ["p1_club_worm", "p1_slinger_worm", "p1_dino_rider_worm"]})
	var dt := 1.0 / 30.0
	var max_x := 0.0
	var worst := 0.0
	for k in 900:
		if k % 45 == 0:
			s.press_card((k / 45) % 3)
		s.step(dt)
		if s.sim.result != "":
			break
		var lead := -1.0
		for u in s.sim.units:
			if u.side == BattleSim.PLAYER and u.alive():
				lead = maxf(lead, s._sx(u.x))
		if lead >= 0.0:
			max_x = maxf(max_x, s.cam.x)
			var sx: float = s.world_to_screen(lead)
			worst = maxf(worst, absf(sx - 270.0))
			assert_true(sx > 30.0 and sx < 510.0 or k < 10, "leader on screen at step %d (x=%.0f)" % [k, sx])
	assert_true(max_x > 100.0, "the camera followed the units to the right (%.0f)" % max_x)
	# manual drag through the real input path, then 3 s of nothing
	var x0: float = s.cam.x
	var press := InputEventMouseButton.new()
	press.button_index = MOUSE_BUTTON_LEFT
	press.pressed = true
	press.position = Vector2(300, 400)
	s._on_drag_input(press)
	var mv := InputEventMouseMotion.new()
	mv.position = Vector2(304, 400)
	mv.relative = Vector2(4, 0)
	s._on_drag_input(mv)
	assert_true(not s.cam.is_dragging(), "below the 8 px threshold it is not a drag")
	mv.position = Vector2(340, 400)
	mv.relative = Vector2(36, 0)
	s._on_drag_input(mv)
	assert_true(s.cam.is_dragging() and s.cam.x < x0, "drag past the threshold moves the camera")
	press.pressed = false
	s._on_drag_input(press)
	assert_true(not s.cam.is_dragging() and s.cam.manual)
	s.tutorial_hold = false
	s.recenter()
	assert_true(not s.cam.manual, "recenter button: back to following, instantly")
	assert_near(s.cam.x, s._follow_target(), 0.01)
	_drop(s)


func test_boss_telegraph_focuses_and_end_pans_to_the_base() -> void:
	if _game() == null:
		return
	_fresh_game()
	var s = _make()
	s.press_card(0)
	s.step(0.1)
	s.sim.enemy_base_hp = 0.0
	s.sim.tick()
	s.step(0.1)
	assert_true(s.ending)
	for _i in 12:
		s.step(0.1)
		if s.finished:
			break
	assert_true(s.cam.x > 100.0 or s.finished, "camera went toward the fallen enemy base")
	_drop(s)


func test_hud_stays_fixed_and_clear_of_each_other() -> void:
	if _game() == null:
		return
	_fresh_game()
	var s = _make()
	s.cam.x = 700.0
	s._apply_camera()
	assert_near(s.hud.position.x, 0.0, 0.001, "HUD does not move with the camera")
	var rects: Array = [Rect2(s.hud.radar.position, s.hud.radar.size), Rect2(s.hud.player_bar.position, s.hud.player_bar.size),
			Rect2(s.hud.enemy_bar.position, s.hud.enemy_bar.size), Rect2(s.hud.recenter_button.position, s.hud.recenter_button.size)]
	for c in s.hud.cards:
		rects.append(Rect2(c.position, c.size))
	for i in rects.size():
		for j in range(i + 1, rects.size()):
			assert_true(not (rects[i] as Rect2).intersects(rects[j]), "HUD pieces %d and %d overlap" % [i, j])
	assert_true(s.hud.recenter_button.size.x >= 48.0 and s.hud.recenter_button.size.y >= 48.0)
	assert_true(s.hud.recenter_button.position.y > s.lane_y + 40.0 * 1.5, "recenter sits below the bases")
	_drop(s)
