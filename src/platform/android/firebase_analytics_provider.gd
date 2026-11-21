class_name FirebaseAnalyticsProvider
extends AnalyticsProvider
## Firebase Analytics through an Android plugin singleton. There is no first-party Godot Firebase plugin, so the
## adapter targets the minimal interface every community plugin exposes:
##   logEvent(name: String, params: Dictionary)   and   setAnalyticsCollectionEnabled(enabled: bool)
## Singleton names tried (first found wins): FIREBASE_SINGLETONS. Change the list when a plugin is chosen.
## Without the plugin: debug builds print the event to logcat (`adb logcat -s godot`), release builds do nothing.
## No PII ever reaches here (AnalyticsService drops personal keys); this layer also flattens values to what
## Firebase accepts: int/float/String only, names <= 40 chars, string values <= 100 chars, no arrays.
## STATUS: unverified on device (no plugin available in the build sandbox).

const FIREBASE_SINGLETONS := ["FirebaseAnalytics", "GodotFirebaseAnalytics"]
const MAX_NAME := 40
const MAX_VALUE := 100

var _plugin: Object = null
var _collecting := true


func _init() -> void:
	for n in FIREBASE_SINGLETONS:
		if AddonBridge.has_singleton(n):
			_plugin = AddonBridge.singleton(n)
			break


func is_supported() -> bool:
	return _plugin != null


func set_collection_enabled(on: bool) -> void:
	_collecting = on
	if _plugin != null and _plugin.has_method("setAnalyticsCollectionEnabled"):
		_plugin.call("setAnalyticsCollectionEnabled", on)


func log_event(event_name: String, params: Dictionary = {}) -> void:
	if not _collecting:
		return
	var flat := flatten(params)
	var n := event_name.substr(0, MAX_NAME)
	if _plugin != null and _plugin.has_method("logEvent"):
		_plugin.call("logEvent", n, flat)
	elif OS.is_debug_build():
		print("[analytics] %s %s" % [n, JSON.stringify(flat)])


## Firebase parameter rules: scalars only. Arrays become "a,b,c", bools become 0/1, keys are trimmed.
static func flatten(params: Dictionary) -> Dictionary:
	var out := {}
	for k in params:
		var v = params[k]
		var key := str(k).substr(0, MAX_NAME)
		match typeof(v):
			TYPE_BOOL:
				out[key] = 1 if v else 0
			TYPE_INT, TYPE_FLOAT:
				out[key] = v
			TYPE_ARRAY:
				out[key] = ",".join(PackedStringArray((v as Array).map(func(x): return str(x)))).substr(0, MAX_VALUE)
			_:
				out[key] = str(v).substr(0, MAX_VALUE)
	return out
