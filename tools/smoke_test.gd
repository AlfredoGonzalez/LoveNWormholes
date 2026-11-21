extends SceneTree
## Boots the main scene for a few frames. Exits non-zero if it cannot load.
## tools/check.sh also fails if the engine logged any ERROR / SCRIPT ERROR.

var _frames := 0

func _initialize() -> void:
	var packed: PackedScene = load("res://src/main.tscn")
	if packed == null:
		push_error("smoke: main scene failed to load")
		quit(1)
		return
	root.add_child(packed.instantiate())

func _process(_delta: float) -> bool:
	_frames += 1
	if _frames >= 5:
		print("smoke ok (%d frames)" % _frames)
		quit(0)
	return false
