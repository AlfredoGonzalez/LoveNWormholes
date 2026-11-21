extends Node
## Entry point. All screens are built from code (spec 8.11); this scene only boots the game.

func _ready() -> void:
	var label := Label.new()
	label.text = "Love 'n Wormholes"
	add_child(label)
