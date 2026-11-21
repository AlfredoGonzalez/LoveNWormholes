class_name SquadScreen
extends Screen
## Squad and Collection (mockup Squad): all 15 units with an era filter, a unit detail panel, the counters chart
## and the Time Squad presets. Tapping a card adds/removes the unit in the active preset and shows its details.
## params: {from: "prebattle", era, stage} returns to the pre-battle screen; otherwise Back goes to "home".

var filter_era := 0                     # 0 = all eras
var selected_unit := ""
var back_button: Button
var era_chips: Dictionary = {}          # 0 (all) / 1..5 -> Button
var unit_cards: Dictionary = {}         # unit id -> Button
var preset_tabs: Array = []             # Buttons
var slot_buttons: Array = []            # filled/empty squad slot Buttons, in order
var slot_notes: Array = []              # "Unlocks after the Era N boss" labels of locked slots
var status_label: Label
var _preset_box: VBoxContainer
var _slots_box: VBoxContainer
var _grid_holder: VBoxContainer
var _detail_holder: VBoxContainer
var _profile: Dictionary


func _ready() -> void:
	_profile = Game.save.profile
	var v := MetaUI.scaffold(self, 14)

	var head := HBoxContainer.new()
	back_button = UI.button(Game.t("ui.back"), "ghost", Vector2(110, UI.MIN_TOUCH), 18)
	back_button.name = "back_button"
	back_button.pressed.connect(go_back)
	head.add_child(back_button)
	var title := UI.label(Game.t("squad.title"), 24, UI.INK, HORIZONTAL_ALIGNMENT_CENTER)
	title.name = "title"
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	head.add_child(title)
	var gap := Control.new()
	gap.custom_minimum_size = Vector2(110, 0)
	gap.mouse_filter = Control.MOUSE_FILTER_IGNORE
	head.add_child(gap)
	v.add_child(head)
	v.add_child(MetaUI.currency_bar())

	var scroll := ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	v.add_child(scroll)
	var body := VBoxContainer.new()
	body.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	body.add_theme_constant_override("separation", 12)
	scroll.add_child(body)

	# squad presets
	var squad_panel := UI.panel()
	squad_panel.name = "squad_panel"
	var sbox := VBoxContainer.new()
	sbox.add_theme_constant_override("separation", 8)
	squad_panel.add_child(sbox)
	_preset_box = VBoxContainer.new()
	sbox.add_child(_preset_box)
	_slots_box = VBoxContainer.new()
	_slots_box.add_theme_constant_override("separation", 6)
	sbox.add_child(_slots_box)
	status_label = UI.label("", 15, UI.RED)
	status_label.name = "status"
	sbox.add_child(status_label)
	body.add_child(squad_panel)

	# collection
	body.add_child(UI.label(Game.t("squad.collection"), 20, UI.TEAL))
	body.add_child(_filter_row())
	_grid_holder = VBoxContainer.new()
	body.add_child(_grid_holder)
	_detail_holder = VBoxContainer.new()
	body.add_child(_detail_holder)
	body.add_child(_counters_panel())

	_refresh_all()


func go_back() -> void:
	if str(params.get("from", "")) == "prebattle":
		var p := params.duplicate()
		p.erase("from")
		Game.nav.go("prebattle", p)
	else:
		Game.nav.go("home")


# ------------------------------------------------------------------ helpers

## The era the player has reached (highest unlocked): stats are shown scaled for it (time sync).
func current_era() -> int:
	var e := 1
	for era in range(1, DataDB.bal_i("campaign.eras", 5) + 1):
		if Progress.is_era_unlocked(_profile, era):
			e = era
	return e


func preset_index() -> int:
	return Squad.active_index(_profile)


## Units of the preset being edited (validated; the defaults when the stored preset is empty).
func squad_units() -> Array:
	return Squad.active(_profile)


func _refresh_all() -> void:
	_refresh_presets()
	_refresh_slots()
	_refresh_filter()
	_refresh_grid()
	_refresh_detail()


# ------------------------------------------------------------------ presets and slots

func _refresh_presets() -> void:
	MetaUI.clear_children(_preset_box)
	preset_tabs.clear()
	_preset_box.add_child(UI.label(Game.t("squad.presets"), 20, UI.TEAL))
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 8)
	for i in Squad.preset_count(_profile):
		var b := UI.button(Game.t("squad.preset_n", [i + 1]), "teal" if i == preset_index() else "ghost", Vector2(0, UI.MIN_TOUCH), 18)
		b.name = "preset_%d" % i
		b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		b.pressed.connect(select_preset.bind(i))
		row.add_child(b)
		preset_tabs.append(b)
	_preset_box.add_child(row)


func select_preset(i: int) -> void:
	if Squad.set_active_index(_profile, i):
		Game.save.save()
	status_label.text = ""
	_refresh_all()


func _refresh_slots() -> void:
	MetaUI.clear_children(_slots_box)
	slot_buttons.clear()
	slot_notes.clear()
	var units := squad_units()
	var open := Squad.slots(_profile)
	_slots_box.add_child(UI.label(Game.t("squad.slots_title", [units.size(), open]), 18, UI.INK))
	var grid := GridContainer.new()
	grid.columns = 3
	grid.add_theme_constant_override("h_separation", 8)
	grid.add_theme_constant_override("v_separation", 8)
	_slots_box.add_child(grid)
	for i in Squad.max_slots():
		if i >= open:
			var lk := MetaUI.card_button(Vector2(0, 84), "locked")
			var note := UI.label(Game.t("ui.unlocks_boss", [Squad.slot_unlock_era()]), 13, UI.LOCKED_INK, HORIZONTAL_ALIGNMENT_CENTER)
			note.name = "slot_note_%d" % (i + 1)
			(lk.get_node("box") as Control).add_child(note)
			slot_notes.append(note)
			grid.add_child(lk)
		elif i < units.size():
			var id := str(units[i])
			var u := DataDB.unit(id)
			var b := MetaUI.card_button(Vector2(0, 84), "selected")
			b.name = "slot_%d" % i
			var box: Control = b.get_node("box")
			box.add_child(UI.label(Game.t(str(u["name_key"])), 14, UI.INK, HORIZONTAL_ALIGNMENT_CENTER))
			box.add_child(UI.label(Game.t("role." + str(u["role"])), 13, UI.TEAL, HORIZONTAL_ALIGNMENT_CENTER))
			b.pressed.connect(toggle_unit.bind(id))
			grid.add_child(b)
			slot_buttons.append(b)
		else:
			var e := MetaUI.card_button(Vector2(0, 84), "empty")
			e.name = "slot_%d" % i
			(e.get_node("box") as Control).add_child(UI.label(Game.t("squad.empty_slot"), 14, UI.LOCKED_INK, HORIZONTAL_ALIGNMENT_CENTER))
			grid.add_child(e)
			slot_buttons.append(e)
	_slots_box.add_child(UI.label(Game.t("squad.detail_hint"), 14, UI.LOCKED_INK))


## Adds the unit to the active preset, or removes it when it is already there. Selects it for the detail panel.
## Returns true when the squad changed.
func toggle_unit(id: String) -> bool:
	selected_unit = id
	var ids := squad_units()
	var changed := false
	status_label.text = ""
	if id in ids:
		if ids.size() <= 1:
			status_label.text = Game.t("squad.keep_one")
		else:
			ids.erase(id)
			changed = true
	elif ids.size() >= Squad.slots(_profile):
		status_label.text = Game.t("squad.full")
	elif Squad.is_unit_unlocked(_profile, id):
		ids.append(id)
		changed = true
	if changed and Squad.set_preset(_profile, preset_index(), ids):
		Game.save.save()
	else:
		changed = false
	_refresh_slots()
	_refresh_grid()
	_refresh_detail()
	return changed


# ------------------------------------------------------------------ era filter and grid

func _filter_row() -> Control:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 6)
	era_chips.clear()
	var all := UI.button(Game.t("squad.all"), "ghost", Vector2(0, UI.MIN_TOUCH), 16)
	all.name = "era_chip_0"
	all.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	all.pressed.connect(set_filter.bind(0))
	row.add_child(all)
	era_chips[0] = all
	for era in range(1, DataDB.bal_i("campaign.eras", 5) + 1):
		var b := UI.button(Game.t("squad.era_n", [era]), "ghost", Vector2(0, UI.MIN_TOUCH), 16)
		b.name = "era_chip_%d" % era
		b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		b.pressed.connect(set_filter.bind(era))
		row.add_child(b)
		era_chips[era] = b
	return row


func set_filter(era: int) -> void:
	filter_era = era
	_refresh_filter()
	_refresh_grid()


func _refresh_filter() -> void:
	for era in era_chips:
		var b: Button = era_chips[era]
		var on: bool = era == filter_era
		var bg := UI.TEAL if on else UI.PANEL
		b.add_theme_stylebox_override("normal", UI.style(bg))
		b.add_theme_stylebox_override("hover", UI.style(bg.lightened(0.08)))
		for c in ["font_color", "font_hover_color", "font_pressed_color", "font_focus_color"]:
			b.add_theme_color_override(c, Color.WHITE if on else UI.INK)


func _refresh_grid() -> void:
	MetaUI.clear_children(_grid_holder)
	unit_cards.clear()
	var grid := GridContainer.new()
	grid.columns = 3
	grid.add_theme_constant_override("h_separation", 8)
	grid.add_theme_constant_override("v_separation", 8)
	_grid_holder.add_child(grid)
	var ids := squad_units()
	for id in DataDB.unit_ids():
		var u := DataDB.unit(str(id))
		if filter_era != 0 and int(u["era"]) != filter_era:
			continue
		grid.add_child(_unit_card(str(id), str(id) in ids))


func _unit_card(id: String, in_squad: bool) -> Control:
	var u := DataDB.unit(id)
	var unlocked := Squad.is_unit_unlocked(_profile, id)
	var kind := "locked" if not unlocked else ("selected" if in_squad or id == selected_unit else "normal")
	var c := MetaUI.card_button(Vector2(0, 124), kind)
	c.name = "unit_" + id
	var box: Control = c.get_node("box")
	var role_line := Game.t("squad.role_era", [Game.t("role." + str(u["role"])), int(u["era"])])
	if unlocked:
		var stats := DataDB.unit_stats(id, Squad.unit_level(_profile, id), current_era())
		box.add_child(UI.label(Game.t(str(u["name_key"])), 15, UI.INK, HORIZONTAL_ALIGNMENT_CENTER))
		box.add_child(UI.label(role_line, 13, UI.TEAL, HORIZONTAL_ALIGNMENT_CENTER))
		box.add_child(UI.label(Game.t("ui.level_short", [Squad.unit_level(_profile, id)]), 13, UI.INK, HORIZONTAL_ALIGNMENT_CENTER))
		box.add_child(UI.label(Game.t("squad.stat_summary", [int(round(float(stats["hp"]))), int(round(float(stats["damage"])))]), 12, UI.LOCKED_INK, HORIZONTAL_ALIGNMENT_CENTER))
		if in_squad:
			box.add_child(UI.label("✓ " + Game.t("squad.in_squad"), 12, UI.GREEN.darkened(0.35), HORIZONTAL_ALIGNMENT_CENTER))
		c.pressed.connect(toggle_unit.bind(id))
	else:
		box.add_child(UI.label(role_line, 13, UI.LOCKED_INK, HORIZONTAL_ALIGNMENT_CENTER))
		var note := UI.label(Game.t("squad.locked_era", [int(u["era"])]), 13, UI.LOCKED_INK, HORIZONTAL_ALIGNMENT_CENTER)
		note.name = "locked_note"
		box.add_child(note)
	unit_cards[id] = c
	return c


# ------------------------------------------------------------------ detail and counters

func _refresh_detail() -> void:
	MetaUI.clear_children(_detail_holder)
	if selected_unit == "" or not Squad.is_unit_unlocked(_profile, selected_unit):
		return
	var u := DataDB.unit(selected_unit)
	var stats := DataDB.unit_stats(selected_unit, Squad.unit_level(_profile, selected_unit), current_era())
	var p := UI.panel()
	p.name = "detail_panel"
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 4)
	p.add_child(box)
	var name_l := UI.label(Game.t(str(u["name_key"])), 22, UI.INK)
	name_l.name = "detail_name"
	box.add_child(name_l)
	box.add_child(UI.label("%s · %s" % [Game.t("squad.role_era", [Game.t("role." + str(u["role"])), int(u["era"])]),
			Game.t("ui.level_short", [Squad.unit_level(_profile, selected_unit)])], 16, UI.TEAL))
	box.add_child(UI.label(Game.t("role." + str(u["role"]) + ".desc"), 14, UI.LOCKED_INK))
	var g := GridContainer.new()
	g.columns = 2
	g.add_theme_constant_override("h_separation", 12)
	box.add_child(g)
	var lines := [
		Game.t("squad.stat_hp", [int(round(float(stats["hp"])))]),
		Game.t("squad.stat_damage", [int(round(float(stats["damage"])))]),
		Game.t("squad.stat_cost", [int(round(float(stats["cost"])))]),
		Game.t("squad.stat_range", [snappedf(float(stats["range"]), 0.1)]),
		Game.t("squad.stat_speed", [int(round(float(stats["speed"])))]),
		Game.t("squad.stat_interval", [snappedf(float(stats["interval"]), 0.1)]),
		Game.t("squad.stat_cooldown", [snappedf(float(stats["spawn_cooldown"]), 0.1)]),
	]
	for t in lines:
		var l := UI.label(t, 15)
		l.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		g.add_child(l)
	var ab := UI.label("%s: %s" % [Game.t("squad.ability"), DataDB.describe(u)], 15, UI.INK)
	ab.name = "detail_ability"
	box.add_child(ab)
	_detail_holder.add_child(p)


func _counters_panel() -> Control:
	var p := UI.panel()
	p.name = "counters_panel"
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 4)
	p.add_child(box)
	box.add_child(UI.label(Game.t("squad.counters"), 20, UI.TEAL))
	# Rows come from the balance data (strong_against), so the chart never disagrees with the simulation.
	for r in ["fighter", "shooter", "heavy"]:
		for target in DataDB.role_base(r).get("strong_against", []):
			var l := UI.label(Game.t("squad.beats", [Game.t("role." + r), Game.t("role." + str(target))]), 16)
			l.name = "counter_%s_%s" % [r, target]
			box.add_child(l)
	box.add_child(UI.label(Game.t("squad.air_note"), 16))
	box.add_child(UI.label(Game.t("squad.counter_note", [DataDB.bal_f("battle.counter_strong_mult")]), 14, UI.LOCKED_INK))
	box.add_child(UI.label(Game.t("squad.counter_weak", [DataDB.bal_f("battle.counter_weak_mult")]), 14, UI.LOCKED_INK))
	return p
