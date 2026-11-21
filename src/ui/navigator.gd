class_name Navigator
extends RefCounted
## Screen registry and switcher. Screens are classes extending Screen, registered by name in SCREENS.
## `host` is the Control that holds the current screen (set by Main). Overlays (pause, popups) are
## pushed on top with push() and removed with pop().

signal changed(screen_name: String)

const SCREENS := {
	"title": "res://src/meta/title_screen.gd",
	"home": "res://src/meta/home_screen.gd",
	"levels": "res://src/meta/level_select_screen.gd",   # the World Map (kept under its original route name)
	"squad": "res://src/meta/squad_screen.gd",
	"prebattle": "res://src/meta/pre_battle_screen.gd",
	"battle": "res://src/battle/battle_screen.gd",
	"result": "res://src/meta/result_screen.gd",
	"upgrades": "res://src/meta/upgrades_screen.gd",
	"settings": "res://src/meta/settings_screen.gd",
}

var host: Control
var current_name := ""
var current: Screen
var _overlays: Array = []


func can_go(screen_name: String) -> bool:
	return SCREENS.has(screen_name) and ResourceLoader.exists(str(SCREENS[screen_name]))


## Replace the current screen. Unknown or not-yet-implemented screens are reported, never crash.
func go(screen_name: String, params: Dictionary = {}) -> bool:
	if host == null or not can_go(screen_name):
		push_warning("Navigator: screen '%s' is not available" % screen_name)
		return false
	clear_overlays()
	if current != null:
		current.queue_free()
		current = null
	var script: GDScript = load(str(SCREENS[screen_name]))
	var s: Screen = script.new()
	s.setup(params)
	host.add_child(s)
	current = s
	current_name = screen_name
	changed.emit(screen_name)
	return true


func push(overlay: Control) -> void:
	host.add_child(overlay)
	_overlays.append(overlay)


func pop() -> void:
	if _overlays.is_empty():
		return
	var o: Control = _overlays.pop_back()
	if is_instance_valid(o):
		o.queue_free()


func clear_overlays() -> void:
	while not _overlays.is_empty():
		pop()
