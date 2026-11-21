class_name AudioService
extends Node
## Audio (spec 9.5). Catalog in data/audio.json: id -> {file, bus, volume}. If a file does not exist the sound is
## synthesized in code (SFX beeps/noise, music loops from small chord/arpeggio recipes), so nothing is ever mute.
## Buses "Music" and "SFX" are created at runtime; Settings volumes + mute drive the bus levels.
## Features: music crossfade, ducking (music dips under stingers/warnings), pooled SFX voices with a voice limit
## and per-id cooldowns. The data side works without an audio device; playback is skipped when the headless
## dummy audio driver is active or the node is not in the scene tree. Add it to the tree to hear sounds.

const MIX_RATE := 22050
const MUSIC_RATE := 16000
const CATALOG_PATH := "res://data/audio.json"
const BUS_MUSIC := "Music"
const BUS_SFX := "SFX"

## name -> {notes: [[freq_hz, seconds], ...], wave: "square"|"sine"|"noise", vol: 0..1}. freq 0 = silence.
const SFX := {
	"spawn": {"notes": [[330, 0.05], [494, 0.07]], "wave": "square", "vol": 0.35},
	"hit": {"notes": [[180, 0.05]], "wave": "noise", "vol": 0.4},
	"death": {"notes": [[330, 0.08], [220, 0.08], [147, 0.14]], "wave": "square", "vol": 0.4},
	"base_hit": {"notes": [[110, 0.12], [82, 0.16]], "wave": "noise", "vol": 0.6},
	"power_cast_1": {"notes": [[440, 0.06], [660, 0.1]], "wave": "sine", "vol": 0.5},
	"power_cast_2": {"notes": [[523, 0.06], [392, 0.06], [784, 0.1]], "wave": "sine", "vol": 0.5},
	"power_cast_3": {"notes": [[220, 0.12], [330, 0.12]], "wave": "square", "vol": 0.4},
	"power_cast_4": {"notes": [[600, 0.04], [900, 0.04], [1200, 0.08]], "wave": "sine", "vol": 0.5},
	"power_cast_5": {"notes": [[300, 0.1], [200, 0.1], [100, 0.12]], "wave": "noise", "vol": 0.5},
	"power_cast_6": {"notes": [[392, 0.07], [523, 0.07], [659, 0.07], [784, 0.12]], "wave": "sine", "vol": 0.5},
	"ui_tap": {"notes": [[800, 0.03]], "wave": "square", "vol": 0.3},
	"ui_back": {"notes": [[600, 0.03], [450, 0.04]], "wave": "square", "vol": 0.3},
	"coin": {"notes": [[988, 0.05], [1319, 0.12]], "wave": "square", "vol": 0.35},
	"gem": {"notes": [[1175, 0.05], [1568, 0.05], [2093, 0.12]], "wave": "sine", "vol": 0.4},
	"buy": {"notes": [[659, 0.05], [880, 0.05], [1319, 0.14]], "wave": "square", "vol": 0.35},
	"capsule_common": {"notes": [[392, 0.08], [523, 0.12]], "wave": "sine", "vol": 0.5},
	"capsule_rare": {"notes": [[392, 0.08], [523, 0.08], [659, 0.16]], "wave": "sine", "vol": 0.55},
	"capsule_epic": {"notes": [[392, 0.07], [523, 0.07], [659, 0.07], [784, 0.07], [1047, 0.25]], "wave": "sine", "vol": 0.6},
	"ad_reward": {"notes": [[523, 0.07], [659, 0.07], [784, 0.07], [1047, 0.15]], "wave": "square", "vol": 0.35},
	"boss_warning": {"notes": [[220, 0.15], [0, 0.05], [220, 0.15], [0, 0.05], [185, 0.3]], "wave": "square", "vol": 0.5},
	"victory": {"notes": [[523, 0.12], [659, 0.12], [784, 0.12], [1047, 0.35]], "wave": "square", "vol": 0.45},
	"defeat": {"notes": [[392, 0.18], [330, 0.18], [262, 0.18], [196, 0.4]], "wave": "square", "vol": 0.45},
}

## Music recipes. root = MIDI note, scale = semitone steps, prog = scale degrees of the chord of each bar,
## arp = chord-tone indices (0..5, >2 = octave up) per eighth note (8 per bar), lead/bass = waveform,
## pluck = note decay (higher = shorter), drums = noise ticks (0 none, 1 beat, 2 beat + backbeat accent).
## loop=false makes a short stinger. All loops are a whole number of bars, so they repeat seamlessly.
const MUSIC := {
	"menu": {"bpm": 92, "root": 60, "scale": [0, 2, 4, 5, 7, 9, 11], "prog": [0, 4, 5, 3], "arp": [0, 1, 2, 1, 3, 2, 1, 2],
		"lead": "sine", "bass": "sine", "pluck": 2.0, "drums": 0, "vol": 0.5},
	"map": {"bpm": 104, "root": 62, "scale": [0, 2, 4, 5, 7, 9, 11], "prog": [0, 5, 3, 4], "arp": [0, 2, 1, 2, 0, 2, 4, 2],
		"lead": "tri", "bass": "sine", "pluck": 3.0, "drums": 1, "vol": 0.5},
	"battle_1": {"bpm": 120, "root": 57, "scale": [0, 3, 5, 7, 10], "prog": [0, 0, 3, 2], "arp": [0, 0, 1, 0, 2, 0, 1, 2],
		"lead": "tri", "bass": "sine", "pluck": 4.0, "drums": 2, "vol": 0.55},
	"battle_2": {"bpm": 108, "root": 57, "scale": [0, 1, 4, 5, 7, 8, 10], "prog": [0, 1, 0, 4], "arp": [0, 1, 2, 3, 2, 1, 2, 1],
		"lead": "tri", "bass": "tri", "pluck": 1.5, "drums": 1, "vol": 0.55},
	"battle_3": {"bpm": 112, "root": 55, "scale": [0, 2, 4, 5, 7, 9, 11], "prog": [0, 3, 4, 0], "arp": [0, 1, 2, 1, 3, 1, 2, 1],
		"lead": "tri", "bass": "sine", "pluck": 6.0, "drums": 1, "vol": 0.55},
	"battle_4": {"bpm": 124, "root": 52, "scale": [0, 2, 3, 5, 7, 8, 10], "prog": [0, 5, 2, 6], "arp": [0, 2, 0, 2, 1, 2, 1, 2],
		"lead": "square", "bass": "saw", "pluck": 3.5, "drums": 2, "vol": 0.4},
	"battle_5": {"bpm": 128, "root": 57, "scale": [0, 2, 3, 5, 7, 9, 10], "prog": [0, 3, 5, 4], "arp": [0, 3, 1, 4, 2, 5, 1, 3],
		"lead": "saw", "bass": "sine", "pluck": 4.5, "drums": 2, "vol": 0.35},
	"boss": {"bpm": 138, "root": 50, "scale": [0, 2, 3, 5, 7, 8, 11], "prog": [0, 0, 5, 4], "arp": [0, 2, 0, 2, 3, 2, 0, 2],
		"lead": "square", "bass": "saw", "pluck": 3.0, "drums": 2, "vol": 0.4},
	"victory": {"bpm": 120, "root": 60, "scale": [0, 2, 4, 5, 7, 9, 11], "prog": [0, 4], "arp": [0, 1, 2, 3, 2, 3, 5, 5],
		"lead": "square", "bass": "sine", "pluck": 1.5, "drums": 0, "vol": 0.4, "loop": false},
	"defeat": {"bpm": 76, "root": 57, "scale": [0, 2, 3, 5, 7, 8, 10], "prog": [0, 5], "arp": [2, 1, 0, 0, 0, 0, 0, 0],
		"lead": "sine", "bass": "sine", "pluck": 1.2, "drums": 0, "vol": 0.5, "loop": false},
}

var music_volume := 0.7
var sfx_volume := 1.0
var muted := false
var last_played := ""
var play_count := 0
var max_voices := 8
var crossfade_s := 1.2
var duck_release_s := 0.8

var current_music := ""
var previous_music := ""         # the track fading out (empty when no crossfade is running)
var fade_progress := 1.0         # 0..1 crossfade progress; 1 = finished
var duck_db := 0.0               # current music dip (<= 0), recovers to 0
var music_changes := 0

var _catalog := {}
var _cache := {}
var _music_cache := {}
var _players: Array[AudioStreamPlayer] = []
var _voice_until: Array[float] = []   # logical voice slots: engine time (s) at which each slot frees up
var _last_at := {}                    # sfx id -> last play time (s), for cooldowns
var _clock := 0.0
var _duck_target := 0.0
var _duck_hold := 0.0
var _music_players: Array[AudioStreamPlayer] = []
var _cur_player := 0

func _init() -> void:
	_load_catalog()

func _load_catalog() -> void:
	_catalog = {}
	if FileAccess.file_exists(CATALOG_PATH):
		var parsed = JSON.parse_string(FileAccess.get_file_as_string(CATALOG_PATH))
		if parsed is Dictionary:
			_catalog = parsed
	max_voices = clampi(int(_catalog.get("max_voices", max_voices)), 1, 32)
	crossfade_s = maxf(0.0, float(_catalog.get("crossfade_s", crossfade_s)))
	duck_release_s = maxf(0.05, float(_catalog.get("duck_release_s", duck_release_s)))

static func sfx_names() -> Array:
	return SFX.keys()

static func music_names() -> Array:
	return MUSIC.keys()

func catalog() -> Dictionary:
	return _catalog

# ------------------------------------------------------------------ settings and buses

func apply_settings(settings: Dictionary) -> void:
	music_volume = clampf(float(settings.get("music", music_volume)), 0.0, 1.0)
	sfx_volume = clampf(float(settings.get("sfx", sfx_volume)), 0.0, 1.0)
	muted = bool(settings.get("muted", muted))
	_apply_buses()

func set_music_volume(v: float) -> void:
	music_volume = clampf(v, 0.0, 1.0)
	_apply_buses()

func set_sfx_volume(v: float) -> void:
	sfx_volume = clampf(v, 0.0, 1.0)
	_apply_buses()

func set_muted(m: bool) -> void:
	muted = m
	_apply_buses()

## Linear gain actually applied to SFX (0 when muted).
func effective_sfx_volume() -> float:
	return 0.0 if muted else sfx_volume

func effective_music_volume() -> float:
	return 0.0 if muted else music_volume

## Creates the Music and SFX buses (routed to Master) when missing. Returns the bus index or -1.
static func ensure_bus(bus_name: String) -> int:
	var idx := AudioServer.get_bus_index(bus_name)
	if idx == -1:
		AudioServer.add_bus()
		idx = AudioServer.bus_count - 1
		AudioServer.set_bus_name(idx, bus_name)
		AudioServer.set_bus_send(idx, "Master")
	return idx

func _apply_buses() -> void:
	var mi := ensure_bus(BUS_MUSIC)
	var si := ensure_bus(BUS_SFX)
	var mv := effective_music_volume()
	var sv := effective_sfx_volume()
	AudioServer.set_bus_mute(mi, mv <= 0.0)
	AudioServer.set_bus_mute(si, sv <= 0.0)
	AudioServer.set_bus_volume_db(mi, linear_to_db(maxf(mv, 0.0001)) + duck_db)
	AudioServer.set_bus_volume_db(si, linear_to_db(maxf(sv, 0.0001)))

# ------------------------------------------------------------------ streams (file or synthesized)

func has_sfx(sfx_name: String) -> bool:
	return SFX.has(sfx_name) or (_catalog.get("sfx", {}) as Dictionary).has(sfx_name)

func get_stream(sfx_name: String) -> AudioStream:
	if not _cache.has(sfx_name):
		var s: AudioStream = _load_file("sfx", sfx_name)
		if s == null and SFX.has(sfx_name):
			s = _synthesize(SFX[sfx_name])
		if s == null:
			return null
		_cache[sfx_name] = s
	return _cache[sfx_name]

func get_music_stream(music_id: String) -> AudioStream:
	if not _music_cache.has(music_id):
		var s: AudioStream = _load_file("music", music_id)
		if s == null and MUSIC.has(music_id):
			s = synth_music(MUSIC[music_id])
		if s == null:
			return null
		_music_cache[music_id] = s
	return _music_cache[music_id]

## True when the id is served by a real file (not the synthesized placeholder).
func uses_file(kind: String, id: String) -> bool:
	return _load_file(kind, id) != null

func _load_file(kind: String, id: String) -> AudioStream:
	var entry: Dictionary = (_catalog.get(kind, {}) as Dictionary).get(id, {})
	var path := str(entry.get("file", ""))
	if path != "" and ResourceLoader.exists(path):
		var r = load(path)
		if r is AudioStream:
			return r
	return null

func _entry(kind: String, id: String) -> Dictionary:
	return (_catalog.get(kind, {}) as Dictionary).get(id, {})

# ------------------------------------------------------------------ SFX

## Plays the effect. Returns true if it was (or, without an audio device, would have been) played; false for an
## unknown name, when muted / sfx volume is 0, or when throttled by the id's cooldown.
func play_sfx(sfx_name: String) -> bool:
	if effective_sfx_volume() <= 0.0:
		return false
	var stream := get_stream(sfx_name)
	if stream == null:
		return false
	var entry := _entry("sfx", sfx_name)
	var now := Time.get_ticks_msec() / 1000.0
	var cd := float(entry.get("cooldown", 0.0))
	if cd > 0.0 and now - float(_last_at.get(sfx_name, -100.0)) < cd:
		return false
	_last_at[sfx_name] = now
	last_played = sfx_name
	play_count += 1
	var dd := float(entry.get("duck_db", 0.0))
	if dd < 0.0:
		duck(dd, stream.get_length() + 0.2)
	var slot := _take_voice(now, stream.get_length())
	if not _can_output():
		return true
	if _players.is_empty():
		for i in max_voices:
			var pl := AudioStreamPlayer.new()
			pl.bus = BUS_SFX
			add_child(pl)
			_players.append(pl)
	var player := _players[mini(slot, _players.size() - 1)]
	player.stream = stream
	player.volume_db = linear_to_db(clampf(float(entry.get("volume", 1.0)), 0.0001, 2.0))
	player.play()
	return true

## Logical voice pool: free slot first, else steal the one that ends soonest (voice limit = max_voices).
func _take_voice(now: float, length: float) -> int:
	while _voice_until.size() < max_voices:
		_voice_until.append(0.0)
	var best := 0
	for i in _voice_until.size():
		if _voice_until[i] <= now:
			best = i
			break
		if _voice_until[i] < _voice_until[best]:
			best = i
	_voice_until[best] = now + length
	return best

## Number of SFX voices currently sounding (never above max_voices).
func active_voices() -> int:
	var now := Time.get_ticks_msec() / 1000.0
	var n := 0
	for u in _voice_until:
		if u > now:
			n += 1
	return n

# ------------------------------------------------------------------ music

## Music id for a screen name (data/audio.json "music_map"), "" when the screen keeps the current track.
func music_for_screen(screen_name: String) -> String:
	return str((_catalog.get("music_map", {}) as Dictionary).get(screen_name, ""))

func music_for_battle(era: int, boss: bool) -> String:
	var mm: Dictionary = _catalog.get("music_map", {})
	if boss:
		return str(mm.get("boss", "boss"))
	return str((mm.get("battle_era", {}) as Dictionary).get(str(era), "battle_1"))

## Switches the screen music (no-op for screens without an entry or when the track is already playing).
func play_music_for_screen(screen_name: String) -> void:
	var id := music_for_screen(screen_name)
	if id != "":
		play_music(id)

func play_music_for_battle(era: int, boss := false) -> void:
	play_music(music_for_battle(era, boss))

func play_result_music(win: bool) -> void:
	var mm: Dictionary = _catalog.get("music_map", {})
	play_music(str(mm.get("win", "victory")) if win else str(mm.get("lose", "defeat")))

## Crossfades to the track. Returns false for an unknown id; true if already playing it or the fade started.
func play_music(music_id: String) -> bool:
	if music_id == current_music:
		return true
	if get_music_stream(music_id) == null:
		return false
	previous_music = current_music
	current_music = music_id
	fade_progress = 0.0 if previous_music != "" and crossfade_s > 0.0 else 1.0
	if fade_progress >= 1.0:
		previous_music = ""
	music_changes += 1
	if _can_output():
		_start_music_player(music_id)
	return true

func stop_music() -> void:
	current_music = ""
	previous_music = ""
	fade_progress = 1.0
	for p in _music_players:
		p.stop()

## Linear gains of the current and the fading-out track (equal-power-ish linear crossfade).
func music_fade_levels() -> Dictionary:
	if previous_music == "":
		return {"current": 1.0, "previous": 0.0}
	return {"current": fade_progress, "previous": 1.0 - fade_progress}

func _start_music_player(music_id: String) -> void:
	if _music_players.is_empty():
		for i in 2:
			var mp := AudioStreamPlayer.new()
			mp.bus = BUS_MUSIC
			add_child(mp)
			_music_players.append(mp)
	_cur_player = 1 - _cur_player if previous_music != "" else _cur_player
	var p := _music_players[_cur_player]
	p.stream = get_music_stream(music_id)
	p.volume_db = linear_to_db(0.0001) if previous_music != "" else _gain_db(music_id)
	p.play()
	if previous_music == "":
		_music_players[1 - _cur_player].stop()

func _gain_db(music_id: String) -> float:
	return linear_to_db(clampf(float(_entry("music", music_id).get("volume", 1.0)), 0.0001, 2.0))

# ------------------------------------------------------------------ ducking

## Dips the music bus by `db` (negative) for `hold` seconds, then it recovers over duck_release_s.
func duck(db: float, hold := 0.6) -> void:
	_duck_target = minf(_duck_target, minf(db, 0.0))
	_duck_hold = maxf(_duck_hold, hold)
	duck_db = minf(duck_db, _duck_target)
	if _can_output():
		_apply_buses()

func _process(delta: float) -> void:
	_clock += delta
	if fade_progress < 1.0:
		fade_progress = minf(1.0, fade_progress + delta / maxf(crossfade_s, 0.001))
		if fade_progress >= 1.0:
			previous_music = ""
			if _music_players.size() == 2:
				_music_players[1 - _cur_player].stop()
		_update_music_players()
	if _duck_hold > 0.0:
		_duck_hold -= delta
	elif duck_db < 0.0:
		duck_db = minf(0.0, duck_db + absf(_duck_target) * delta / duck_release_s)
		if duck_db >= 0.0:
			duck_db = 0.0
			_duck_target = 0.0
	if _can_output():
		_apply_buses()

func _update_music_players() -> void:
	if _music_players.size() < 2:
		return
	var lv := music_fade_levels()
	var cur := _music_players[_cur_player]
	cur.volume_db = linear_to_db(maxf(float(lv["current"]), 0.0001)) + _gain_db(current_music)
	var prev := _music_players[1 - _cur_player]
	if previous_music != "" and prev.playing:
		prev.volume_db = linear_to_db(maxf(float(lv["previous"]), 0.0001)) + _gain_db(previous_music)

func _can_output() -> bool:
	return is_inside_tree() and DisplayServer.get_name() != "headless" and AudioServer.get_driver_name() != "Dummy"

# ------------------------------------------------------------------ synthesis

static func _wave(kind: String, phase: float) -> float:
	match kind:
		"square": return 1.0 if fmod(phase, 1.0) < 0.5 else -1.0
		"saw": return fmod(phase, 1.0) * 2.0 - 1.0
		"tri": return absf(fmod(phase, 1.0) * 4.0 - 2.0) - 1.0
		_: return sin(TAU * phase)

static func _to_wav(buf: PackedFloat32Array, rate: int, loop: bool) -> AudioStreamWAV:
	var bytes := PackedByteArray()
	bytes.resize(buf.size() * 2)
	for i in buf.size():
		bytes.encode_s16(i * 2, int(clampf(buf[i], -1.0, 1.0) * 32767.0))
	var wav := AudioStreamWAV.new()
	wav.format = AudioStreamWAV.FORMAT_16_BITS
	wav.mix_rate = rate
	wav.stereo = false
	wav.data = bytes
	if loop:
		wav.loop_mode = AudioStreamWAV.LOOP_FORWARD
		wav.loop_begin = 0
		wav.loop_end = buf.size()
	return wav

static func _synthesize(def: Dictionary) -> AudioStreamWAV:
	var samples := PackedFloat32Array()
	var rng := RandomNumberGenerator.new()
	rng.seed = 1234   # deterministic noise
	var vol: float = def["vol"]
	for note in def["notes"]:
		var freq: float = note[0]
		var n := int(MIX_RATE * float(note[1]))
		var start := samples.size()
		samples.resize(start + n)
		for i in n:
			var t := float(i) / MIX_RATE
			var env := 1.0 - float(i) / n          # linear decay
			env = minf(env, minf(1.0, float(i) / 50.0))   # tiny attack to avoid clicks
			var v := 0.0
			if def["wave"] == "noise":
				v = rng.randf_range(-1.0, 1.0)
			else:
				v = _wave(str(def["wave"]), t * freq)
			if freq <= 0.0:
				v = 0.0
			samples[start + i] = v * env * vol
	return _to_wav(samples, MIX_RATE, false)

## Builds a track from a MUSIC recipe: bass on beats 1 and 3, eighth-note arpeggio, optional noise drums.
static func synth_music(def: Dictionary) -> AudioStreamWAV:
	var bpm: float = def["bpm"]
	var eighth := 60.0 / bpm / 2.0
	var per_eighth := int(round(eighth * MUSIC_RATE))
	var prog: Array = def["prog"]
	var arp: Array = def["arp"]
	var scale: Array = def["scale"]
	var total := per_eighth * 8 * prog.size()
	var buf := PackedFloat32Array()
	buf.resize(total)
	var rng := RandomNumberGenerator.new()
	rng.seed = 4321
	var root: int = def["root"]
	var pluck: float = def["pluck"]
	var vol: float = def["vol"]
	var drums: int = def["drums"]
	for bar in prog.size():
		var deg: int = prog[bar]
		var chord: Array = []
		for k in [0, 2, 4]:
			chord.append(_scale_midi(scale, root, deg + k))
		for step in 8:
			var base := (bar * 8 + step) * per_eighth
			var ci: int = arp[step]
			var m: int = chord[ci % 3] + (12 if ci >= 3 else 0)
			_add_note(buf, base, per_eighth * 2, _midi_hz(m), str(def["lead"]), pluck, vol * 0.5)
			if step % 4 == 0:
				_add_note(buf, base, per_eighth * 4, _midi_hz(chord[0] - 24 + 12), str(def["bass"]), pluck * 0.5, vol * 0.7)
			if drums > 0 and step % 2 == 0:
				var accent := step % 4 == 0 if drums == 1 else true
				_add_noise(buf, base, int(per_eighth * 0.5), vol * (0.35 if step % 4 == 0 else 0.18) * (1.0 if accent else 0.0), rng)
	# Stingers fade their last few ms; loops are left untouched so they repeat seamlessly.
	if not bool(def.get("loop", true)):
		var tail := mini(total, 160)
		for i in tail:
			buf[total - 1 - i] *= float(i) / tail
	return _to_wav(buf, MUSIC_RATE, bool(def.get("loop", true)))

static func _scale_midi(scale: Array, root: int, degree: int) -> int:
	var n := scale.size()
	return root + int(scale[degree % n]) + 12 * floori(float(degree) / n)

static func _midi_hz(m: int) -> float:
	return 440.0 * pow(2.0, (m - 69) / 12.0)

static func _add_note(buf: PackedFloat32Array, start: int, length: int, freq: float, kind: String, decay: float, amp: float) -> void:
	var end := mini(start + length, buf.size())
	for i in range(start, end):
		var k := float(i - start)
		var env := exp(-decay * k / length) * minf(1.0, k / 40.0)
		buf[i] += _wave(kind, k / MUSIC_RATE * freq) * env * amp

static func _add_noise(buf: PackedFloat32Array, start: int, length: int, amp: float, rng: RandomNumberGenerator) -> void:
	var end := mini(start + length, buf.size())
	for i in range(start, end):
		var env := 1.0 - float(i - start) / length
		buf[i] += rng.randf_range(-1.0, 1.0) * env * amp
