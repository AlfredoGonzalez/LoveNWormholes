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

func test_resolve_path() -> void:
	assert_eq(SpriteManifest.resolve_path("assets/a.png"), "res://assets/a.png")
	assert_eq(SpriteManifest.resolve_path("user://a.png"), "user://a.png")

func test_shipped_manifest_loads() -> void:
	SpriteManifest.reset()
	assert_true(SpriteManifest.ids() is Array)
