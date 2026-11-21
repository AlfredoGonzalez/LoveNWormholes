extends TestCase

func test_only_spec_events_pass() -> void:
	var mock := MockAnalyticsProvider.new()
	var a := AnalyticsService.new(mock)
	for e in AnalyticsService.EVENTS:
		assert_true(a.log_event(e))
	assert_eq(AnalyticsService.EVENTS.size(), 17)
	assert_true(not a.log_event("made_up"))
	assert_eq(a.rejected, ["made_up"])
	assert_eq(mock.events.size(), 17)
	a.enabled = false
	a.log_event("session_start")
	assert_eq(mock.count("session_start"), 1, "disabled: nothing forwarded")
	a.enabled = true
	a.capsule_open("rare", 3)
	assert_eq(mock.events.back()["params"], {"rarity": "rare", "pity": 3})

func test_default_provider_is_noop() -> void:
	var a := AnalyticsService.new()
	assert_true(a.log_event("stage_start", {"stage": "1-1"}))
