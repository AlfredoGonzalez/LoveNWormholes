extends SceneTree
## Renders the main screens to build/shots/*.png (needs a display: xvfb-run, see docs/DEV.md).
## xvfb-run -a godot --path . --rendering-method gl_compatibility --rendering-driver opengl3 --script res://tools/screenshots.gd

func _initialize() -> void:
	await process_frame
	var Game = root.get_node("Game")
	DirAccess.make_dir_recursive_absolute("res://build/shots")
	root.size = Vector2i(540, 960)
	Game.boot("user://shots_save.json")
	Game.save.delete_all()
	Game.boot("user://shots_save.json")
	var host := Control.new()
	host.set_anchors_preset(Control.PRESET_FULL_RECT)
	root.add_child(host)
	Game.nav.host = host
	Game.start_services()
	var shots := [
		["title", {}, 3],
		["home", {}, 3],
		["levels", {}, 3],
		["squad", {}, 3],
		["prebattle", {"era": 1, "stage": 1}, 3],
		["battle", {"era": 1, "stage": 1, "squad": ["p1_club_worm", "p1_slinger_worm", "p1_dino_rider_worm"], "powers": ["squirm_slam", "apple_rain"]}, 3],
		["upgrades", {}, 3],
		["settings", {"from": "levels"}, 3],
		["result", {"result": "win", "era": 1, "stage": 1, "time": 95.0, "base_hp_fraction": 0.7, "squad": ["p1_club_worm"], "powers": []}, 3],
		["result", {"result": "lose", "era": 1, "stage": 2, "time": 60.0, "base_hp_fraction": 0.0, "squad": ["p1_club_worm"], "powers": []}, 3],
		["shop", {"from": "home"}, 4, "progress"],
		["capsules", {"from": "home"}, 4],
		["relics", {}, 4, "relics"],
		["consent", {}, 3],
		["story", {"seq": "intro", "next": "home"}, 3],
		["story", {"seq": "era_5_open", "next": "home"}, 3],
		["credits", {"from": "home"}, 3],
		["battle", {"era": 1, "stage": 1, "squad": ["p1_club_worm", "p1_slinger_worm"], "powers": ["squirm_slam", "apple_rain"]}, 3, "tutorial_food"],
		["battle", {"era": 1, "stage": 1, "squad": ["p1_club_worm", "p1_slinger_worm"], "powers": ["squirm_slam", "apple_rain"]}, 3, "tutorial_spawn"],
	]
	var n := 0
	for sh in shots:
		if sh.size() > 3:
			if sh[3] == "progress":   # shop / capsules need unlocked features and some currency
				for st in range(1, 11):
					Game.economy.settle_battle(1, st, true, 2, 1)
				Game.economy.add("gems", 300)
				Game.economy.add("capsules", 12)
			elif str(sh[3]).begins_with("tutorial"):   # arm the first-battle tutorial (the intro does it in the game)
				Game.save.profile["progress"]["highest_stage_cleared"] = {}   # earlier shots cleared the campaign
				Story.mark_seen(Game.save.profile, "intro")
			elif sh[3] == "relics":
				Capsules.new(Game.economy).open_many(12)
				Game.economy.add("chrono_dust", 80)
		Game.nav.go(sh[0], sh[1])
		if sh[0] == "battle" and sh.size() > 3 and str(sh[3]).begins_with("tutorial"):
			var tb = Game.nav.current
			tb.step(0.0)
			tb.tutorial.overlay.advance.emit()   # welcome -> food
			tb.step(0.0)
			if sh[3] == "tutorial_spawn":
				tb.tutorial.overlay.advance.emit()
				tb.step(0.0)
		elif sh[0] == "battle":
			var b = Game.nav.current
			for i in 3:
				b.press_card(i)
				for k in 40:
					b.step(1.0 / 30.0)
		for _i in int(sh[2]):
			await process_frame
		var img := root.get_texture().get_image()
		var path := "res://build/shots/%02d_%s.png" % [n, sh[0]]
		img.save_png(path)
		print("saved ", path, " ", img.get_size())
		n += 1
	quit(0)
