class_name AnalyticsProvider
extends RefCounted
## Interface for analytics (spec 8.6). Default is a no-op, used in the editor and in tests.

func log_event(_name: String, _params: Dictionary = {}) -> void:
	pass

## Consent gate (spec 8.7): false when the player declined (analytics storage denied). Real providers must stop
## collecting; the mock keeps recording so tests can still assert on events.
func set_collection_enabled(_on: bool) -> void:
	pass
