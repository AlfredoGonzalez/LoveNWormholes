extends TestCase

const P := "user://t_save.json"

func _clean() -> void:
	for p in [P, "user://t_save.bak.json", P + ".tmp"]:
		if FileAccess.file_exists(p):
			DirAccess.remove_absolute(p)

func _write_raw(p: String, text: String) -> void:
	var f := FileAccess.open(p, FileAccess.WRITE)
	f.store_string(text)
	f.close()

func test_roundtrip_and_types() -> void:
	_clean()
	var s := SaveService.new(P)
	s.profile["currencies"]["coins"] = 123
	s.profile["settings"]["music"] = 1.0
	assert_true(s.save())
	var s2 := SaveService.new(P)
	s2.load_profile()
	assert_eq(s2.load_source, "main")
	assert_eq(s2.profile["currencies"]["coins"], 123)
	assert_eq(s2.profile["settings"]["music"], 1.0, "float setting keeps float type")
	assert_eq(s2.profile["schema_version"], SaveService.CURRENT_VERSION)
	_clean()

func test_missing_file_gives_default() -> void:
	_clean()
	var s := SaveService.new(P)
	s.load_profile()
	assert_eq(s.load_source, "default")
	assert_eq(s.profile["currencies"]["gems"], 0)
	assert_true(s.profile.has("pending_rewards") and s.profile.has("purchases_granted"))
	_clean()

func test_tampered_main_falls_back_to_backup() -> void:
	_clean()
	var s := SaveService.new(P)
	s.profile["currencies"]["coins"] = 10
	s.save()
	s.profile["currencies"]["coins"] = 20
	s.save()   # backup now holds coins = 10
	# tamper: edit coins inside the payload without fixing the checksum
	var text := FileAccess.get_file_as_string(P)
	assert_true(text.contains("coins"))
	_write_raw(P, text.replace("\\\"coins\\\":20", "\\\"coins\\\":999999"))
	var s2 := SaveService.new(P)
	s2.load_profile()
	assert_eq(s2.load_source, "backup")
	assert_eq(s2.profile["currencies"]["coins"], 10)
	# loading from backup re-saves, so the main file is valid again
	var s3 := SaveService.new(P)
	s3.load_profile()
	assert_eq(s3.load_source, "main")
	assert_eq(s3.profile["currencies"]["coins"], 10)
	_clean()

func test_garbage_main_falls_back_to_backup() -> void:
	_clean()
	var s := SaveService.new(P)
	s.profile["currencies"]["gems"] = 7
	s.save()
	s.save()
	_write_raw(P, "{not json")
	var s2 := SaveService.new(P)
	s2.load_profile()
	assert_eq(s2.load_source, "backup")
	assert_eq(s2.profile["currencies"]["gems"], 7)
	_clean()

func test_both_corrupt_gives_fresh_default() -> void:
	_clean()
	var s := SaveService.new(P)
	s.profile["currencies"]["gems"] = 7
	s.save()
	s.save()
	_write_raw(P, "garbage")
	_write_raw("user://t_save.bak.json", "{\"checksum\":\"x\",\"payload\":\"{}\"}")
	var s2 := SaveService.new(P)
	s2.load_profile()
	assert_eq(s2.load_source, "default")
	assert_eq(s2.profile["currencies"]["gems"], 0)
	_clean()

func test_atomic_write_leaves_no_partial_file() -> void:
	_clean()
	var s := SaveService.new(P)
	for i in 3:
		s.profile["currencies"]["coins"] = i
		assert_true(s.save())
		assert_true(not FileAccess.file_exists(P + ".tmp"), "temp file renamed away")
	assert_true(FileAccess.file_exists(P))
	assert_true(FileAccess.file_exists("user://t_save.bak.json"))
	# a leftover half-written temp file (crash mid-write) never affects loading
	_write_raw(P + ".tmp", "{\"checksum\":\"half")
	var s2 := SaveService.new(P)
	s2.load_profile()
	assert_eq(s2.load_source, "main")
	assert_eq(s2.profile["currencies"]["coins"], 2)
	_clean()

func test_backup_not_overwritten_by_corrupt_main() -> void:
	_clean()
	var s := SaveService.new(P)
	s.profile["currencies"]["coins"] = 1
	s.save()
	s.profile["currencies"]["coins"] = 2
	s.save()   # bak = 1, main = 2
	_write_raw(P, "corrupt")
	s.profile["currencies"]["coins"] = 3
	s.save()   # must not copy the corrupt main over the good backup
	var bak := SaveService.new(P)
	bak._read_file(bak.backup_path)
	assert_eq(bak._read_file(bak.backup_path)["currencies"]["coins"], 1)
	_clean()

func _m1(d: Dictionary) -> Dictionary:
	d["renamed"] = d.get("old_name", 0)
	d.erase("old_name")
	return d

func test_migration_chain_v1_v2_current() -> void:
	_clean()
	# a fake v1 save written by an "old build"
	var old := SaveService.new(P, {}, 1)
	old.profile = {"schema_version": 1, "old_name": 5, "currencies": {"coins": 42}}
	old.save()
	var migs := {
		1: Callable(self, "_m1"),
		2: func(d: Dictionary) -> Dictionary:
			d["currencies"]["gems"] = int(d["renamed"]) * 2
			return d,
	}
	var s := SaveService.new(P, migs, 3)
	s.load_profile()
	assert_eq(s.profile["schema_version"], 3)
	assert_eq(s.profile["renamed"], 5)
	assert_eq(s.profile["currencies"]["gems"], 10)
	assert_eq(s.profile["currencies"]["coins"], 42)
	assert_true(not s.profile.has("old_name"))
	assert_true(s.profile.has("settings"), "defaults merged for new keys")
	# migrated profile was persisted at the new version
	var s2 := SaveService.new(P, migs, 3)
	s2.load_profile()
	assert_eq(s2.profile["schema_version"], 3)
	assert_eq(s2.profile["currencies"]["gems"], 10)
	_clean()
