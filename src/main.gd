extends Control
## Entry point: studio video -> title screen (progress bar that becomes Play; consent is asked on Play). Built in code.

func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	if not Game.booted_ok:
		Game.boot()
	Game.nav.host = self
	Game.start_services()
	AssetPreloader.start()   # loads the art in the background while the studio video plays
	# On the web the video is played by the page itself (web/shell.html) before the engine is ready, so skip it here.
	var web_handled := OS.has_feature("web")
	if web_handled or bool(OS.get_environment("LNW_SKIP_INTRO") != "") or not ResourceLoader.exists("res://assets/video/studio_intro.ogv"):
		_after_intro()
		return
	var intro := StudioIntro.new()
	intro.muted = bool(Game.save.profile["settings"].get("muted", false))
	add_child(intro)
	intro.finished.connect(func():
		intro.queue_free()
		_after_intro())


func _after_intro() -> void:
	_to_title()


func _to_title() -> void:
	if not Game.nav.go("title"):
		# Phase 1 screens arrive in parallel; until "title" exists show the app name.
		var label := Label.new()
		label.text = Game.t("title.name") if Localization.has_key("title.name") else "Love 'n Wormholes"
		label.set_anchors_preset(Control.PRESET_CENTER)
		add_child(label)
