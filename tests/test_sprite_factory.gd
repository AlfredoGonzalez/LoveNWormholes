extends TestCase

const TMP := "user://test_sprite_factory"
const ROWS := ["idle", "walk", "attack", "hurt", "defeat"]
const FPS := {"idle": 6, "walk": 10, "attack": 12, "hurt": 10, "defeat": 8}

func _make_sheet(path: String, fw: int, fh: int) -> void:
	DirAccess.make_dir_recursive_absolute(TMP)
	var img := Image.create(fw * 5, fh * 5, false, Image.FORMAT_RGBA8)
	for r in range(5):
		for c in range(5):
			img.fill_rect(Rect2i(c * fw, r * fh, fw, fh), Color(r / 5.0, c / 5.0, 0.5, 1.0))
	img.save_png(path)

func _entry(id: String, path: String, fw: int, fh: int) -> Dictionary:
	return {"id": id, "kind": "sheet", "path": path, "frame_w": fw, "frame_h": fh,
		"rows": ROWS, "frames_per_row": 5, "fps": FPS, "hit_frame": 2,
		"facing": "right", "key_color": "#FF00FF"}

func _label_of(n: Node) -> String:
	for c in n.get_children():
		if c is Label:
			return (c as Label).text
	return ""

func _body_color(n: Node) -> Color:
	return (n.get_node("PlaceholderBody") as ColorRect).color

func test_missing_asset_gives_placeholder() -> void:
	SpriteManifest.set_entries({})
	var n := SpriteFactory.make_animated("p1_club_worm")
	assert_true(n != null)
	assert_true(n.is_placeholder)
	assert_eq(_label_of(n), "p1_club_worm")
	assert_eq(n.frame_size, Vector2i(160, 256))
	assert_true(_body_color(n).b > _body_color(n).r, "player is blue")
	assert_eq(n.play_row("attack"), false)
	n.free()
	var e := SpriteFactory.make_animated("e1_ant_clubber")
	assert_true(_body_color(e).r > _body_color(e).b, "enemy is red")
	e.free()
	var b := SpriteFactory.make_animated("b1_rexy")
	assert_eq(b.frame_size, Vector2i(320, 512))
	assert_true(_body_color(b).r > _body_color(b).b)
	b.free()
	var s := SpriteFactory.make_static("base_p1")
	assert_true(s.is_placeholder)
	s.free()

func test_manifest_entry_but_missing_file() -> void:
	SpriteManifest.set_entries({"p1_x": _entry("p1_x", TMP + "/nope.png", 64, 96)})
	var n := SpriteFactory.make_animated("p1_x")
	assert_true(n.is_placeholder)
	assert_eq(n.frame_size, Vector2i(64, 96), "placeholder sized like the real asset")
	n.free()

func test_synthetic_sheet_builds_spriteframes() -> void:
	var path := TMP + "/p1_test_sheet.png"
	_make_sheet(path, 32, 48)
	SpriteManifest.set_entries({"p1_test": _entry("p1_test", path, 32, 48)})
	var n := SpriteFactory.make_animated("p1_test")
	assert_true(not n.is_placeholder)
	var frames: SpriteFrames = n.sprite.sprite_frames
	assert_eq(frames.get_animation_names().size(), 5)
	for row in ROWS:
		assert_true(frames.has_animation(row), row)
		assert_eq(frames.get_frame_count(row), 5)
		assert_near(frames.get_animation_speed(row), float(FPS[row]))
	assert_true(frames.get_animation_loop("idle"))
	assert_true(not frames.get_animation_loop("attack"))
	var at := frames.get_frame_texture("hurt", 3) as AtlasTexture
	assert_eq(at.region, Rect2(96, 144, 32, 48))
	assert_eq(n.hit_frame, 2)
	assert_eq(n.current_row, "idle")
	assert_true(n.play_row("attack"))
	assert_eq(n.current_row, "attack")
	assert_true(not n.play_row("cast_slam"))
	assert_true(not n.sprite.flip_h)
	n.free()
	var flipped := SpriteFactory.make_animated("p1_test", "left")
	assert_true(flipped.sprite.flip_h)
	flipped.free()

## Per-animation format: idle and attack have art, walk is listed but its file is missing.
func _anim_entry(id: String, idle_path: String, atk_path: String) -> Dictionary:
	return {"id": id, "kind": "sheet", "format": 2, "category": "unit", "frame_w": 32, "frame_h": 48,
		"nominal_h": 48, "facing": "right", "expected_anims": ROWS,
		"anims": {
			"idle": {"path": idle_path, "frame_w": 32, "frame_h": 40, "anchor": [16, 38], "cols": 5,
				"frames": 25, "fps": 12, "loop": true, "x2": false},
			"attack": {"path": atk_path, "frame_w": 64, "frame_h": 80, "anchor": [32, 78], "cols": 5,
				"frames": 10, "fps": 18, "loop": false, "x2": true, "hit_frame": 4},
			"walk": {"path": TMP + "/missing_walk.png", "frame_w": 32, "frame_h": 40,
				"anchor": [16, 38], "cols": 5, "frames": 25, "fps": 14, "loop": true}}}

func _make_grid(path: String, fw: int, fh: int, n: int) -> void:
	DirAccess.make_dir_recursive_absolute(TMP)
	var img := Image.create(fw * 5, fh * int(ceil(n / 5.0)), false, Image.FORMAT_RGBA8)
	img.fill(Color(0.3, 0.8, 0.3, 1.0))
	img.save_png(path)

func test_per_animation_sheets_and_partial_fallback() -> void:
	var idle_p := TMP + "/p1_pa_idle_sheet.png"
	var atk_p := TMP + "/p1_pa_attack_x2_sheet.png"
	_make_grid(idle_p, 32, 40, 25)
	_make_grid(atk_p, 64, 80, 10)
	SpriteManifest.set_entries({"p1_pa": _anim_entry("p1_pa", idle_p, atk_p)})
	assert_true(SpriteManifest.has_anim("p1_pa", "idle"))
	var n := SpriteFactory.make_animated("p1_pa")
	assert_true(not n.is_placeholder)
	assert_eq(n.frame_size.y, 48, "scale basis is the nominal height, not the x2 canvas")
	var frames: SpriteFrames = n.sprite.sprite_frames
	assert_true(frames.has_animation("idle") and frames.has_animation("attack"))
	assert_true(not frames.has_animation("walk"), "missing file: no walk animation")
	assert_eq(frames.get_frame_count("idle"), 25)
	assert_eq(frames.get_frame_count("attack"), 10)
	assert_near(frames.get_animation_speed("attack"), 18.0)
	assert_true(frames.get_animation_loop("idle") and not frames.get_animation_loop("attack"))
	assert_eq((frames.get_frame_texture("attack", 7) as AtlasTexture).region, Rect2(128, 80, 64, 80))
	# idle: sprite visible, placeholder hidden; offset follows the feet anchor.
	assert_true(n.sprite.visible)
	assert_eq(n.sprite.offset, Vector2(-16, -38))
	assert_true(n.play_row("attack"))
	assert_eq(n.sprite.offset, Vector2(-32, -78))
	assert_eq(n.hit_frames["attack"], 4)
	# walk has no art: falls back to the placeholder for that animation only.
	assert_true(not n.play_row("walk"))
	assert_true(not n.sprite.visible)
	assert_true((n.get_node("PlaceholderBody") as CanvasItem).visible)
	assert_true(n.play_row("idle"))
	assert_true(n.sprite.visible)
	assert_true(not (n.get_node("PlaceholderBody") as CanvasItem).visible)
	n.free()
	var f := SpriteFactory.make_animated("p1_pa", "left")
	assert_eq(f.sprite.flip_h, true)
	f.play_row("attack")
	assert_eq(f.sprite.offset, Vector2(-(64 - 32), -78))
	f.free()

func test_per_animation_without_any_art_is_placeholder() -> void:
	var e := _anim_entry("p1_none", TMP + "/no1.png", TMP + "/no2.png")
	SpriteManifest.set_entries({"p1_none": e})
	var n := SpriteFactory.make_animated("p1_none")
	assert_true(n.is_placeholder)
	assert_eq(n.frame_size, Vector2i(32, 48))
	assert_true(not n.play_row("idle"))
	n.free()

func test_static_sprite() -> void:
	DirAccess.make_dir_recursive_absolute(TMP)
	var path := TMP + "/icon_test.png"
	Image.create(40, 30, false, Image.FORMAT_RGBA8).save_png(path)
	SpriteManifest.set_entries({"icon_test": {"id": "icon_test", "kind": "static", "path": path,
		"frame_w": 40, "frame_h": 30, "facing": "right"}})
	var n := SpriteFactory.make_static("icon_test")
	assert_true(not n.is_placeholder)
	assert_eq(n.frame_size, Vector2i(40, 30))
	n.free()

func test_studio_intro_video_and_missing_file() -> void:
	var v: Variant = load(StudioIntro.VIDEO_PATH)
	assert_true(v is VideoStreamTheora, "studio_intro.ogv loads as VideoStreamTheora")
	var si := StudioIntro.new()
	si.video_path = "res://assets/video/missing.ogv"
	var fired := [false]
	si.finished.connect(func(): fired[0] = true)
	si._ready()  # outside the tree: missing video defers finished
	si._finish()
	assert_true(fired[0])
	si.free()

func test_zzz_reset() -> void:
	SpriteManifest.reset()
	assert_true(true)
