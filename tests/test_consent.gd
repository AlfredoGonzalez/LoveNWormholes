extends TestCase
## ConsentService + ConsentScreen + the "no ads before consent" rule.

const P := "user://t_consent.json"

func _clean() -> void:
	for p in [P, "user://t_consent.bak.json", P + ".tmp"]:
		if FileAccess.file_exists(p):
			DirAccess.remove_absolute(p)

class Rig:
	var provider := MockConsentProvider.new()
	var save: SaveService
	var analytics := MockAnalyticsProvider.new()
	var consent: ConsentService
	var resolved: Array = []

func _rig(fresh := true, flow := true) -> Rig:
	if fresh:
		_clean()
	var r := Rig.new()
	r.save = SaveService.new(P)
	r.save.load_profile()
	r.consent = ConsentService.new(r.provider, r.save, AnalyticsService.new(r.analytics), flow)
	var res := r.resolved
	r.consent.resolved.connect(func(s): res.append(s))
	return r

func test_unknown_until_chosen_then_persisted() -> void:
	var r := _rig()
	r.consent.start()
	assert_eq(r.provider.info_calls, 1)
	assert_eq(r.consent.state(), "unknown")
	assert_true(r.consent.needs_prompt() and not r.consent.is_resolved())
	assert_eq(r.resolved.size(), 0, "nothing resolved yet")
	r.consent.set_choice(true)
	assert_eq(r.consent.state(), "accepted")
	assert_true(r.consent.personalized() and r.consent.is_resolved() and not r.consent.needs_prompt())
	assert_eq(r.resolved, ["accepted"])
	assert_eq(r.provider.last_personalized, true)
	assert_eq(r.analytics.count("consent_set"), 1)
	var again := _rig(false)
	assert_eq(again.consent.state(), "accepted", "stored in profile.consent")
	assert_eq(again.save.profile["consent"]["version"], ConsentService.POLICY_VERSION)
	again.consent.start()
	assert_eq(again.resolved, ["accepted"], "a returning player resolves at start")
	_clean()

func test_decline_is_resolved_but_not_personalized() -> void:
	var r := _rig()
	r.consent.set_choice(false)
	assert_eq(r.consent.state(), "declined")
	assert_true(r.consent.is_resolved() and not r.consent.personalized())
	assert_eq(r.provider.last_personalized, false)
	_clean()

func test_reopen_changes_choice_and_resolved_fires_once() -> void:
	var r := _rig()
	var changes := []
	r.consent.changed.connect(func(s): changes.append(s))
	r.consent.set_choice(false)
	r.consent.set_choice(true)   # Settings > Privacy options
	assert_eq(changes, ["declined", "accepted"])
	assert_eq(r.resolved.size(), 1, "resolved only the first time")
	r.consent.set_state("unknown")
	assert_eq(r.consent.state(), "unknown")
	assert_eq(r.provider.reset_calls, 1)
	_clean()

func test_platform_form_comes_first_when_required() -> void:
	var r := _rig()
	r.provider.form_required = true
	r.provider.manual_form = true
	r.consent.start()
	r.consent.set_choice(true)
	assert_eq(r.provider.form_calls, 1)
	assert_eq(r.consent.state(), "unknown", "stored only after the form closes")
	r.provider.dismiss_form()
	assert_eq(r.consent.state(), "accepted")
	_clean()

func test_old_state_names_are_mapped_and_old_version_asks_again() -> void:
	var r := _rig()
	r.save.profile["consent"]["state"] = "granted"
	assert_eq(r.consent.state(), "accepted")
	r.save.profile["consent"]["state"] = "limited"
	assert_eq(r.consent.state(), "declined")
	r.save.profile["consent"] = {"state": "accepted", "version": 0}
	assert_eq(r.consent.state(), "unknown", "policy version bumped: ask again")
	_clean()

func test_flow_flag_off_counts_as_resolved() -> void:
	var r := _rig(true, false)
	assert_true(r.consent.is_resolved() and not r.consent.needs_prompt())
	r.consent.start()
	assert_eq(r.resolved.size(), 1)
	_clean()

# ---------------------------------------------------------------- Game wiring + screen

func _g():
	var ml := Engine.get_main_loop()
	if ml == null or not (ml is SceneTree) or (ml as SceneTree).root == null:
		return null
	return (ml as SceneTree).root.get_node_or_null("Game")

class RecNav extends Navigator:
	var calls: Array = []
	func can_go(_n: String) -> bool:
		return true
	func go(screen_name: String, p: Dictionary = {}) -> bool:
		calls.append([screen_name, p])
		return true

func test_game_starts_ads_only_after_consent() -> void:
	var g = _g()
	if g == null:
		return
	_clean()
	g.boot(P)
	var nav := RecNav.new()
	g.nav = nav
	g.save.profile["progress"]["highest_stage_cleared"]["1"] = 5
	g.start_services()
	assert_true(not g._mock_ads.initialized, "ad SDK not initialized before consent")
	assert_true(not g.ads.is_available("double_coins"))
	assert_eq(g._mock_ads.preload_calls.size(), 0, "no ad request before consent")
	g.consent.set_choice(false)
	assert_true(g._mock_ads.initialized and g._mock_ads.consent_known)
	assert_eq(g._mock_ads.personalized, false, "declined: non-personalized")
	assert_true(g.ads.is_available("double_coins"), "ads load after the choice")
	g.consent.set_choice(true)
	assert_eq(g._mock_ads.personalized, true, "re-opened choice reaches the provider")
	# a returning player: ads start at boot
	g.boot(P)
	g.nav = RecNav.new()
	g.start_services()
	assert_true(g._mock_ads.initialized and g._mock_ads.personalized == true)
	g.boot(P)
	_clean()

func test_consent_screen_flows() -> void:
	var g = _g()
	if g == null:
		return
	_clean()
	g.boot(P)
	var nav := RecNav.new()
	g.nav = nav
	var s := ConsentScreen.new()
	s.setup({"next": "title"})
	Engine.get_main_loop().root.add_child(s)
	assert_true(s.accept_button != null and s.decline_button != null)
	assert_true(s.back_button == null, "first launch: no back button")
	s.accept_button.pressed.emit()
	assert_eq(g.save.profile["consent"]["state"], "accepted")
	assert_eq(nav.calls[-1][0], "title")
	Engine.get_main_loop().root.remove_child(s)
	s.free()
	# re-open from Settings
	var s2 := ConsentScreen.new()
	s2.setup({"from": "settings", "next": "settings", "next_params": {"from": "home"}})
	Engine.get_main_loop().root.add_child(s2)
	assert_true(s2.back_button != null)
	s2.decline_button.pressed.emit()
	assert_eq(g.save.profile["consent"]["state"], "declined")
	assert_eq(nav.calls[-1], ["settings", {"from": "home"}])
	Engine.get_main_loop().root.remove_child(s2)
	s2.free()
	_clean()

func test_settings_privacy_review_opens_consent_screen() -> void:
	var g = _g()
	if g == null:
		return
	_clean()
	g.boot(P)
	var nav := RecNav.new()
	g.nav = nav
	var s := SettingsScreen.new()
	s.setup({"from": "home"})
	Engine.get_main_loop().root.add_child(s)
	s.open_consent_screen()
	assert_eq(nav.calls[-1][0], "consent")
	assert_eq(nav.calls[-1][1]["from"], "settings")
	s.set_consent("declined")
	assert_eq(g.consent.state(), "declined")
	Engine.get_main_loop().root.remove_child(s)
	s.free()
	_clean()
