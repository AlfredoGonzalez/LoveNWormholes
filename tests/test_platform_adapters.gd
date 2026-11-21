extends TestCase
## The Android adapters compile and degrade safely in headless (no plugins installed), and the factory picks
## mocks on desktop.

func test_factory_uses_mocks_off_android() -> void:
	assert_true(not PlatformFactory.use_native())
	assert_true(PlatformFactory.ad_provider() is MockAdProvider)
	assert_true(PlatformFactory.consent_provider() is MockConsentProvider)
	assert_true(PlatformFactory.analytics_provider() is MockAnalyticsProvider)
	assert_true(PlatformFactory.billing_provider(null, [], []) is MockBillingProvider)

func test_admob_without_addon_never_ready_never_rewards() -> void:
	var p := AdMobAdProvider.new()
	assert_true(not p.is_supported())
	var events := []
	p.rewarded.connect(func(_x): events.append("rewarded"))
	p.initialize(true)
	p.preload_ad("double_coins")
	assert_true(not p.is_ready("double_coins"))
	p.show("double_coins")   # reports failure, never rewards
	assert_eq(events, [])
	assert_true(p.unit_id_for("double_coins").begins_with("ca-app-pub-3940256099942544/"))

func test_billing_without_addon_fails_every_purchase() -> void:
	var p := PlayBillingProvider.new()
	var fails := []
	p.failed.connect(func(id, reason): fails.append([id, reason]))
	var grants := []
	p.purchased.connect(func(id, _t): grants.append(id))
	p.initialize()
	p.purchase("gems_80")
	assert_eq(fails, [["gems_80", "billing_unavailable"]])
	assert_eq(grants.size(), 0)
	var owned := [1]
	p.restored.connect(func(o): owned.assign(o))
	p.restore()
	assert_eq(owned, [])

func test_ump_without_addon_is_not_required() -> void:
	var p := UmpConsentProvider.new()
	var st := []
	p.info_updated.connect(func(s): st.append(s))
	p.request_info_update()
	assert_eq(st, ["not_required"])
	assert_true(not p.is_form_required())

func test_firebase_flattens_params_and_has_no_pii_path() -> void:
	var flat := FirebaseAnalyticsProvider.flatten({"squad": ["a", "b"], "won": true, "n": 3, "s": "x".repeat(300)})
	assert_eq(flat["squad"], "a,b")
	assert_eq(flat["won"], 1)
	assert_eq(flat["n"], 3)
	assert_eq(str(flat["s"]).length(), FirebaseAnalyticsProvider.MAX_VALUE)
	var p := FirebaseAnalyticsProvider.new()
	assert_true(not p.is_supported())
	p.set_collection_enabled(false)
	p.log_event("stage_start", {})   # no plugin: no crash
