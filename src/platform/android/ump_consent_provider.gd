class_name UmpConsentProvider
extends ConsentProvider
## Google User Messaging Platform (UMP) through the poing-studios Godot AdMob addon (classes
## UserMessagingPlatform, ConsentRequestParameters). The game's own consent screen always runs; this adds the
## platform form only where UMP says it is required (EEA/UK; not expected for a Latin America only release).
## STATUS: follows the addon README, unverified on device (see docs/ANDROID.md). Without the addon it behaves
## like the base class: status "not_required", no form.

var _status := "unknown"


func is_supported() -> bool:
	return AddonBridge.has_addon_class("UserMessagingPlatform") and AddonBridge.has_addon_class("ConsentRequestParameters")


func request_info_update() -> void:
	if not is_supported():
		_status = "not_required"
		info_updated.emit(_status)
		return
	var params = AddonBridge.make("ConsentRequestParameters")
	# Audience 13+: not under the age of consent.
	AddonBridge.set_if_has(params, "tag_for_under_age_of_consent", ConsentProvider.TAG_FOR_UNDER_AGE_OF_CONSENT)
	var info = AddonBridge.get_property_safe(AddonBridge.script_of("UserMessagingPlatform"), "consent_information")
	if info == null:
		_status = "not_required"
		info_updated.emit(_status)
		return
	info.call("update", params,
		func():
			_status = _map(int(info.call("get_consent_status"))) if info.has_method("get_consent_status") else "unknown"
			info_updated.emit(_status),
		func(_err):
			_status = "unknown"
			info_updated.emit(_status))


## UMP ConsentStatus: 0 UNKNOWN, 1 NOT_REQUIRED, 2 REQUIRED, 3 OBTAINED.
func _map(code: int) -> String:
	match code:
		1:
			return "not_required"
		2:
			return "required"
		3:
			return "obtained"
	return "unknown"


func status() -> String:
	return _status


func is_form_required() -> bool:
	return _status == "required"


func show_form() -> void:
	if not is_supported():
		form_dismissed.emit(_status)
		return
	AddonBridge.call_static("UserMessagingPlatform", "load_and_show_consent_form_if_required", [
		func(_err):
			_status = "obtained"
			form_dismissed.emit(_status)])


func privacy_options_required() -> bool:
	return _status == "required"
