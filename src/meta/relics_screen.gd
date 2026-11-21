class_name RelicsScreen
extends Screen
## Relic collection (spec 7.4): every relic with level, effect, equip/unequip (limited slots, `capsule.relic_slots`)
## and crafting / levelling with Chrono Dust. Active bonuses are summed per stat with the +25% cap applied.

const RARITY_COLORS := {"common": UI.GREEN, "rare": UI.BLUE, "epic": UI.GOLD}
const REDUCTIONS: Array = ["spawn_cooldown", "power_cooldown"]

var capsules: Capsules
## "equip:<id>" and "craft:<id>" -> Button (tests look them up here).
var buttons: Dictionary = {}
var _built := false
var _chips: HBoxContainer
var _summary: VBoxContainer
var _list: VBoxContainer
var _msg: Label


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
	back.pressed.connect(func(): Game.nav.go("capsules"))
	top.add_child(back)
	var title := UI.label(Game.t("relics.title"), 26, UI.INK, HORIZONTAL_ALIGNMENT_CENTER)
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	top.add_child(title)
	_chips = HBoxContainer.new()
	_chips.add_theme_constant_override("separation", 6)
	root.add_child(_chips)
	_summary = VBoxContainer.new()
	_summary.add_theme_constant_override("separation", 2)
	var sp := UI.panel()
	sp.add_child(_summary)
	root.add_child(sp)
	_msg = UI.label("", 14, UI.RED, HORIZONTAL_ALIGNMENT_CENTER)
	root.add_child(_msg)
	var scroll := ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	root.add_child(scroll)
	_list = VBoxContainer.new()
	_list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_list.add_theme_constant_override("separation", 8)
	scroll.add_child(_list)
	refresh()


func refresh() -> void:
	var profile: Dictionary = Game.save.profile
	MetaUI.clear_children(_chips)
	_chips.add_child(UI.chip("✦", str(Game.economy.get_amount("chrono_dust"))))
	var owned := 0
	for id in DataDB.relic_ids():
		if Relics.level(profile, id) > 0:
			owned += 1
	_chips.add_child(UI.chip("◉", Game.t("capsules.relics_count", [owned, DataDB.relic_ids().size()])))
	MetaUI.clear_children(_summary)
	_summary.add_child(UI.label("%s · %s" % [Game.t("relics.active"), Game.t("relics.equipped_count", [Relics.equipped(profile).size(), Relics.slots()])], 16, UI.TEAL))
	var mods := Relics.modifiers(profile)
	var any := false
	for stat in Relics.STATS:
		if float(mods[stat]) > 0.0:
			any = true
			_summary.add_child(UI.label(bonus_text(stat, float(mods[stat])), 14))
	if not any:
		_summary.add_child(UI.label(Game.t("relics.none_active"), 14, UI.LOCKED_INK))
	_summary.add_child(UI.label(Game.t("capsules.cap_note", [roundi(DataDB.bal_f("capsule.relic_bonus_cap") * 100.0)]), 12, UI.LOCKED_INK))
	MetaUI.clear_children(_list)
	buttons.clear()
	for rarity in Capsules.RARITY_ORDER:
		for id in capsules.relics_of(rarity):
			_add_card(str(id))


static func bonus_text(stat: String, fraction: float) -> String:
	var key := "relics.bonus_minus" if REDUCTIONS.has(stat) else "relics.bonus_plus"
	return Game.t(key, [Game.t("relics.stat." + stat), CapsuleScreen._pct(fraction)])


func _add_card(id: String) -> void:
	var profile: Dictionary = Game.save.profile
	var r := DataDB.relic(id)
	var rarity := str(r["rarity"])
	var lv := Relics.level(profile, id)
	var mx := Relics.max_level(id)
	var panel := UI.panel()
	panel.name = "relic_" + id
	_list.add_child(panel)
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 10)
	panel.add_child(row)
	row.add_child(UI.placeholder(Game.t("rarity." + rarity), RARITY_COLORS.get(rarity, UI.LOCKED), Vector2(64, 64)))
	var mid := VBoxContainer.new()
	mid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	mid.add_theme_constant_override("separation", 2)
	row.add_child(mid)
	var name_l := UI.label(Game.t(str(r["name_key"])), 18)
	name_l.custom_minimum_size.x = 120
	mid.add_child(name_l)
	var desc := UI.label(DataDB.describe(r), 13)
	desc.custom_minimum_size.x = 120
	mid.add_child(desc)
	var status := UI.label(Game.t("relics.level_of", [lv, mx]) if lv > 0 else Game.t("relics.not_found"), 14, UI.TEAL if lv > 0 else UI.LOCKED_INK)
	status.custom_minimum_size.x = 120
	mid.add_child(status)
	if lv > 0:
		var cur := UI.label(Game.t("relics.current", [bonus_text(str(r["stat"]), float(r["bonus"]) * lv)]), 13, UI.LOCKED_INK)
		cur.custom_minimum_size.x = 120
		mid.add_child(cur)

	var right := VBoxContainer.new()
	right.custom_minimum_size.x = 140
	right.add_theme_constant_override("separation", 4)
	row.add_child(right)
	if lv > 0:
		var on := Relics.is_equipped(profile, id)
		var eb := UI.button(Game.t("relics.unequip") if on else Game.t("relics.equip"), "ghost" if on else "teal", Vector2(140, 48), 16)
		eb.pressed.connect(toggle_equip.bind(id))
		right.add_child(eb)
		buttons["equip:" + id] = eb
	var why := capsules.craft_block_reason(id)
	var cost := capsules.dust_cost(rarity)
	var cb: Button
	if why == "max_level":
		cb = UI.button(Game.t("relics.max_level"), "off", Vector2(140, 48), 14)
	else:
		cb = UI.button(Game.t("relics.craft", [cost]) if lv == 0 else Game.t("relics.upgrade_dust", [cost]), "primary" if why == "" else "off", Vector2(140, 48), 14)
		cb.disabled = why != ""
		cb.pressed.connect(craft.bind(id))
	cb.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	right.add_child(cb)
	buttons["craft:" + id] = cb


## Equips or removes a relic; reports a full-slots message instead of failing silently.
func toggle_equip(id: String) -> bool:
	var profile: Dictionary = Game.save.profile
	var ok: bool
	if Relics.is_equipped(profile, id):
		ok = Relics.unequip(profile, id)
	else:
		ok = Relics.equip(profile, id)
		if not ok:
			_msg.text = Game.t("relics.slots_full")
	if ok:
		_msg.text = ""
		Game.save.save()
	refresh()
	return ok


func craft(id: String) -> bool:
	var res := capsules.craft(id)
	_msg.text = "" if bool(res["ok"]) else Game.t("capsules.not_enough_dust")
	if bool(res["ok"]):
		Game.audio.play_sfx("coin")
	refresh()
	return bool(res["ok"])
