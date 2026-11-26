class_name StudioIntro
extends Control
## Studio logo video, full screen. Emits `finished` when done, skipped (tap after 1 s) or when
## the video is missing. Silent when `muted` is true. Set `muted` before adding to the tree.

signal finished

const VIDEO_PATH := "res://assets/video/studio_intro.ogv"
const SKIP_AFTER := 1.0
const VIDEO_WIDTH_FRACTION := 0.6
const VIDEO_ASPECT := 1280.0 / 720.0   # height / width of the video

var muted := false
var video_path := VIDEO_PATH
var player: VideoStreamPlayer = null
var _elapsed := 0.0
var _done := false
var _waiting_tap := false     # web only: browsers block audio/video until the first tap
var _play_started := 0.0

func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_STOP
	var bg := ColorRect.new()
	bg.color = Color8(13, 16, 17)   # same as the video background, so the 60%-wide video has no visible frame
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(bg)
	var stream: VideoStream = null
	if ResourceLoader.exists(video_path):
		stream = load(video_path) as VideoStream
	if stream == null:
		_finish.call_deferred()
		return
	player = VideoStreamPlayer.new()
	player.stream = stream
	player.expand = true
	player.volume_db = -80.0 if muted else 0.0
	player.mouse_filter = Control.MOUSE_FILTER_IGNORE
	player.finished.connect(_finish)
	add_child(player)
	if OS.has_feature("web") and not _web_unlocked:
		_waiting_tap = true
		_make_tap_label()
		return
	_start_playback()


static var _web_unlocked := false


func _make_tap_label() -> void:
	var l := Label.new()
	l.name = "TapLabel"
	l.text = Localization.tr_key("intro.tap") if Localization.has_key("intro.tap") else "Tap to start"
	l.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	l.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	l.add_theme_font_size_override("font_size", 28)
	l.add_theme_color_override("font_color", Color.WHITE)
	l.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(l)


func _start_playback() -> void:
	_waiting_tap = false
	var tap := get_node_or_null("TapLabel")
	if tap != null:
		tap.queue_free()
	_play_started = _elapsed
	player.play()


func _process(delta: float) -> void:
	_elapsed += delta
	_layout_video()
	# Safety net: a video that never advances (no decoder, blocked audio clock) must not trap the player on a black screen.
	if player != null and not _waiting_tap and not _done and _elapsed - _play_started > 4.0 and player.stream_position < 0.05:
		_finish()

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton or event is InputEventScreenTouch:
		if event.pressed:
			if _waiting_tap:
				_web_unlocked = true
				_start_playback()
				return
			skip()

## Skips the video if at least SKIP_AFTER seconds have passed.
func skip() -> void:
	if _elapsed >= SKIP_AFTER:
		_finish()

func _finish() -> void:
	if _done:
		return
	_done = true
	if player != null:
		player.stop()
	finished.emit()


## The video (portrait 720x1280, black background) is shown centred at VIDEO_WIDTH_FRACTION of the screen width.
func _layout_video() -> void:
	if player == null or size.x <= 0.0:
		return
	var w := size.x * VIDEO_WIDTH_FRACTION
	var h := w * VIDEO_ASPECT
	player.set_anchors_preset(Control.PRESET_TOP_LEFT)
	player.position = Vector2((size.x - w) * 0.5, (size.y - h) * 0.5)
	player.size = Vector2(w, h)
