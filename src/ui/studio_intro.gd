class_name StudioIntro
extends Control
## Studio logo video, full screen. Emits `finished` when done, skipped (tap after 1 s) or when
## the video is missing. Silent when `muted` is true. Set `muted` before adding to the tree.

signal finished

const VIDEO_PATH := "res://assets/video/studio_intro.ogv"
const SKIP_AFTER := 1.0

var muted := false
var video_path := VIDEO_PATH
var player: VideoStreamPlayer = null
var _elapsed := 0.0
var _done := false

func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_STOP
	var bg := ColorRect.new()
	bg.color = Color.BLACK
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
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
	player.set_anchors_preset(Control.PRESET_FULL_RECT)
	player.mouse_filter = Control.MOUSE_FILTER_IGNORE
	player.finished.connect(_finish)
	add_child(player)
	player.play()

func _process(delta: float) -> void:
	_elapsed += delta

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton or event is InputEventScreenTouch:
		if event.pressed:
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
