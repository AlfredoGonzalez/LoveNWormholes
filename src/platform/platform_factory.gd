class_name PlatformFactory
extends RefCounted
## Chooses the service implementations (spec 8.3). Mock by default (desktop, editor, tests, CI).
## Native adapters (src/platform/android) are used when ALL hold:
##   - the build runs on Android (OS.has_feature("android")),
##   - the feature flag `native_services` is on (config/feature_flags.json),
##   - the environment variable LNW_MOCK_SERVICES is not set (force mocks on a device for debugging).
## On Android with a plugin missing, the native adapter is still returned and simply stays unavailable
## (no ads, purchases fail): a build without plugins must never hand out free rewards through a mock.

static func use_native() -> bool:
	if OS.get_environment("LNW_MOCK_SERVICES") != "":
		return false
	return OS.has_feature("android") and DataDB.feature_enabled("native_services")


static func ad_provider() -> AdProvider:
	return AdMobAdProvider.new() if use_native() else MockAdProvider.new()


static func billing_provider(host: Node, product_ids: Array, consumable_ids: Array) -> BillingProvider:
	if not use_native():
		return MockBillingProvider.new()
	var p := PlayBillingProvider.new()
	p.host = host
	p.configure(product_ids, consumable_ids)
	return p


static func analytics_provider() -> AnalyticsProvider:
	return FirebaseAnalyticsProvider.new() if use_native() else MockAnalyticsProvider.new()


static func consent_provider() -> ConsentProvider:
	return UmpConsentProvider.new() if use_native() else MockConsentProvider.new()
