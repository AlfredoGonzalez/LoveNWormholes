class_name Screen
extends Control
## Base class of every full-screen UI (title, levels, battle, ...). Built entirely in code.
## The Navigator creates it, calls setup(params) BEFORE adding it to the tree, then _ready() runs.
## To leave a screen call Game.nav.go("<name>", params).

var params: Dictionary = {}

func setup(p_params: Dictionary) -> void:
	params = p_params


func _init() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_STOP
