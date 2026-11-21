class_name ConsentProvider
extends RefCounted
## Interface for the platform consent layer (spec 7.1, 8.7): Google UMP on Android, a mock elsewhere.
## The game always shows its own consent screen (src/meta/consent_screen.gd); a provider only adds what the
## platform requires on top of it (the UMP form in regions that need it) and forwards the final choice to the
## SDKs. Implementations: platform/mock, platform/android.

signal info_updated(status: String)     # "unknown" | "required" | "not_required" | "obtained"
signal form_dismissed(status: String)   # after show_form(); same statuses

## Audience: 13+ (not child-directed), Latin America only. Passed to the ad SDK by the adapters.
const MAX_AD_CONTENT_RATING := "T"
const TAG_FOR_CHILD_DIRECTED := false
const TAG_FOR_UNDER_AGE_OF_CONSENT := false

func request_info_update() -> void:
	info_updated.emit("not_required")

func status() -> String:
	return "not_required"

func is_form_required() -> bool:
	return false

func show_form() -> void:
	form_dismissed.emit("obtained")

func privacy_options_required() -> bool:
	return false

## Final in-game choice. `personalized` false means non-personalized ads / analytics storage denied.
func apply_choice(_personalized: bool) -> void:
	pass

func reset() -> void:
	pass
