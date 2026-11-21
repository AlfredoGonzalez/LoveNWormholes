class_name AnalyticsProvider
extends RefCounted
## Interface for analytics (spec 8.6). Default is a no-op, used in the editor and in tests.

func log_event(_name: String, _params: Dictionary = {}) -> void:
	pass
