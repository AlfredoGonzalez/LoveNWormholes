extends TestCase
## Static art wiring (backgrounds, bases, icons, portraits, projectiles, impacts): every piece shows when its
## manifest id and file exist and falls back to the code-drawn placeholder when not.

const TMP := "user://test_art_wiring"

func _png(name: String, w: int, h: int, c := Color(0.2, 0.8, 0.3, 1.0)) -> String:
	DirAccess.make_dir_recursive_absolute(TMP)
	var img := Image.create(w, h, false, Image.FORMAT_RGBA8)
	img.fill_rect(Rect2i(8, 8, w - 16, h - 16), c)   # transparent margin around, so trimming has something to do
	var p := TMP + "/" + name + ".png"
	img.save_png(p)
	return p

func _static(id: String, path: String, w: int, h: int, facing := "right") -> Dictionary:
	return {"id": id, "kind": "static", "path": path, "frame_w": w, "frame_h": h, "facing": facing}

func _full_manifest() -> Dictionary:
	var sheet := _png("p1_club_worm_idle_sheet", 5 * 40, 5 * 40)
	return {
		"icon_coin": _static("icon_coin", _png("icon_coin", 32, 32), 32, 32),
		"icon_food": _static("icon_food", _png("icon_food", 32, 32), 32, 32),
		"power_squirm_slam": _static("power_squirm_slam", _png("power_squirm_slam", 32, 32), 32, 32),
		"proj_stone": _static("proj_stone", _png("proj_stone", 32, 24), 32, 24),
		"fx_impact": _static("fx_impact", _png("fx_impact", 32, 32), 32, 32),
		"base_p1": _static("base_p1", _png("base_p1", 128, 96), 128, 96, "right"),
		"base_e1": _static("base_e1", _png("base_e1", 128, 96), 128, 96, "right"),   # facing right: must be flipped
		"bg_era1": {"id": "bg_era1", "kind": "image", "path": _png("bg_era1", 108, 193), "frame_w": 108, "frame_h": 193},
		"p1_club_worm": {"id": "p1_club_worm", "kind": "sheet", "facing": "right", "anims": {"idle": {
			"path": sheet, "cols": 5, "frames": 25, "frame_w": 40, "frame_h": 40, "fps": 6, "loop": true}}},
	}

func test_missing_everything_falls_back() -> void:
	SpriteManifest.set_entries({})
	assert_true(SpriteFactory.texture_of("icon_coin") == null)
	assert_true(SpriteFactory.icon("icon_coin") == null)
	assert_true(SpriteFactory.portrait_of("p1_club_worm") == null)
	assert_true(SpriteFactory.portrait_trimmed("p1_club_worm") == null)
	var chip := UI.chip("●", "5", "icon_coin")
	assert_true(chip.find_child("IconArt", true, false) == null, "no art: symbol chip")
	var txt := ""
	for l in chip.find_children("*", "Label", true, false):
		txt = (l as Label).text
	assert_eq(txt, "● 5")
	chip.free()
	var b := BaseView.new()
	b.setup(BattleSim.PLAYER, "Burrow", 1)
	assert_true(b.art == null)
	assert_eq(b.top_y(), -BaseView.H)
	b.free()
	var bg := BattleBackground.new()
	bg.setup(Vector2(540, 960), 557.0, 1)
	assert_true(bg.art == null)
	bg.free()
	var fx := BattleEffects.new()
	fx.add_impact(Vector2(10, 10))
	assert_eq(fx.count_kind("spark"), 1, "code spark without fx_impact")
	assert_eq(fx.count_kind("impact"), 0)
	fx.free()
	assert_eq(BattleEffects.projectile_art_id("p1_slinger_worm", 1), "")
	var c := CardButton.new("x", "1")
	c.set_art(SpriteFactory.portrait_trimmed("p1_club_worm"))
	assert_true(not c.has_art())
	c.free()

func test_listed_but_file_missing_falls_back() -> void:
	SpriteManifest.set_entries({"icon_coin": _static("icon_coin", TMP + "/nope.png", 32, 32),
		"base_p1": _static("base_p1", TMP + "/nope2.png", 32, 32)})
	assert_true(SpriteFactory.texture_of("icon_coin") == null)
	var b := BaseView.new()
	b.setup(BattleSim.PLAYER, "Burrow", 1)
	assert_true(b.art == null)
	b.free()

func test_art_present_is_used() -> void:
	SpriteManifest.set_entries(_full_manifest())
	assert_true(SpriteFactory.texture_of("icon_coin") != null)
	assert_true(SpriteFactory.texture_of("p1_club_worm") == null, "animated entries are not static textures")
	var ic := SpriteFactory.icon("icon_coin", 20.0)
	assert_true(ic != null and ic.custom_minimum_size == Vector2(20, 20))
	ic.free()
	var chip := UI.chip("●", "5", "icon_coin")
	assert_true(chip.find_child("IconArt", true, false) != null)
	chip.free()
	# Bases: id derived from the era; the enemy art (facing right in the manifest) is flipped to face left.
	var p := BaseView.new()
	p.setup(BattleSim.PLAYER, "Burrow", 1)
	var e := BaseView.new()
	e.setup(BattleSim.ENEMY, "Anthill", 1)
	assert_true(p.art != null and e.art != null)
	assert_true(not p.art_flip)
	assert_true(e.art_flip)
	assert_true(p.top_y() < -50.0)
	var none := BaseView.new()
	none.setup(BattleSim.PLAYER, "x", 2)   # no base_p2 in the manifest
	assert_true(none.art == null)
	p.free()
	e.free()
	none.free()
	var bg := BattleBackground.new()
	bg.setup(Vector2(540, 960), 557.0, 1)
	assert_true(bg.art != null)
	var r := bg._art_rect()
	assert_true(r.size.x >= 540.0 and r.size.y >= 960.0, "cover: never smaller than the screen")
	assert_near(r.size.x / r.size.y, 108.0 / 193.0, 0.001, "aspect kept")
	bg.drift(10.0)
	r = bg._art_rect()
	assert_true(r.position.x <= 0.0 and r.end.x >= 540.0, "sway never shows an edge")
	bg.setup(Vector2(540, 960), 557.0, 2)
	assert_true(bg.art == null, "no bg_era2: code background")
	bg.free()
	# Effects.
	var fx := BattleEffects.new()
	fx.add_impact(Vector2(10, 10), true)
	assert_eq(fx.count_kind("impact"), 1)
	assert_eq(fx.count_kind("spark"), 0)
	fx.free()
	assert_eq(BattleEffects.projectile_art_id("p1_slinger_worm", 1), "proj_stone")
	assert_eq(BattleEffects.projectile_art_id("p1_slinger_worm", 2), "")
	# Cards: unit portrait (idle frame 0, trimmed to its visible part).
	var pt := SpriteFactory.portrait_trimmed("p1_club_worm")
	assert_true(pt != null)
	assert_true(pt.get_width() < 40 and pt.get_width() > 0, "portrait cropped to the visible area")
	var c := CardButton.new("Club", "50")
	c.set_art(pt, "portrait")
	assert_true(c.has_art())
	c.set_art(null)
	assert_true(not c.has_art())
	c.free()
	SpriteManifest.reset()

func test_portrait_falls_back_to_ref() -> void:
	DirAccess.make_dir_recursive_absolute(TMP)
	var ref := _png("p1_x_ref", 64, 64)
	var f := FileAccess.open(TMP + "/m.json", FileAccess.WRITE)
	f.store_string(JSON.stringify({"refs": {"p1_x": ref}, "sprites": {}}))
	f.close()
	SpriteManifest.use_path(TMP + "/m.json")
	assert_true(SpriteFactory.portrait_of("p1_x") != null, "ref image when there is no idle animation")
	assert_true(SpriteFactory.portrait_of("p1_y") == null)
	SpriteManifest.reset()

func test_zzz_reset() -> void:
	SpriteManifest.reset()
	assert_true(true)
