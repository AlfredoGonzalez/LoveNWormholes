class_name CapsuleScreen
extends Screen
## Time Capsules (spec 7.4): open capsules, see the reveal, odds, pity counters and Dust conversion in plain text.
## Logic lives in Capsules (core); this screen only shows it. Odds and pity are always visible (store policy, no
## dark patterns). Texts from Game.t, numbers from Capsules/DataDB.

const RARITY_COLORS := {"common": UI.GREEN, "rare": UI.BLUE, "epic": UI.GOLD}
const ANIM_TIME := 0.7

## false in tests: results appear immediately without the shake/reveal tween.
var animate := true
var capsules: Capsules
var last_results: Array = []
## Named controls tests and tutorials look up.
var open_button: Button
var open_many_button: Button
var buy_button: Button
var buy_bundle_button: Button
var bonus_button: Button
var relics_button: Button
var again_button: Button
var pity_rare_bar: ProgressBar
var pity_epic_bar: ProgressBar
var odds_label: Label

var _built := false
var _chips: HBoxContainer
var _stage: VBoxContainer       # the reveal area
var _results: VBoxContainer
var _capsule_art: Control
var _pity_box: VBoxContainer
var _buttons_box: VBoxContainer
var _tween: Tween


func _ready() -> void:
	ensure_built()


func ensure_built() -> void:
	if _built:
		return
	_built = true
	capsules = Capsules.new(Game.economy)
	add_child(UI.background())
	var margin := MarginContainer.new()
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	for side in ["left", "right", "top", "bottom"]:
		margin.add_theme_constant_override("margin_" + side, 16)
	add_child(margin)
	var root := VBoxContainer.new()
	root.add_theme_constant_override("separation", 8)
	margin.add_child(root)

	var top := HBoxContainer.new()
	top.add_theme_constant_override("separation", 8)
	root.add_child(top)
	var back := UI.button(Game.t("ui.back"), "ghost", Vector2(96, 0), 20)
	back.name = "back"
	back.pressed.connect(func(): Game.nav.go("home"))
	top.add_child(back)
	var title := UI.label(Game.t("capsules.title"), 26, UI.INK, HORIZONTAL_ALIGNMENT_CENTER)
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	top.add_child(title)
	_chips = HBoxContainer.new()
	_chips.add_theme_constant_override("separation", 6)
	root.add_child(_chips)

	var scroll := ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	root.add_child(scroll)
	var body := VBoxContainer.new()
	body.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	body.add_theme_constant_override("separation", 10)
	scroll.add_child(body)

	# Reveal area: capsule art (placeholder) + results list.
	var stage_panel := UI.panel()
	body.add_child(stage_panel)
	_stage = VBoxContainer.new()
	_stage.add_theme_constant_override("separation", 8)
	stage_panel.add_child(_stage)
	_capsule_art = UI.placeholder("◉", UI.TEAL, Vector2(120, 120))
	_capsule_art.name = "capsule_art"
	_capsule_art.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	_capsule_art.pivot_offset = Vector2(60, 60)
	_stage.add_child(_capsule_art)
	_results = VBoxContainer.new()
	_results.name = "results"
	_results.add_theme_constant_override("separation", 6)
	_stage.add_child(_results)

	_buttons_box = VBoxContainer.new()
	_buttons_box.add_theme_constant_override("separation", 6)
	body.add_child(_buttons_box)

	# Odds, pity and Dust in plain text.
	var info := UI.panel()
	body.add_child(info)
	_pity_box = VBoxContainer.new()
	_pity_box.name = "info"
	_pity_box.add_theme_constant_override("separation", 6)
	info.add_child(_pity_box)

	Game.economy.currency_changed.connect(_on_currency_changed)
	refresh()


func _exit_tree() -> void:
	if Game.economy != null and Game.economy.currency_changed.is_connected(_on_currency_changed):
		Game.economy.currency_changed.disconnect(_on_currency_changed)


func _on_currency_changed(_c: String, _v: int, _d: int) -> void:
	if is_inside_tree() and _built:
		_rebuild_chips()


# ---------------------------------------------------------------- actions

## Opens `count` capsules (1 or Capsules `open_many`). Returns the results.
func open(count: int) -> Array:
	var results := capsules.open_many(count)
	if results.is_empty():
		return results
	last_results = results
	for r in results:
		var pity := int(Game.save.profile["pity"].get("since_rare", 0))
		Game.analytics.capsule_open(str(r["rarity"]), pity)
	var best := "common"
	for r in results:
		if Capsules.RARITY_ORDER.find(str(r["rarity"])) > Capsules.RARITY_ORDER.find(best):
			best = str(r["rarity"])
	Game.audio.play_sfx("capsule_" + best)
	refresh()
	_play_reveal(results)
	return results


func buy(bundle: bool) -> bool:
	var ok := capsules.buy_with_gems(bundle)
	if ok:
		Game.audio.play_sfx("coin")
	refresh()
	return ok


func _watch_bonus_ad() -> void:
	if Game.quests.bonus_capsule_available():
		Game.claim_bonus("bonus_capsule", {"capsules": DataDB.bal_i("ads.bonus_capsule_count", 1)})   # no ad with the Golden Pass


# ---------------------------------------------------------------- building

func refresh() -> void:
	_rebuild_chips()
	_rebuild_buttons()
	_rebuild_info()


func _rebuild_chips() -> void:
	MetaUI.clear_children(_chips)
	var e := Game.economy
	_chips.add_child(UI.chip("◉", str(e.get_amount("capsules"))))
	_chips.add_child(UI.chip("◆", str(e.get_amount("gems"))))
	_chips.add_child(UI.chip("✦", str(e.get_amount("chrono_dust"))))


func _rebuild_buttons() -> void:
	MetaUI.clear_children(_buttons_box)
	var have := Game.economy.get_amount("capsules")
	var many := DataDB.bal_i("capsule.open_many", 10)
	_buttons_box.add_child(UI.label(Game.t("capsules.have", [have]), 18, UI.INK, HORIZONTAL_ALIGNMENT_CENTER))
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 8)
	_buttons_box.add_child(row)
	open_button = UI.button(Game.t("capsules.open_1"), "primary" if have >= 1 else "off", Vector2(0, 60), 20)
	open_button.name = "open_1"
	open_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	open_button.disabled = have < 1
	open_button.pressed.connect(func(): open(1))
	row.add_child(open_button)
	open_many_button = UI.button(Game.t("capsules.open_n", [many]), "primary" if have >= many else "off", Vector2(0, 60), 20)
	open_many_button.name = "open_many"
	open_many_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	open_many_button.disabled = have < many
	open_many_button.pressed.connect(func(): open(many))
	row.add_child(open_many_button)
	again_button = open_button
	if have < 1:
		_buttons_box.add_child(UI.label(Game.t("capsules.no_capsules"), 14, UI.RED, HORIZONTAL_ALIGNMENT_CENTER))

	var gems := Game.economy.get_amount("gems")
	var brow := HBoxContainer.new()
	brow.add_theme_constant_override("separation", 8)
	_buttons_box.add_child(brow)
	var p1 := capsules.gem_price_single()
	var pb := capsules.gem_price_bundle()
	buy_button = UI.button(Game.t("capsules.buy_1", [p1]), "teal" if gems >= p1 else "off", Vector2(0, 52), 15)
	buy_button.name = "buy_1"
	buy_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	buy_button.disabled = gems < p1
	buy_button.pressed.connect(func(): buy(false))
	brow.add_child(buy_button)
	buy_bundle_button = UI.button(Game.t("capsules.buy_bundle", [capsules.bundle_count(), pb]), "teal" if gems >= pb else "off", Vector2(0, 52), 15)
	buy_bundle_button.name = "buy_bundle"
	buy_bundle_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	buy_bundle_button.disabled = gems < pb
	buy_bundle_button.pressed.connect(func(): buy(true))
	brow.add_child(buy_bundle_button)
	if gems < p1:
		_buttons_box.add_child(UI.label(Game.t("capsules.not_enough_gems"), 13, UI.LOCKED_INK, HORIZONTAL_ALIGNMENT_CENTER))

	bonus_button = MetaUI.ad_button("bonus_capsule", Game.t("ads.bonus_capsule.desc", [DataDB.bal_i("ads.bonus_capsule_count", 1)]))
	if not Game.quests.bonus_capsule_available():
		MetaUI.refresh_ad_button(bonus_button, "bonus_capsule", "", Game.t("daily.bonus_used"))
	bonus_button.pressed.connect(_watch_bonus_ad)
	_buttons_box.add_child(bonus_button)

	relics_button = UI.button(Game.t("capsules.my_relics"), "ghost", Vector2(0, 52), 18)
	relics_button.name = "relics"
	relics_button.pressed.connect(func(): Game.nav.go("relics"))
	_buttons_box.add_child(relics_button)


func _rebuild_info() -> void:
	MetaUI.clear_children(_pity_box)
	var odds := capsules.rarity_odds()
	odds_label = UI.label(Game.t("capsules.odds", [_pct(odds["common"]), _pct(odds["rare"]), _pct(odds["epic"])]), 14)
	odds_label.name = "odds"
	_pity_box.add_child(odds_label)

	_pity_box.add_child(UI.label(Game.t("capsules.pity"), 18, UI.TEAL))
	var pt := capsules.pity()
	pity_rare_bar = _pity_row(Game.t("capsules.rare_label"), int(pt["since_rare"]), capsules.rare_every(), int(pt["rare_in"]))
	pity_epic_bar = _pity_row(Game.t("capsules.epic_label"), int(pt["since_epic"]), capsules.epic_every(), int(pt["epic_in"]))

	_pity_box.add_child(UI.label(Game.t("capsules.dust_gain", [capsules.dust_on_duplicate("common"), capsules.dust_on_duplicate("rare"), capsules.dust_on_duplicate("epic")]), 14))
	_pity_box.add_child(UI.label(Game.t("capsules.dust_prices", [capsules.dust_cost("common"), capsules.dust_cost("rare"), capsules.dust_cost("epic")]), 14))
	_pity_box.add_child(UI.label(Game.t("capsules.cap_note", [roundi(DataDB.bal_f("capsule.relic_bonus_cap") * 100.0)]), 14))
	_pity_box.add_child(UI.label(Game.t("capsules.free_note"), 13, UI.LOCKED_INK))


func _pity_row(title: String, since: int, every: int, left: int) -> ProgressBar:
	var l := UI.label("%s: %s" % [title, Game.t("capsules.pity_now") if left <= 1 else Game.t("capsules.pity_progress", [since, every])], 14)
	_pity_box.add_child(l)
	var bar := ProgressBar.new()
	bar.custom_minimum_size = Vector2(0, 14)
	bar.max_value = every
	bar.value = since
	bar.show_percentage = false
	_pity_box.add_child(bar)
	return bar


static func _pct(fraction: float) -> String:
	var v := fraction * 100.0
	return str(int(v)) if absf(v - roundf(v)) < 0.001 else str(snappedf(v, 0.1))


# ---------------------------------------------------------------- reveal

func _play_reveal(results: Array) -> void:
	MetaUI.clear_children(_results)
	if _tween != null and _tween.is_valid():
		_tween.kill()
	_capsule_art.rotation = 0.0
	_capsule_art.modulate = Color.WHITE
	if animate and is_inside_tree():
		var l := UI.label(Game.t("capsules.opening"), 16, UI.LOCKED_INK, HORIZONTAL_ALIGNMENT_CENTER)
		l.name = "opening"
		_results.add_child(l)
		_tween = create_tween()
		for a in [0.25, -0.25, 0.18, -0.18, 0.0]:
			_tween.tween_property(_capsule_art, "rotation", a, ANIM_TIME / 5.0)
		_tween.tween_callback(_show_results.bind(results))
	else:
		_show_results(results)


func _show_results(results: Array) -> void:
	if not is_instance_valid(_results):
		return
	MetaUI.clear_children(_results)
	_results.add_child(UI.label(Game.t("capsules.results"), 18, UI.TEAL, HORIZONTAL_ALIGNMENT_CENTER))
	for i in results.size():
		var row := result_row(results[i])
		_results.add_child(row)
		if animate and is_inside_tree():
			row.modulate.a = 0.0
			create_tween().tween_property(row, "modulate:a", 1.0, 0.25).set_delay(0.08 * i)


## One revealed capsule: rarity-coloured badge, relic name, what happened (new / level / dust) and the pity note.
func result_row(r: Dictionary) -> Control:
	var rarity := str(r["rarity"])
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 10)
	row.add_child(UI.placeholder(Game.t("rarity." + rarity), RARITY_COLORS.get(rarity, UI.LOCKED), Vector2(72, 56)))
	var mid := VBoxContainer.new()
	mid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(mid)
	var rid := str(r["relic_id"])
	mid.add_child(UI.label(Game.t(str(DataDB.relic(rid).get("name_key", "capsules.title"))), 18))
	var detail := ""
	match str(r["kind"]):
		"new": detail = Game.t("capsules.kind_new")
		"level_up": detail = Game.t("capsules.kind_level", [r["level"]])
		"dust": detail = Game.t("capsules.kind_dust", [r["dust"]])
	if bool(r.get("pity_rare", false)) or bool(r.get("pity_epic", false)):
		detail += " · " + Game.t("capsules.pity_forced")
	mid.add_child(UI.label(detail, 14, UI.TEAL))
	return row
