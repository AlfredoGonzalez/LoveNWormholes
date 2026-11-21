class_name AddonBridge
extends RefCounted
## Compile-safe access to Godot Android plugins/addons that are NOT in the repo (they are installed per build,
## see docs/ANDROID.md). Nothing here references a plugin class statically, so the project imports and the tests
## run headless without any plugin: every lookup is by name at runtime and returns null/false when absent.

## True when a native plugin singleton (Android plugin v2 .aar registered with the engine) exists.
static func has_singleton(singleton_name: String) -> bool:
	return Engine.has_singleton(singleton_name)


static func singleton(singleton_name: String) -> Object:
	return Engine.get_singleton(singleton_name) if Engine.has_singleton(singleton_name) else null


## True when a GDScript addon class (class_name) is present in the project, e.g. "MobileAds".
static func has_addon_class(addon_class: String) -> bool:
	return script_of(addon_class) != null


static func script_of(addon_class: String) -> Script:
	for c in ProjectSettings.get_global_class_list():
		if str(c.get("class", "")) == addon_class:
			return load(str(c["path"]))
	return null


## Instance of an addon class, or null.
static func make(addon_class: String) -> Variant:
	var s := script_of(addon_class)
	return s.new() if s != null else null


## Calls a static function of an addon class (e.g. MobileAds.initialize()); null when absent.
static func call_static(addon_class: String, method: String, args: Array = []) -> Variant:
	var s := script_of(addon_class)
	if s == null or not s.has_method(method):
		return null
	return s.callv(method, args)


## Sets a property only if the object has it (plugin versions differ).
static func set_if_has(obj: Object, prop: String, value: Variant) -> void:
	if obj == null:
		return
	for p in obj.get_property_list():
		if str(p["name"]) == prop:
			obj.set(prop, value)
			return


## Reads a property / static var of an object or script; null when it has none.
static func get_property_safe(obj: Object, prop: String) -> Variant:
	if obj == null:
		return null
	for p in obj.get_property_list():
		if str(p["name"]) == prop:
			return obj.get(prop)
	return null
