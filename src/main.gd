extends Control
## Entry point (spec 9.1 boot order): studio intro -> consent (mock) -> title. Built in code.

func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	if not Game.booted_ok:
		Game.boot()
	Game.nav.host = self
	Game.start_services()
	if bool(OS.get_environment("LNW_SKIP_INTRO") != "") or not ResourceLoader.exists("res://assets/video/studio_intro.ogv"):
		_to_title()
		return
	var intro := StudioIntro.new()
	intro.muted = bool(Game.save.profile["settings"].get("muted", false))
	add_child(intro)
	intro.finished.connect(func():
		intro.queue_free()
		_to_title())


func _to_title() -> void:
	if not Game.nav.go("title"):
		# Phase 1 screens arrive in parallel; until "title" exists show the app name.
		var label := Label.new()
		label.text = Game.t("title.name") if Localization.has_key("title.name") else "Love 'n Wormholes"
		label.set_anchors_preset(Control.PRESET_CENTER)
		add_child(label)
