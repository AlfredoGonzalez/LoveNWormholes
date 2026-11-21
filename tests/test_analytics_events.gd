extends TestCase
## Analytics: no PII, helpers use spec events, and Game instruments what no screen owns.

func _rm(path: String) -> void:
	for f in [path, path.get_basename() + ".bak.json", path + ".tmp"]:
		DirAccess.remove_absolute(ProjectSettings.globalize_path(f))

func test_pii_keys_dropped() -> void:
	var mock := MockAnalyticsProvider.new()
	var a := AnalyticsService.new(mock)
	a.log_event("stage_start", {"stage": "1-1", "email": "x@y.z", "User_ID": "42", "advertising_id": "abc"})
	assert_eq(mock.events[0]["params"], {"stage": "1-1"})
	assert_eq(a.dropped_keys.size(), 3)

func test_helpers_use_spec_events() -> void:
	var mock := MockAnalyticsProvider.new()
	var a := AnalyticsService.new(mock)
	a.session_start(true, "es")
	a.tutorial_step("spawn_unit", 1)
	a.iap_view("gems_80")
	a.era_unlocked(2)
	a.unit_upgrade("unit", "club_worm", 3)
	assert_eq(mock.names(), ["session_start", "tutorial_step", "iap_view", "era_unlocked", "unit_upgrade"])
	assert_true(a.rejected.is_empty())

func test_game_instruments_session_upgrades_and_era_unlock() -> void:
	var ml := Engine.get_main_loop()
	var g = (ml as SceneTree).root.get_node_or_null("Game") if ml is SceneTree else null
	if g == null:
		return
	var path := "user://t_analytics_game.json"
	_rm(path)
	g.boot(path)
	g.start_services()
	var ev: MockAnalyticsProvider = g.analytics.provider
	assert_eq(ev.count("session_start"), 1)
	assert_eq(ev.events[0]["params"]["first_session"], true)
	g.economy.add("coins", 100000)
	g.economy.upgrade_burrow()
	assert_eq(ev.count("unit_upgrade"), 1, "upgrades are logged")
	for s in range(1, 11):
		g.economy.settle_battle(1, s, true, 2, 1)
	assert_eq(ev.count("era_unlocked"), 1, "era 2 unlocked after the Era 1 boss")
	assert_true((g.analytics.rejected as Array).is_empty())
	g.boot(path)
	_rm(path)

func test_purchase_logs_only_iap_purchase_view_is_the_shops() -> void:
	var mock := MockAnalyticsProvider.new()
	var path := "user://t_iap_view.json"
	var save := SaveService.new(path)
	save.load_profile()
	var b := BillingService.new(MockBillingProvider.new(), save, {"gems_80": {"type": "consumable", "grants": {"gems": 80}}},
			AnalyticsService.new(mock))
	b.purchase("gems_80")
	assert_eq(mock.names(), ["iap_purchase"], "iap_view belongs to opening the Shop, not to buying")
	b.shutdown()
	_rm(path)
