extends TestCase

const TMP := "user://test_sprite_manifest"

func _write(path: String, text: String) -> void:
	DirAccess.make_dir_recursive_absolute(TMP)
	var f := FileAccess.open(path, FileAccess.WRITE)
	f.store_string(text)
	f.close()

func test_missing_manifest() -> void:
	SpriteManifest.use_path(TMP + "/does_not_exist.json")
	assert_true(not SpriteManifest.has_entry("p1_club_worm"))
	assert_eq(SpriteManifest.get_entry("p1_club_worm"), {})
	assert_eq(SpriteManifest.ids().size(), 0)
	SpriteManifest.reset()

func test_empty_and_malformed_manifest() -> void:
	var p := TMP + "/empty.json"
	_write(p, "")
	SpriteManifest.use_path(p)
	assert_eq(SpriteManifest.ids().size(), 0)
	_write(p, "{not json")
	SpriteManifest.use_path(p)
	assert_eq(SpriteManifest.ids().size(), 0)
	_write(p, "[1,2]")
	SpriteManifest.use_path(p)
	assert_eq(SpriteManifest.get_entry("x"), {})
	SpriteManifest.reset()

func test_loads_entries() -> void:
	var p := TMP + "/ok.json"
	_write(p, '{"version":1,"sprites":{"p1_a":{"id":"p1_a","frame_w":10,"frame_h":20}}}')
	SpriteManifest.use_path(p)
	assert_true(SpriteManifest.has_entry("p1_a"))
	assert_eq(int(SpriteManifest.get_entry("p1_a")["frame_h"]), 20)
	assert_true(not SpriteManifest.has_entry("nope"))
	SpriteManifest.reset()

func test_anim_format_helpers() -> void:
	var p := TMP + "/anims.json"
	_write(p, '{"version":2,"sprites":{"p1_a":{"id":"p1_a","format":2,"expected_anims":["idle","walk","attack"],'
		+ '"anims":{"idle":{"path":"assets/x.png","frame_w":8,"frame_h":9,"fps":12,"loop":true}}},'
		+ '"p1_old":{"id":"p1_old","rows":["idle","walk"]}},"refs":{"p1_a":"assets/r.png"}}')
	SpriteManifest.use_path(p)
	assert_true(SpriteManifest.is_anim_format(SpriteManifest.get_entry("p1_a")))
	assert_true(not SpriteManifest.is_anim_format(SpriteManifest.get_entry("p1_old")))
	assert_eq(SpriteManifest.anim_names("p1_a"), ["idle"])
	assert_eq(SpriteManifest.anim_names("p1_old"), ["idle", "walk"])
	assert_eq(SpriteManifest.missing_anims("p1_a"), ["walk", "attack"])
	assert_true(SpriteManifest.has_anim("p1_a", "idle") and not SpriteManifest.has_anim("p1_a", "attack"))
	assert_eq(int(SpriteManifest.get_anim("p1_a", "idle")["frame_h"]), 9)
	assert_eq(SpriteManifest.get_anim("p1_a", "attack"), {})
	assert_eq(SpriteManifest.anim_names("nope"), [])
	# Tolerant: junk shapes do not crash.
	_write(p, '{"sprites":{"p1_b":{"anims":[1],"expected_anims":"x"},"p1_c":{"anims":{"idle":5}}}}')
	SpriteManifest.use_path(p)
	assert_eq(SpriteManifest.anim_names("p1_b"), [])
	assert_eq(SpriteManifest.missing_anims("p1_b"), [])
	assert_eq(SpriteManifest.get_anim("p1_c", "idle"), {})
	SpriteManifest.reset()

func test_resolve_path() -> void:
	assert_eq(SpriteManifest.resolve_path("assets/a.png"), "res://assets/a.png")
	assert_eq(SpriteManifest.resolve_path("user://a.png"), "user://a.png")

func test_shipped_manifest_loads() -> void:
	SpriteManifest.reset()
	assert_true(SpriteManifest.ids() is Array)
