extends TestCase
## Localization loader, fallbacks and completeness of the real CSV.

func _reload_real() -> void:
	Localization.load_csv()

func test_csv_loads_and_has_both_languages() -> void:
	_reload_real()
	assert_true(Localization.key_count() > 300)
	assert_eq(Localization.tr_in("en", "currency.coins"), "Coins")
	assert_eq(Localization.tr_in("es", "currency.coins"), "Monedas")

func test_glossary_spec_9_4() -> void:
	_reload_real()
	var pairs := {"glossary.worm": ["Worm", "Gusano"], "currency.food": ["Food", "Comida"], "currency.gems": ["Gems", "Gemas"],
		"currency.capsule": ["Time Capsule", "Cápsula del Tiempo"], "currency.dust": ["Chrono Dust", "Polvo Crono"],
		"currency.relic": ["Relic", "Reliquia"], "glossary.squad": ["Squad", "Escuadrón"], "glossary.power": ["Power", "Poder"],
		"glossary.boss": ["Boss", "Jefe"], "glossary.era": ["Era", "Era"], "victory.title": ["Victory!", "¡Victoria!"], "defeat.title": ["Defeat", "Derrota"]}
	for k in pairs:
		assert_eq(Localization.tr_in("en", k), pairs[k][0], k)
		assert_eq(Localization.tr_in("es", k), pairs[k][1], k)
	assert_eq(Localization.tr_in("en", "app.title"), "Love 'n Wormholes")
	assert_eq(Localization.tr_in("es", "app.subtitle"), "Perdidos en el Tiempo")
	assert_eq(Localization.tr_in("es", "hero.wormina"), "Wormina")

func test_set_language_and_args() -> void:
	_reload_real()
	assert_true(Localization.set_language("es"))
	assert_eq(Localization.get_language(), "es")
	assert_eq(Localization.tr_key("ui.unlocks_level", [5]), "Se desbloquea en el nivel 5")
	Localization.set_language("en")
	assert_eq(Localization.tr_key("ui.unlocks_level", [5]), "Unlocks at level 5")
	assert_eq(Localization.tr_key("ui.level_n_to_m", [4, 5]), "Lv 4 to 5")
	assert_eq(Localization.tr_key("upgrades.base_desc", [10.0]), "+10% base HP per level", "whole floats print as ints")
	assert_true(not Localization.set_language("fr"))
	assert_eq(Localization.get_language(), "en", "unsupported language falls back to English")

func test_fallback_chain_never_raw() -> void:
	Localization.set_tables({"a.only_en": "English", "b.both": "Both"}, {"b.both": "Ambos", "c.empty": ""})
	Localization.set_language("es")
	assert_eq(Localization.tr_key("b.both"), "Ambos")
	assert_eq(Localization.tr_key("a.only_en"), "English", "es falls back to en")
	assert_eq(Localization.tr_key("c.empty"), "Empty", "empty es and missing en -> humanized")
	assert_eq(Localization.tr_key("ui.btn_play_now"), "Btn play now", "unknown key is humanized, never raw")
	assert_eq(Localization.tr_key("unit.p1_club_worm.name"), "P1 club worm")
	assert_eq(Localization.tr_key(""), "?")
	assert_eq(Localization.tr_key("a.only_en", [1, 2]), "English", "extra args are harmless")
	_reload_real()
	Localization.set_language("en")

func test_missing_arg_keeps_placeholder() -> void:
	Localization.set_tables({"x": "A {0} B {1}"}, {"x": "A {0} B {1}"})
	assert_eq(Localization.tr_key("x", ["1"]), "A 1 B {1}")
	_reload_real()

func test_device_language_detection() -> void:
	var l := Localization.detect_device_language()
	assert_true(l == "en" or l == "es")

func test_no_empty_strings_and_matching_placeholders() -> void:
	_reload_real()
	var re := RegEx.new()
	re.compile("\\{(\\d+)\\}")
	var f := FileAccess.open(Localization.CSV_PATH, FileAccess.READ)
	f.get_csv_line()
	var seen := {}
	var rows := 0
	while not f.eof_reached():
		var row := f.get_csv_line()
		if row.size() < 3:
			continue
		rows += 1
		assert_true(not seen.has(row[0]), "duplicate " + row[0])
		seen[row[0]] = true
		assert_true(row[1].strip_edges() != "" and row[2].strip_edges() != "", "empty string for " + row[0])
		var pe := []
		for m in re.search_all(row[1]):
			pe.append(m.get_string(1))
		var ps := []
		for m in re.search_all(row[2]):
			ps.append(m.get_string(1))
		pe.sort()
		ps.sort()
		assert_eq(pe, ps, "placeholders differ in " + row[0])
	assert_eq(rows, Localization.key_count())

func test_every_data_key_exists_in_en_and_es() -> void:
	_reload_real()
	var keys := []
	for kind in ["unit", "enemy", "boss"]:
		for id in DataDB.ids_of(kind):
			var e: Dictionary = DataDB.entry(kind, id)
			keys.append(e["name_key"]); keys.append(e["desc_key"])
	for id in DataDB.power_ids():
		keys.append(DataDB.power(id)["name_key"]); keys.append(DataDB.power(id)["desc_key"])
	for id in DataDB.relic_ids():
		keys.append(DataDB.relic(id)["name_key"]); keys.append(DataDB.relic(id)["desc_key"])
	for p in DataDB.shop()["products"]:
		keys.append(p["name_key"]); keys.append(p["desc_key"])
	for q in DataDB.quests():
		keys.append(q["name_key"])
	for p in DataDB.ads_config()["placements"]:
		keys.append(p["name_key"]); keys.append(p["desc_key"])
	for r in DataDB.ROLES:
		keys.append("role." + r)
		keys.append("role.%s.plural" % r)
	for era in range(1, 6):
		for suffix in ["name", "short", "enemy_base", "faction", "rule"]:
			keys.append("era.%d.%s" % [era, suffix])
		keys.append("story.era.%d.intro" % era)
		keys.append("story.era.%d.outro" % era)
	for k in keys:
		assert_true(Localization.has_key(k), "missing key " + k)

func test_describe_fills_args_from_data() -> void:
	_reload_real()
	assert_eq(Localization.set_language("en"), true)
	assert_eq(DataDB.describe(DataDB.unit("p2_shield_bearer_worm")), "Scarab shield blocks 20% of ranged damage")
	assert_eq(DataDB.describe(DataDB.power("squirm_slam")), "Ground slam: 60 damage in radius 3 and a 1.5 s stun")
	assert_eq(DataDB.describe(DataDB.relic("sticky_seed")), "+5% Food income")
	assert_eq(DataDB.describe(DataDB.ads_config()["placements"][1]), "Start the battle with +30% Food")
	assert_eq(DataDB.describe(DataDB.quests()[0], "name_key"), "Win 3 battles")
	Localization.set_language("es")
	assert_eq(DataDB.describe(DataDB.unit("p2_cobra_charmer_worm")), "La flauta y la cobra ralentizan 20% a los enemigos en alcance")
	Localization.set_language("en")

func test_spanish_length_budget() -> void:
	# Layouts tolerate up to 30% longer Spanish; flag strings that go far beyond it (short UI labels only).
	_reload_real()
	var f := FileAccess.open(Localization.CSV_PATH, FileAccess.READ)
	f.get_csv_line()
	var worst := 0.0
	while not f.eof_reached():
		var row := f.get_csv_line()
		if row.size() < 3 or not (row[0].begins_with("ui.") or row[0].begins_with("nav.") or row[0].begins_with("pause.")):
			continue
		if row[1].length() >= 6:
			var ratio := float(row[2].length()) / float(row[1].length())
			worst = maxf(worst, ratio)
			assert_true(ratio <= 1.7, "Spanish much longer than English: %s (%.2f)" % [row[0], ratio])
	assert_true(worst > 0.0)
