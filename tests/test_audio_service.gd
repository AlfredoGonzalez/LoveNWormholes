extends TestCase

func test_every_spec_sfx_has_a_stream() -> void:
	var required := ["spawn", "hit", "death", "base_hit", "power_cast_1", "power_cast_2", "power_cast_3",
		"power_cast_4", "power_cast_5", "power_cast_6", "ui_tap", "coin", "gem", "capsule_common",
		"capsule_rare", "capsule_epic", "ad_reward", "victory", "defeat"]
	var a := AudioService.new()
	for n in required:
		assert_true(AudioService.sfx_names().has(n), "missing " + n)
		var s := a.get_stream(n) as AudioStreamWAV
		assert_true(s != null, n)
		if s != null:
			assert_eq(s.format, AudioStreamWAV.FORMAT_16_BITS)
			assert_true(s.data.size() > 200, n + " has audio data")
			assert_true(s.get_length() < 2.0, n + " is short")
	assert_true(a.get_stream("nope") == null)
	a.free()

func test_play_respects_volume_and_mute() -> void:
	var a := AudioService.new()
	assert_true(a.play_sfx("coin"), "headless: counted without output")
	assert_eq(a.last_played, "coin")
	assert_true(not a.play_sfx("unknown"))
	a.set_muted(true)
	assert_true(not a.play_sfx("gem"))
	assert_near(a.effective_sfx_volume(), 0.0)
	a.set_muted(false)
	a.set_sfx_volume(0.0)
	assert_true(not a.play_sfx("gem"))
	a.apply_settings({"music": 2.0, "sfx": 0.5, "muted": false})
	assert_near(a.music_volume, 1.0, 0.0001, "clamped")
	assert_near(a.effective_sfx_volume(), 0.5)
	assert_true(a.play_sfx("victory"))
	a.free()

func test_streams_are_cached_and_deterministic() -> void:
	var a := AudioService.new()
	assert_true(a.get_stream("hit") == a.get_stream("hit"))
	var b := AudioService.new()
	assert_eq(a.get_stream("hit").data, b.get_stream("hit").data)
	a.free()
	b.free()
