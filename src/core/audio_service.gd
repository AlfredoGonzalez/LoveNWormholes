class_name AudioService
extends Node
## Placeholder audio (spec 9.5): every SFX event is synthesized in code as an AudioStreamWAV (no files).
## The data side (names, streams, volume maths) works without an audio device; playback is skipped when the
## headless dummy audio driver is active or the node is not in the scene tree.
## Add it to the tree (autoload or child) to hear sounds. Settings: music / sfx volume 0..1 and mute.

const MIX_RATE := 22050
const MAX_VOICES := 8

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
	"coin": {"notes": [[988, 0.05], [1319, 0.12]], "wave": "square", "vol": 0.35},
	"gem": {"notes": [[1175, 0.05], [1568, 0.05], [2093, 0.12]], "wave": "sine", "vol": 0.4},
	"capsule_common": {"notes": [[392, 0.08], [523, 0.12]], "wave": "sine", "vol": 0.5},
	"capsule_rare": {"notes": [[392, 0.08], [523, 0.08], [659, 0.16]], "wave": "sine", "vol": 0.55},
	"capsule_epic": {"notes": [[392, 0.07], [523, 0.07], [659, 0.07], [784, 0.07], [1047, 0.25]], "wave": "sine", "vol": 0.6},
	"ad_reward": {"notes": [[523, 0.07], [659, 0.07], [784, 0.07], [1047, 0.15]], "wave": "square", "vol": 0.35},
	"victory": {"notes": [[523, 0.12], [659, 0.12], [784, 0.12], [1047, 0.35]], "wave": "square", "vol": 0.45},
	"defeat": {"notes": [[392, 0.18], [330, 0.18], [262, 0.18], [196, 0.4]], "wave": "square", "vol": 0.45},
}

var music_volume := 0.7
var sfx_volume := 1.0
var muted := false
var last_played := ""
var play_count := 0
var _cache := {}
var _players: Array[AudioStreamPlayer] = []
var _next_player := 0

static func sfx_names() -> Array:
	return SFX.keys()

func apply_settings(settings: Dictionary) -> void:
	music_volume = clampf(float(settings.get("music", music_volume)), 0.0, 1.0)
	sfx_volume = clampf(float(settings.get("sfx", sfx_volume)), 0.0, 1.0)
	muted = bool(settings.get("muted", muted))

func set_music_volume(v: float) -> void:
	music_volume = clampf(v, 0.0, 1.0)

func set_sfx_volume(v: float) -> void:
	sfx_volume = clampf(v, 0.0, 1.0)

func set_muted(m: bool) -> void:
	muted = m

## Linear gain actually applied to SFX (0 when muted).
func effective_sfx_volume() -> float:
	return 0.0 if muted else sfx_volume

func effective_music_volume() -> float:
	return 0.0 if muted else music_volume

func get_stream(sfx_name: String) -> AudioStreamWAV:
	if not SFX.has(sfx_name):
		return null
	if not _cache.has(sfx_name):
		_cache[sfx_name] = _synthesize(SFX[sfx_name])
	return _cache[sfx_name]

## Plays the effect. Returns true if it was (or, without an audio device, would have been) played; false for an
## unknown name or when muted / sfx volume is 0.
func play_sfx(sfx_name: String) -> bool:
	var stream := get_stream(sfx_name)
	if stream == null or effective_sfx_volume() <= 0.0:
		return false
	last_played = sfx_name
	play_count += 1
	if not _can_output():
		return true
	if _players.is_empty():
		for i in MAX_VOICES:
			var pl := AudioStreamPlayer.new()
			add_child(pl)
			_players.append(pl)
	var player := _players[_next_player]
	_next_player = (_next_player + 1) % MAX_VOICES
	player.stream = stream
	player.volume_db = linear_to_db(effective_sfx_volume())
	player.play()
	return true

func _can_output() -> bool:
	return is_inside_tree() and DisplayServer.get_name() != "headless" and AudioServer.get_driver_name() != "Dummy"

static func _synthesize(def: Dictionary) -> AudioStreamWAV:
	var samples := PackedByteArray()
	var rng := RandomNumberGenerator.new()
	rng.seed = 1234   # deterministic noise
	var vol: float = def["vol"]
	for note in def["notes"]:
		var freq: float = note[0]
		var n := int(MIX_RATE * float(note[1]))
		var start := samples.size()
		samples.resize(start + n * 2)
		for i in n:
			var t := float(i) / MIX_RATE
			var env := 1.0 - float(i) / n          # linear decay
			env = minf(env, minf(1.0, float(i) / 50.0))   # tiny attack to avoid clicks
			var v := 0.0
			match def["wave"]:
				"square": v = 1.0 if fmod(t * freq, 1.0) < 0.5 else -1.0
				"sine": v = sin(TAU * freq * t)
				"noise": v = rng.randf_range(-1.0, 1.0)
			if freq <= 0.0:
				v = 0.0
			samples.encode_s16(start + i * 2, int(clampf(v * env * vol, -1.0, 1.0) * 32767.0))
	var wav := AudioStreamWAV.new()
	wav.format = AudioStreamWAV.FORMAT_16_BITS
	wav.mix_rate = MIX_RATE
	wav.stereo = false
	wav.data = samples
	return wav
