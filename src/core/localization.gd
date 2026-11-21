class_name Localization
extends RefCounted
## Spanish/English strings from res://i18n/strings.csv (columns key,en,es). Static API, no autoload.
## Never crashes and never shows a raw key when an English string exists:
## lookup order is current language -> English -> a humanized form of the key.
## Placeholders are {0}, {1}, ... filled from `args`. A literal "\n" in the CSV becomes a newline.

const CSV_PATH := "res://i18n/strings.csv"
const SUPPORTED: Array = ["en", "es"]
const DEFAULT_LANG := "en"

static var _lang := ""
static var _tables: Dictionary = {"en": {}, "es": {}}
static var _loaded := false


## Device language if supported (es or en), otherwise English.
static func detect_device_language() -> String:
	var l := OS.get_locale_language().to_lower()
	return l if l in SUPPORTED else DEFAULT_LANG


static func ensure_loaded() -> void:
	if _loaded:
		return
	load_csv(CSV_PATH)
	if _lang == "":
		_lang = detect_device_language()


## Loads (replacing) the tables from a CSV file. Returns the number of keys, 0 on failure.
static func load_csv(path: String = CSV_PATH) -> int:
	var en: Dictionary = {}
	var es: Dictionary = {}
	var f := FileAccess.open(path, FileAccess.READ)
	if f == null:
		push_warning("Localization: cannot open %s" % path)
		_tables = {"en": en, "es": es}
		_loaded = true
		return 0
	var first := true
	while not f.eof_reached():
		var row: PackedStringArray = f.get_csv_line()
		if first:
			first = false
			continue
		if row.size() < 3 or row[0].strip_edges() == "":
			continue
		var key := row[0].strip_edges()
		en[key] = _unescape(row[1])
		es[key] = _unescape(row[2])
	_tables = {"en": en, "es": es}
	_loaded = true
	return en.size()


## Replaces the tables directly (used by tests).
static func set_tables(en: Dictionary, es: Dictionary) -> void:
	_tables = {"en": en, "es": es}
	_loaded = true
	if _lang == "":
		_lang = DEFAULT_LANG


## Returns true if the language is supported. An unsupported language falls back to English.
static func set_language(lang: String) -> bool:
	ensure_loaded()
	var l := lang.to_lower()
	if l in SUPPORTED:
		_lang = l
		return true
	_lang = DEFAULT_LANG
	return false


static func get_language() -> String:
	ensure_loaded()
	return _lang


static func has_key(key: String) -> bool:
	ensure_loaded()
	return (_tables["en"] as Dictionary).has(key)


static func key_count() -> int:
	ensure_loaded()
	return (_tables["en"] as Dictionary).size()


## Translates `key` into the current language, filling {0}, {1}... from args.
static func tr_key(key: String, args: Array = []) -> String:
	ensure_loaded()
	var text := _lookup(key, _lang)
	for i in args.size():
		text = text.replace("{%d}" % i, _fmt_arg(args[i]))
	return text


## Same as tr_key but forces a language (for the language picker preview and tests).
static func tr_in(lang: String, key: String, args: Array = []) -> String:
	ensure_loaded()
	var text := _lookup(key, lang)
	for i in args.size():
		text = text.replace("{%d}" % i, _fmt_arg(args[i]))
	return text


## "unit.p1_club_worm.name" -> "P1 club worm"; "ui.btn_play" -> "Btn play".
static func humanize(key: String) -> String:
	var parts := key.split(".")
	var idx := parts.size() - 1
	while idx > 0 and parts[idx] in ["name", "desc", "plural", "short", "title"]:
		idx -= 1
	var s := parts[idx].replace("_", " ").strip_edges()
	if s == "":
		return "?"
	return s.substr(0, 1).to_upper() + s.substr(1)


static func _lookup(key: String, lang: String) -> String:
	var primary: Dictionary = _tables.get(lang, {})
	var v: String = primary.get(key, "")
	if v != "":
		return v
	var en: Dictionary = _tables["en"]
	v = en.get(key, "")
	if v != "":
		return v
	return humanize(key)


static func _unescape(s: String) -> String:
	return s.replace("\\n", "\n")


static func _fmt_arg(v) -> String:
	if v is float:
		var f: float = v
		if absf(f - roundf(f)) < 0.00001:
			return str(int(roundf(f)))
		return str(snappedf(f, 0.01))
	return str(v)
