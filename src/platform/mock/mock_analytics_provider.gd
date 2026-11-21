class_name MockAnalyticsProvider
extends AnalyticsProvider
## Records events in memory so tests can assert on them.

var events: Array = []   # [{name, params}]

func log_event(name: String, params: Dictionary = {}) -> void:
	events.append({"name": name, "params": params})

func names() -> Array:
	return events.map(func(e): return e["name"])

func count(name: String) -> int:
	return names().count(name)
