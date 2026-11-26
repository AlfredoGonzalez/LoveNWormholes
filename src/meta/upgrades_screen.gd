class_name UpgradesScreen
extends Screen
## Upgrades (spec 6.2, mockup Upgrades.dc.html): tabs Units / Food Burrow / Base / Powers, paid with Coins.
## Every number comes from Game.economy / DataDB; every text from Game.t. Rebuilt in code on every change.

const TABS := ["units", "burrow", "base", "powers"]
const TAB_KEYS := {"units": "upgrades.tab_units", "burrow": "upgrades.tab_burrow", "base": "upgrades.tab_base", "powers": "upgrades.tab_powers"}
const ROLE_COLORS := {"fighter": UI.ORANGE, "shooter": UI.TEAL, "heavy": UI.BLUE, "support": UI.GREEN, "air": UI.GOLD}
const SFX_OK := "coin"

var tab := "units"
## "unit:<id>", "burrow", "base", "power:<id>" -> upgrade Button (tests and tutorials look them up here).
var upgrade_buttons: Dictionary = {}
var _chips: HBoxContainer
var _list: VBoxContainer
var _tab_buttons: Dictionary = {}


var _built := false


func _ready() -> void:
	ensure_built()


## Builds the node tree once (idempotent: tests call it when the screen is not ready yet).
func ensure_built() -> void:
	if _built:
		return
	_built = true
	add_child(UI.background())
	var margin := MarginContainer.new()
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	for side in ["left", "right"]:
		margin.add_theme_constant_override("margin_" + side, 16)
	margin.add_theme_constant_override("margin_top", 16)
	margin.add_theme_constant_override("margin_bottom", 16)
	add_child(margin)
	var root := VBoxContainer.new()
	root.add_theme_constant_override("separation", 10)
	margin.add_child(root)

	var top := HBoxContainer.new()
	top.add_theme_constant_override("separation", 8)
	root.add_child(top)
	var back := UI.button(Game.t("ui.back"), "ghost", Vector2(96, 0), 20)
	back.pressed.connect(func(): Game.nav.go("home"))
	top.add_child(back)
	var title := UI.label(Game.t("upgrades.title"), 28, UI.INK, HORIZONTAL_ALIGNMENT_CENTER)
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	top.add_child(title)
	_chips = HBoxContainer.new()
	_chips.add_theme_constant_override("separation", 6)
	top.add_child(_chips)

	var tabs := HBoxContainer.new()
	tabs.add_theme_constant_override("separation", 6)
	root.add_child(tabs)
	for t in TABS:
		var b := UI.button(Game.t(TAB_KEYS[t]), "ghost", Vector2(0, 56), 15)
		b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		b.clip_text = false
		b.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		b.pressed.connect(select_tab.bind(t))
		tabs.add_child(b)
		_tab_buttons[t] = b

	var scroll := ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	root.add_child(scroll)
	_list = VBoxContainer.new()
	_list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_list.add_theme_constant_override("separation", 10)
	scroll.add_child(_list)

	Game.economy.currency_changed.connect(_on_currency_changed)
	refresh()


func _exit_tree() -> void:
	if Game.economy != null and Game.economy.currency_changed.is_connected(_on_currency_changed):
		Game.economy.currency_changed.disconnect(_on_currency_changed)


func _on_currency_changed(_c: String, _v: int, _d: int) -> void:
	if is_inside_tree():
		_rebuild_chips()


func select_tab(name: String) -> void:
	if not TABS.has(name):
		return
	tab = name
	refresh()


func refresh() -> void:
	_rebuild_chips()
	for t in _tab_buttons:
		var b: Button = _tab_buttons[t]
		var on: bool = t == tab
		b.add_theme_stylebox_override("normal", UI.style(UI.ORANGE if on else UI.PANEL))
		b.add_theme_stylebox_override("hover", UI.style((UI.ORANGE if on else UI.PANEL).lightened(0.08)))
	for c in _list.get_children():
		_list.remove_child(c)
		c.queue_free()
	upgrade_buttons.clear()
	match tab:
		"units": _build_units()
		"burrow": _build_burrow()
		"base": _build_base()
		"powers": _build_powers()


func _rebuild_chips() -> void:
	for c in _chips.get_children():
		_chips.remove_child(c)
		c.queue_free()
	_chips.add_child(UI.chip(Game.t("currency.coins"), str(Game.economy.get_amount("coins")), "icon_coin"))
	_chips.add_child(UI.chip(Game.t("currency.gems"), str(Game.economy.get_amount("gems")), "icon_gem"))


# ---------------------------------------------------------------- tabs

func _build_units() -> void:
	var profile: Dictionary = Game.save.profile
	for era in range(1, DataDB.bal_i("campaign.eras", 5) + 1):
		if not Progress.is_era_unlocked(profile, era):
			continue
		for u in DataDB.units_of_era(era):
			_add_unit_card(u)


func _add_unit_card(u: Dictionary) -> void:
	var id := str(u["id"])
	var era := int(u["era"])
	var lv := Game.economy.unit_level(id)
	var max_lv := Game.economy.unit_max_level()
	var cur := DataDB.unit_stats(id, lv, era)
	var lines: Array = []
	var cost := Game.economy.unit_upgrade_cost(lv + 1)
	if cost >= 0:
		var nxt := DataDB.unit_stats(id, lv + 1, era)
		var pct := roundi(DataDB.bal_f("scaling.unit_level_step") * 100.0)
		lines.append(Game.t("upgrades.unit_gain", [lv, lv + 1, pct]))
		lines.append(Game.t("upgrades.stat_change", [Game.t("upgrades.hp"), _n(cur["hp"]), _n(nxt["hp"])]))
		lines.append(Game.t("upgrades.stat_change", [Game.t("upgrades.damage"), _n(cur["damage"]), _n(nxt["damage"])]))
	else:
		lines.append(Game.t("upgrades.stat_change", [Game.t("upgrades.hp"), _n(cur["hp"]), _n(cur["hp"])]))
		lines.append(Game.t("upgrades.stat_change", [Game.t("upgrades.damage"), _n(cur["damage"]), _n(cur["damage"])]))
	lines.append("%s: %s" % [Game.t("upgrades.food_cost"), _n(cur["cost"])])
	var role := str(u["role"])
	_add_card("unit:" + id, Game.t(str(u["name_key"])), Game.t("upgrades.era_role", [era, Game.t("role." + role)]),
		lines, lv, max_lv, cost, ROLE_COLORS.get(role, UI.LOCKED), func(): _do_upgrade(func(): return Game.economy.upgrade_unit(id)))


func _build_burrow() -> void:
	var lv := Game.economy.burrow_level()
	var cost := Game.economy.burrow_cost(lv + 1)
	var nxt := mini(lv + 1, Game.economy.burrow_max_level())
	var lines: Array = [
		Game.t("upgrades.burrow_desc", [Game.economy.burrow_income_bonus(2), Game.economy.burrow_cap_bonus(2)]),
		Game.t("upgrades.stat_change", [Game.t("upgrades.income"), _n(DataDB.burrow_income(lv)), _n(DataDB.burrow_income(nxt))]),
		Game.t("upgrades.stat_change", [Game.t("upgrades.food_cap"), _n(DataDB.burrow_cap(lv)), _n(DataDB.burrow_cap(nxt))]),
	]
	_add_card("burrow", Game.t("upgrades.tab_burrow"), "", lines, lv, Game.economy.burrow_max_level(), cost, UI.GREEN,
		func(): _do_upgrade(func(): return Game.economy.upgrade_burrow()))


func _build_base() -> void:
	var lv := Game.economy.base_level()
	var cost := Game.economy.base_cost(lv + 1)
	var nxt := mini(lv + 1, Game.economy.base_max_level())
	var pct := roundi(DataDB.bal_f("upgrades.base.hp_per_level") * 100.0)
	var lines: Array = [
		Game.t("upgrades.base_desc", [pct]),
		Game.t("upgrades.stat_change", [Game.t("upgrades.base_hp"), _n(DataDB.player_base_hp(1, lv)), _n(DataDB.player_base_hp(1, nxt))]),
	]
	_add_card("base", Game.t("upgrades.tab_base"), "", lines, lv, Game.economy.base_max_level(), cost, UI.BLUE,
		func(): _do_upgrade(func(): return Game.economy.upgrade_base()))


func _build_powers() -> void:
	for id in DataDB.power_ids():
		var p := DataDB.power(id)
		if str(p.get("unlock", {}).get("type", "")) != "start" and not Game.save.profile["upgrades"]["powers"].has(id):
			continue   # boss-unlocked powers appear once owned (their unlock flow is another screen)
		var lv := Game.economy.power_level(id)
		var cost := Game.economy.power_cost(lv + 1)
		var nxt := mini(lv + 1, Game.economy.power_max_level())
		var cd_now := float(DataDB.power_params(id, lv)["cooldown"])
		var cd_next := float(DataDB.power_params(id, nxt)["cooldown"])
		var eff := roundi(DataDB.bal_f("upgrades.power.effect_per_level") * 100.0)
		var cdp := roundi(DataDB.bal_f("upgrades.power.cooldown_per_level") * 100.0)
		var lines: Array = [
			DataDB.describe(p),
			Game.t("upgrades.power_desc", [eff, cdp]),
			Game.t("upgrades.stat_change", [Game.t("upgrades.cooldown"), Game.t("ui.seconds_short", [_n(cd_now)]), Game.t("ui.seconds_short", [_n(cd_next)])]),
		]
		_add_card("power:" + id, Game.t(str(p["name_key"])), "", lines, lv, Game.economy.power_max_level(), cost, UI.RED,
			func(): _do_upgrade(func(): return Game.economy.upgrade_power(id)))


# ---------------------------------------------------------------- card

## cost < 0 means max level. The button is disabled (and greyed) at max level or when Coins are short; a reason
## line says why.
func _add_card(key: String, title: String, subtitle: String, lines: Array, lv: int, max_lv: int, cost: int,
		color: Color, on_upgrade: Callable) -> void:
	var panel := UI.panel()
	_list.add_child(panel)
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 10)
	panel.add_child(row)
	var art_tex: Texture2D = null
	if key.begins_with("unit:"):
		art_tex = SpriteFactory.portrait_trimmed(key.substr(5))
	elif key.begins_with("power:"):
		art_tex = SpriteFactory.texture_of("power_" + key.substr(6))
	var art := SpriteFactory.rect_of(art_tex, 56.0)
	if art != null:
		art.name = "Art"
		row.add_child(art)
	else:
		row.add_child(UI.placeholder("", color, Vector2(56, 56)))

	var mid := VBoxContainer.new()
	mid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	mid.add_theme_constant_override("separation", 2)
	row.add_child(mid)
	var name_l := UI.label(title, 20)
	name_l.custom_minimum_size.x = 120
	mid.add_child(name_l)
	if subtitle != "":
		var s := UI.label(subtitle, 14, UI.LOCKED_INK)
		s.custom_minimum_size.x = 120
		mid.add_child(s)
	var lvl := UI.label(Game.t("upgrades.level_of", [lv, max_lv]), 15, UI.TEAL)
	lvl.custom_minimum_size.x = 120
	mid.add_child(lvl)
	for line in lines:
		var l := UI.label(str(line), 13, UI.INK)
		l.custom_minimum_size.x = 120
		mid.add_child(l)

	var right := VBoxContainer.new()
	right.custom_minimum_size.x = 130
	right.add_theme_constant_override("separation", 4)
	row.add_child(right)
	var at_max := cost < 0
	var coins := Game.economy.get_amount("coins")
	var affordable := not at_max and coins >= cost
	var btn: Button
	var reason := ""
	if at_max:
		btn = UI.button(Game.t("ui.max"), "off", Vector2(130, 56), 18)
		reason = Game.t("upgrades.max_reached")
	elif not affordable:
		btn = UI.button(Game.t("upgrades.upgrade_for", [cost]), "off", Vector2(130, 56), 16)
		reason = Game.t("ui.need_more", [cost - coins])
	else:
		btn = UI.button(Game.t("upgrades.upgrade_for", [cost]), "primary", Vector2(130, 56), 16)
	btn.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	btn.disabled = at_max or not affordable
	btn.pressed.connect(on_upgrade)
	right.add_child(btn)
	if reason != "":
		var r := UI.label(reason, 13, UI.RED, HORIZONTAL_ALIGNMENT_CENTER)
		r.custom_minimum_size.x = 120
		right.add_child(r)
	upgrade_buttons[key] = btn


func _do_upgrade(action: Callable) -> void:
	if bool(action.call()):
		Game.audio.play_sfx(SFX_OK)
	refresh()


static func _n(v) -> String:
	var f := float(v)
	if absf(f - roundf(f)) < 0.05:
		return str(int(roundf(f)))
	return str(snappedf(f, 0.1))
