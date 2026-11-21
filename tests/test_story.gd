extends TestCase
## Story sequences (data/story.json), their flags and routing, StoryScreen, CreditsScreen and the Settings entries.
## Screen tests need the Game autoload (skipped before the runner reaches _initialize).

const SAVE := "user://test_story_save.json"


class RecNav extends Navigator:
	var calls: Array = []
	func can_go(_n: String) -> bool:
		return true
	func go(screen_name: String, p: Dictionary = {}) -> bool:
		calls.append([screen_name, p])
		return true


func _g():
	var ml := Engine.get_main_loop()
	if ml == null or not (ml is SceneTree) or (ml as SceneTree).root == null:
		return null
	return (ml as SceneTree).root.get_node_or_null("Game")


func _fresh():
	for f in [SAVE, SAVE.get_basename() + ".bak.json", SAVE + ".tmp"]:
		DirAccess.remove_absolute(ProjectSettings.globalize_path(f))
	_g().boot(SAVE)
	Localization.set_language("en")
	var n = RecNav.new()
	_g().nav = n
	return n


func _make(script_path: String, params := {}):
	var s = (load(script_path) as GDScript).new()
	s.setup(params)
	Engine.get_main_loop().root.add_child(s)
	return s


func _drop(s) -> void:
	if s.get_parent() != null:
		s.get_parent().remove_child(s)
	s.free()


func _profile() -> Dictionary:
	return _g().save.profile


# ------------------------------------------------------------------ data

func test_data_complete_and_translated() -> void:
	Story.reload()
	var ids := Story.order()
	assert_eq(ids.size(), 12, "intro + 5 x (open, close) + ending")
	assert_true(ids.has("intro") and ids.has("ending"))
	for era in range(1, 6):
		assert_true(ids.has(Story.era_open_id(era)), "era %d opening" % era)
		assert_true(ids.has(Story.era_close_id(era)), "era %d closing" % era)
	for id in ids:
		var panels := Story.panels(str(id))
		assert_true(not panels.is_empty(), "%s has panels" % id)
		# spec 3: short and skippable; era comics are one or two panels, the intro three.
		assert_true(panels.size() <= 4, "%s is short" % id)
		for p in panels:
			var key := str(p["text_key"])
			assert_true(Localization.has_key(key), "key %s" % key)
			assert_true(str(p.get("caption", "")) != "", "placeholder caption")
			for lang in ["en", "es"]:
				Localization.set_language(lang)
				var t := Localization.tr_key(key)
				assert_true(t != key and t.length() > 10 and t.length() < 220, "%s/%s readable and short" % [key, lang])
	Localization.set_language("en")
	assert_eq(Story.panels("intro").size(), 3, "prologue is 3 panels (spec 9.2)")
	assert_eq(Story.panels("nope").size(), 0)


# ------------------------------------------------------------------ flags and routing

func test_flags_routing_and_gates() -> void:
	var prof := {"seen": {}, "progress": {"highest_stage_cleared": {}}}
	assert_true(not Story.enabled(prof), "no intro yet: era comics off")
	var r := Story.route(prof, "intro", "home", {})
	assert_eq(r[0], "story")
	assert_eq(r[1]["seq"], "intro")
	assert_eq(r[1]["next"], "home")
	assert_eq(Story.before_battle(prof, 1, 1, {"era": 1})[0], "battle", "not enabled: straight to the battle")
	Story.mark_seen(prof, "intro")
	assert_true(Story.enabled(prof))
	assert_eq(Story.route(prof, "intro", "home")[0], "home", "seen: skip the story")
	assert_true(Tutorial.is_armed(prof), "the intro arms the tutorial")
	var bp := {"era": 1, "stage": 1}
	var b := Story.before_battle(prof, 1, 1, bp)
	assert_eq(b[0], "story")
	assert_eq(b[1]["seq"], "era_1_open")
	assert_eq(b[1]["next"], "battle")
	assert_eq(b[1]["next_params"], bp)
	assert_eq(Story.before_battle(prof, 1, 2, bp)[0], "battle", "only stage 1 opens an era")
	assert_eq(Story.before_battle(prof, 1, 1, {"resume": true})[0], "battle", "a resumed battle never replays it")
	Story.mark_seen(prof, "era_1_open")
	assert_eq(Story.before_battle(prof, 1, 1, bp)[0], "battle", "once")
	# Boss closing: only on a win of stage 10.
	var res := {"result": "win"}
	assert_eq(Story.after_battle(prof, "lose", 1, 10, res)[0], "result")
	assert_eq(Story.after_battle(prof, "win", 1, 9, res)[0], "result")
	var a := Story.after_battle(prof, "win", 1, 10, res)
	assert_eq(a[0], "story")
	assert_eq(a[1]["seq"], "era_1_close")
	assert_eq(a[1]["next"], "result")
	assert_eq(a[1]["next_params"], res)
	Story.mark_seen(prof, "era_1_close")
	assert_eq(Story.after_battle(prof, "win", 1, 10, res)[0], "result")


func test_ending_flag_tolerant() -> void:
	var prof := {"seen": {"story": {"intro": true}}}
	assert_true(not Story.game_completed(prof), "no progress dict at all")
	assert_true(not Story.ending_pending(prof))
	prof["progress"] = {"highest_stage_cleared": {}}
	assert_true(not Story.game_completed(prof), "flag missing")
	prof["progress"]["game_completed"] = true
	assert_true(Story.game_completed(prof))
	assert_true(Story.ending_pending(prof))
	Story.mark_seen(prof, "ending")
	assert_true(not Story.ending_pending(prof))
	assert_true(not Story.game_completed({"progress": 3}), "garbage does not crash")


func test_replay_is_spoiler_free() -> void:
	var prof := {"seen": {"story": {"intro": true}}, "progress": {"highest_stage_cleared": {"1": 3}}}
	var ids := Story.replay_ids(prof)
	assert_eq(ids, ["intro", "era_1_open"], "intro + the era the player is in")
	prof["progress"]["highest_stage_cleared"] = {"1": 10, "2": 4}
	ids = Story.replay_ids(prof)
	assert_eq(ids, ["intro", "era_1_open", "era_1_close", "era_2_open"])
	assert_true(not ids.has("ending"))
	prof["progress"]["game_completed"] = true
	assert_true(Story.replay_ids(prof).has("ending"))


# ------------------------------------------------------------------ screens

func test_story_screen_flow() -> void:
	if _g() == null:
		return
	var nav = _fresh()
	var s = _make("res://src/meta/story_screen.gd", {"seq": "intro", "next": "home", "next_params": {"x": 1}})
	assert_eq(s.panels.size(), 3)
	assert_true(Story.is_seen(_profile(), "intro"), "flagged when shown")
	assert_true(Tutorial.is_armed(_profile()), "and the tutorial armed")
	assert_true(s.skip_button.visible and s.skip_button.size.y >= 0.0 and s.skip_button.custom_minimum_size.y >= 48.0, "skip always there")
	assert_eq(s.text_label.text, Localization.tr_key("story.intro.1"))
	assert_eq(s.next_button.text, _t("story.next"))
	s.next_panel()
	s.next_panel()
	assert_true(s.is_last())
	assert_eq(s.next_button.text, _t("story.continue"))
	assert_true(nav.calls.is_empty(), "still on the story")
	s.next_panel()
	assert_eq(nav.calls.size(), 1)
	assert_eq(nav.calls[0][0], "home")
	assert_eq(nav.calls[0][1], {"x": 1})
	s.skip()
	assert_eq(nav.calls.size(), 1, "leaves only once")
	_drop(s)
	# Skip from the first panel goes on too.
	nav = _fresh()
	s = _make("res://src/meta/story_screen.gd", {"seq": "era_2_open", "next": "battle", "next_params": {"era": 2}})
	s.skip()
	assert_eq(nav.calls[0][0], "battle")
	assert_true(Story.is_seen(_profile(), "era_2_open"))
	_drop(s)


func _t(key: String) -> String:
	return Localization.tr_key(key)


func test_story_screen_replay_and_unknown() -> void:
	if _g() == null:
		return
	var nav = _fresh()
	Story.mark_seen(_profile(), "intro")
	var before := (_profile()["seen"]["story"] as Dictionary).duplicate()
	var s = _make("res://src/meta/story_screen.gd", {"seq": Story.REPLAY, "next": "settings", "next_params": {"from": "home"}})
	assert_eq(s.panels.size(), Story.panels("intro").size() + Story.panels("era_1_open").size())
	assert_eq(_profile()["seen"]["story"], before, "a replay flags nothing")
	s.skip()
	assert_eq(nav.calls[0], ["settings", {"from": "home"}])
	_drop(s)
	nav = _fresh()
	s = _make("res://src/meta/story_screen.gd", {"seq": "does_not_exist", "next": "home"})
	s.finish()
	assert_eq(nav.calls[0][0], "home", "an empty sequence never traps the player")
	_drop(s)


func test_panel_without_art_is_a_placeholder() -> void:
	if _g() == null:
		return
	_fresh()
	var s = _make("res://src/meta/story_screen.gd", {"seq": "intro", "next": "home"})
	assert_eq(s.art_holder.get_child_count(), 1)
	assert_true(s.art_holder.get_child(0) is ColorRect, "colour placeholder until assets/ has the panel art")
	_drop(s)


func test_title_routes_to_intro_once() -> void:
	if _g() == null:
		return
	var nav = _fresh()
	_profile()["consent"]["state"] = "accepted"
	var t = _make("res://src/meta/title_screen.gd")
	t._on_play()
	assert_eq(nav.calls[0][0], "story")
	assert_eq(nav.calls[0][1]["seq"], "intro")
	assert_eq(nav.calls[0][1]["next"], "home")
	Story.mark_seen(_profile(), "intro")
	t._on_play()
	assert_eq(nav.calls[1][0], "home")
	_drop(t)


func test_credits_and_settings_entries() -> void:
	if _g() == null:
		return
	var nav = _fresh()
	var s = _make("res://src/meta/settings_screen.gd", {"from": "home"})
	s.ensure_built()
	s.open_credits()
	assert_eq(nav.calls[0], ["credits", {"from": "home"}])
	s.open_story()
	assert_eq(nav.calls[1][0], "story")
	assert_eq(nav.calls[1][1]["seq"], Story.REPLAY)
	assert_eq(nav.calls[1][1]["next"], "settings")
	_drop(s)
	var c = _make("res://src/meta/credits_screen.gd", {"from": "home"})
	assert_true(c.back_button != null)
	assert_true(c.back_button.custom_minimum_size.y >= 48.0)
	c.back()
	assert_eq(nav.calls[2], ["settings", {"from": "home"}])
	_drop(c)
	for lang in ["en", "es"]:
		Localization.set_language(lang)
		assert_true(Localization.tr_key("credits.title") != "credits.title")
	Localization.set_language("en")


func test_navigator_registers_screens() -> void:
	var n := Navigator.new()
	assert_true(n.can_go("story"))
	assert_true(n.can_go("credits"))
