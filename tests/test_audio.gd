extends TestCase

func _read_catalog() -> Dictionary:
	return JSON.parse_string(FileAccess.get_file_as_string("res://data/audio.json"))

func test_catalog_covers_every_synth_id_and_has_valid_fields() -> void:
	var c := _read_catalog()
	for id in AudioService.sfx_names():
		assert_true((c["sfx"] as Dictionary).has(id), "catalog sfx " + id)
	for id in AudioService.music_names():
		assert_true((c["music"] as Dictionary).has(id), "catalog music " + id)
	for kind in ["sfx", "music"]:
		for id in c[kind]:
			var e: Dictionary = c[kind][id]
			assert_true(str(e["file"]).begins_with("res://assets/audio/"), id + " file")
			assert_true(e["bus"] in ["Music", "SFX"], id + " bus")
			assert_true(float(e["volume"]) > 0.0 and float(e["volume"]) <= 2.0, id + " volume")
	assert_true(AudioService.music_names().size() >= 6)

func test_every_catalog_id_resolves_to_a_stream_even_without_files() -> void:
	var a := AudioService.new()
	for id in a.catalog()["sfx"]:
		assert_true(a.get_stream(id) != null, "sfx " + id)
	for id in a.catalog()["music"]:
		var s := a.get_music_stream(id) as AudioStreamWAV
		assert_true(s != null, "music " + id)
		if s != null:
			assert_true(s.get_length() > 2.0, id + " long enough")
			var loops: bool = a.catalog()["music"][id]["loop"]
			assert_eq(s.loop_mode == AudioStreamWAV.LOOP_FORWARD, loops, id + " loop flag")
	assert_true(a.get_music_stream("nope") == null)
	a.free()

func test_music_synth_is_deterministic_and_not_silent() -> void:
	var s1 := AudioService.synth_music(AudioService.MUSIC["battle_1"])
	var s2 := AudioService.synth_music(AudioService.MUSIC["battle_1"])
	assert_eq(s1.data, s2.data)
	var peak := 0
	for i in range(0, s1.data.size() - 1, 2):
		peak = maxi(peak, absi(s1.data.decode_s16(i)))
	assert_true(peak > 1000, "audible")
	assert_true(AudioService.synth_music(AudioService.MUSIC["boss"]).data != s1.data, "tracks differ")

func test_music_mapping_per_screen_and_era() -> void:
	var a := AudioService.new()
	assert_eq(a.music_for_screen("home"), "menu")
	assert_eq(a.music_for_screen("levels"), "map")
	assert_eq(a.music_for_screen("battle"), "", "battle picks its own track")
	for era in range(1, 6):
		assert_eq(a.music_for_battle(era, false), "battle_%d" % era)
	assert_eq(a.music_for_battle(3, true), "boss")
	a.free()

func test_crossfade_and_result_stingers() -> void:
	var a := AudioService.new()
	assert_true(a.play_music("menu"))
	assert_eq(a.current_music, "menu")
	assert_near(a.music_fade_levels()["current"], 1.0, 0.0001, "first track starts at once")
	a.play_music_for_screen("levels")
	assert_eq(a.current_music, "map")
	assert_eq(a.previous_music, "menu")
	a._process(a.crossfade_s * 0.5)
	assert_near(a.music_fade_levels()["current"], 0.5, 0.01)
	assert_near(a.music_fade_levels()["previous"], 0.5, 0.01)
	a._process(a.crossfade_s)
	assert_eq(a.previous_music, "")
	var n := a.music_changes
	a.play_music("map")
	assert_eq(a.music_changes, n, "same track does not restart")
	assert_true(not a.play_music("nope"))
	a.play_result_music(true)
	assert_eq(a.current_music, "victory")
	a.play_result_music(false)
	assert_eq(a.current_music, "defeat")
	a.free()

func test_ducking_dips_and_recovers() -> void:
	var a := AudioService.new()
	assert_near(a.duck_db, 0.0)
	a.duck(-8.0, 0.5)
	assert_near(a.duck_db, -8.0)
	a._process(0.3)
	assert_near(a.duck_db, -8.0, 0.0001, "held")
	a._process(0.3)
	a._process(a.duck_release_s * 0.5)
	assert_true(a.duck_db > -8.0 and a.duck_db < 0.0, "recovering")
	a._process(a.duck_release_s * 2.0)
	assert_near(a.duck_db, 0.0)
	a.free()

func test_stinger_sfx_trigger_duck() -> void:
	var a := AudioService.new()
	assert_true(a.play_sfx("victory"))
	assert_true(a.duck_db < 0.0)
	a.free()

func test_voice_limit_and_cooldown() -> void:
	var a := AudioService.new()
	for i in 30:
		a.play_sfx("power_cast_3")
	assert_true(a.active_voices() <= a.max_voices)
	assert_true(a.active_voices() >= 1)
	var b := AudioService.new()
	assert_true(b.play_sfx("hit"))
	assert_true(not b.play_sfx("hit"), "cooldown throttles spam")
	assert_true(b.play_sfx("coin"))
	a.free()
	b.free()

func test_buses_follow_settings_and_mute() -> void:
	var a := AudioService.new()
	a.apply_settings({"music": 0.5, "sfx": 0.25, "muted": false})
	var mi := AudioServer.get_bus_index("Music")
	var si := AudioServer.get_bus_index("SFX")
	assert_true(mi >= 0 and si >= 0, "buses created")
	assert_near(AudioServer.get_bus_volume_db(mi), linear_to_db(0.5), 0.01)
	assert_near(AudioServer.get_bus_volume_db(si), linear_to_db(0.25), 0.01)
	assert_true(not AudioServer.is_bus_mute(mi))
	a.set_muted(true)
	assert_true(AudioServer.is_bus_mute(mi) and AudioServer.is_bus_mute(si))
	a.set_muted(false)
	a.apply_settings({"music": 0.7, "sfx": 1.0})
	a.free()

func test_game_wires_navigation_and_ui_taps() -> void:
	var loop := Engine.get_main_loop()
	var g = (loop as SceneTree).root.get_node_or_null("Game") if loop is SceneTree else null
	if g == null:
		return   # autoload not available in this runner
	g.boot("user://test_audio_save.json")
	g.audio.stop_music()
	g.nav.changed.emit("levels")
	assert_eq(g.audio.current_music, "map")
	var n: int = g.audio.play_count
	var b := UI.button("x")
	b.pressed.emit()
	assert_eq(g.audio.last_played, "ui_tap")
	assert_eq(g.audio.play_count, n + 1)
	b.free()
