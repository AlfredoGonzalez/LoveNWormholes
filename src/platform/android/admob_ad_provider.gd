class_name AdMobAdProvider
extends AdProvider
## Rewarded ads through AdMob on Android (spec 7.1). Written against the poing-studios "Godot AdMob" v4 addon
## (GDScript classes MobileAds, RewardedAdLoader, RewardedAd, AdRequest, RequestConfiguration, ... on top of the
## Android plugin singleton "PoingGodotAdMob"). It does NOT reference those classes statically (AddonBridge looks
## them up by name), so the project compiles and runs headless without the addon.
##
## STATUS: the addon API calls below follow its README but could not be run in the build sandbox (no Android
## SDK, no network to the plugin). Verify on a device with test ads (docs/ANDROID.md, "Verify AdMob").
## Missing addon = ads simply never become ready (the game stays fully playable); it never falls back to mock.
##
## Ids: debug builds and any build without config/ads.prod.json use ONLY Google's official test ids from
## config/ads.json (debug_test_ids). Real ids come from the untracked config/ads.prod.json.
## Contract (AdProvider): `rewarded` is emitted exactly once per ad, from the SDK's user-earned-reward callback;
## `closed` after the ad is dismissed; `failed` on load/show errors.

var _ads := {}              # placement -> loaded RewardedAd object
var _loading := {}          # placement -> true while a load is in flight
var _showing_ad = null
var _showing_placement := ""
var _earned := false
var _initialized := false
var _personalized := true


func is_supported() -> bool:
	return AddonBridge.has_addon_class("MobileAds") and AddonBridge.has_addon_class("RewardedAdLoader")


func set_personalized(p: bool) -> void:
	_personalized = p


## Ad unit for a placement: official test id unless a production file provides one (release builds only).
func unit_id_for(placement: String) -> String:
	var cfg := DataDB.ads_config()
	var test: Dictionary = cfg.get("debug_test_ids", {})
	if not OS.is_debug_build():
		var prod := _read_json(str(cfg.get("prod_ids_file", "res://config/ads.prod.json")))
		var per: Dictionary = prod.get("placements_android", {})
		if per.has(placement):
			return str(per[placement])
		if prod.has("rewarded_android"):
			return str(prod["rewarded_android"])
	return str(test.get("rewarded_android", ""))


func _read_json(path: String) -> Dictionary:
	var f := FileAccess.open(path, FileAccess.READ)
	if f == null:
		return {}
	var d = JSON.parse_string(f.get_as_text())
	return d if typeof(d) == TYPE_DICTIONARY else {}


func initialize(_consent_known: bool) -> void:
	if _initialized:
		return
	if not is_supported():
		push_warning("AdMobAdProvider: Godot AdMob addon not installed; rewarded ads stay unavailable")
		return
	_initialized = true
	var rc = AddonBridge.make("RequestConfiguration")
	if rc != null:
		# Audience 13+, not child-directed (spec 8.7, ConsentProvider constants).
		AddonBridge.set_if_has(rc, "max_ad_content_rating", ConsentProvider.MAX_AD_CONTENT_RATING)
		AddonBridge.set_if_has(rc, "tag_for_child_directed_treatment", 0 if not ConsentProvider.TAG_FOR_CHILD_DIRECTED else 1)
		AddonBridge.set_if_has(rc, "tag_for_under_age_of_consent", 0 if not ConsentProvider.TAG_FOR_UNDER_AGE_OF_CONSENT else 1)
		AddonBridge.call_static("MobileAds", "set_request_configuration", [rc])
	AddonBridge.call_static("MobileAds", "initialize")


func is_ready(placement: String) -> bool:
	return _ads.has(placement)


func preload_ad(placement: String) -> void:
	if not _initialized or _loading.has(placement) or _ads.has(placement):
		return
	var loader = AddonBridge.make("RewardedAdLoader")
	var cb = AddonBridge.make("RewardedAdLoadCallback")
	var req = AddonBridge.make("AdRequest")
	if loader == null or cb == null or req == null:
		failed.emit(placement, "addon_missing")
		return
	if not _personalized:
		AddonBridge.set_if_has(req, "extras", {"npa": "1"})   # non-personalized ads
	_loading[placement] = true
	cb.set("on_ad_loaded", func(ad):
		_loading.erase(placement)
		_ads[placement] = ad
		ready_changed.emit(placement, true))
	cb.set("on_ad_failed_to_load", func(err):
		_loading.erase(placement)
		failed.emit(placement, "load_failed:%s" % str(err)))
	loader.call("load", unit_id_for(placement), req, cb)


func show(placement: String) -> void:
	var ad = _ads.get(placement)
	if ad == null:
		failed.emit(placement, "not_ready")
		return
	_ads.erase(placement)   # an ad is consumed when shown
	ready_changed.emit(placement, false)
	_showing_ad = ad
	_showing_placement = placement
	_earned = false
	var fsc = AddonBridge.make("FullScreenContentCallback")
	if fsc != null:
		fsc.set("on_ad_dismissed_full_screen_content", func(): _on_dismissed())
		fsc.set("on_ad_failed_to_show_full_screen_content", func(err): _on_show_failed(str(err)))
		ad.set("full_screen_content_callback", fsc)
	var listener = AddonBridge.make("OnUserEarnedRewardListener")
	if listener == null:
		_on_show_failed("addon_missing")
		return
	listener.set("on_user_earned_reward", func(_item): _on_earned())
	ad.call("show", listener)


func _on_earned() -> void:
	if _earned or _showing_placement == "":
		return   # exactly once per ad
	_earned = true
	rewarded.emit(_showing_placement)


func _on_dismissed() -> void:
	var p := _showing_placement
	_showing_placement = ""
	_showing_ad = null
	closed.emit(p)


func _on_show_failed(reason: String) -> void:
	var p := _showing_placement
	_showing_placement = ""
	_showing_ad = null
	failed.emit(p, "show_failed:%s" % reason)
