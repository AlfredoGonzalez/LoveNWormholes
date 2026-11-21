class_name PreBattleScreen
extends Screen
## Pre-battle (mockup PreBattle): scout report, Time Squad (active preset, tap to edit), equipped powers, optional Food Boost ad.

var era := 1
var stage := 1
var squad: Array = []
var powers: Array = []
var food_boost := false
var start_button: Button
var back_button: Button
var boost_button: Button
var slot_notes: Array = []        # locked-slot labels (squad slot 5 and power slot 3 while locked)
var preset_tabs: Array = []       # preset switcher buttons
var unit_cards: Dictionary = {}   # unit id -> card Button (tap opens the Squad screen)
var empty_slots: Array = []       # empty squad slot Buttons (tap opens the Squad screen)
var power_buttons: Array = []     # one Button per open power slot (tap swaps the power)
var _profile: Dictionary
var _body: VBoxContainer
var _boost_fraction := 0.3


func _ready() -> void:
	era = int(params.get("era", 1))
	stage = int(params.get("stage", 1))
	_profile = Game.save.profile
	squad = Squad.active(_profile)
	powers = Squad.equipped_powers(_profile)
	_boost_fraction = DataDB.bal_f("ads.food_boost_fraction", 0.3)
	var v := MetaUI.scaffold(self, 14)

	var head := HBoxContainer.new()
	back_button = UI.button(Game.t("ui.back"), "ghost", Vector2(110, UI.MIN_TOUCH), 18)
	back_button.name = "back_button"
	back_button.pressed.connect(func(): Game.nav.go("home"))
	head.add_child(back_button)
	var title := UI.label(Game.t("prebattle.stage_title", [era, stage]), 24, UI.INK, HORIZONTAL_ALIGNMENT_CENTER)
	title.name = "stage_title"
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	head.add_child(title)
	head.add_child(_gap(110))
	v.add_child(head)

	var scroll := ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	v.add_child(scroll)
	var body := VBoxContainer.new()
	body.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	body.add_theme_constant_override("separation", 12)
	scroll.add_child(body)
	_body = body
	body.add_child(_scout_panel())
	body.add_child(_squad_panel())
	body.add_child(_powers_panel())
	body.add_child(_boost_panel())

	start_button = UI.button(Game.t("prebattle.start"), "primary", Vector2(0, 68), 28)
	start_button.name = "start_button"
	start_button.pressed.connect(start_battle)
	v.add_child(start_button)

	Game.ads.reward_granted.connect(_on_reward)
	Game.ads.availability_changed.connect(_on_availability)
	Game.ads.ad_failed.connect(_on_ad_failed)


func _exit_tree() -> void:
	if Game.ads != null:
		for pair in [[Game.ads.reward_granted, _on_reward], [Game.ads.availability_changed, _on_availability],
				[Game.ads.ad_failed, _on_ad_failed]]:
			if (pair[0] as Signal).is_connected(pair[1]):
				(pair[0] as Signal).disconnect(pair[1])


func _gap(w: int) -> Control:
	var c := Control.new()
	c.custom_minimum_size = Vector2(w, 0)
	c.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return c


# ------------------------------------------------------------------ scout report

## Enemy role mix of a stage from its waves: {role: count}. Boss waves add the boss (its role) and escorts.
static func scout_mix(stage_def: Dictionary) -> Dictionary:
	var mix := {}
	for w in stage_def.get("waves", []):
		if w.has("enemy"):
			var e := DataDB.enemy(str(w["enemy"]))
			if not e.is_empty():
				mix[e["role"]] = int(mix.get(e["role"], 0)) + int(w.get("count", 1))
		elif w.has("boss"):
			var b := DataDB.boss(str(w["boss"]))
			if not b.is_empty():
				mix[b["role"]] = int(mix.get(b["role"], 0)) + 1
				for esc in b.get("escorts", []):
					var e2 := DataDB.enemy(str(esc.get("enemy", "")))
					if not e2.is_empty():
						mix[e2["role"]] = int(mix.get(e2["role"], 0)) + int(esc.get("count", 1))
	return mix


func _scout_panel() -> Control:
	var p := UI.panel()
	p.name = "scout_panel"
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 6)
	p.add_child(box)
	box.add_child(UI.label(Game.t("prebattle.scout"), 20, UI.TEAL))
	var def := DataDB.stage(era, stage)
	for w in def.get("waves", []):
		if w.has("boss"):
			var bl := UI.label(Game.t("map.boss", [Game.t(str(DataDB.boss(str(w["boss"])).get("name_key", "")))]), 20, UI.RED)
			bl.name = "boss_name"
			box.add_child(bl)
	var mix := scout_mix(def)
	var total := 0
	for r in mix:
		total += int(mix[r])
	for r in DataDB.ROLES:
		if not mix.has(r):
			continue
		var row := HBoxContainer.new()
		row.add_theme_constant_override("separation", 8)
		var l := UI.label(Game.t("prebattle.scout_row", [mix[r], Game.t("role.%s.plural" % r)]), 18)
		l.custom_minimum_size = Vector2(190, 0)
		row.add_child(l)
		var bar := ColorRect.new()
		bar.color = UI.RED if r != "shooter" else UI.BLUE
		bar.custom_minimum_size = Vector2(maxf(14.0, 200.0 * float(mix[r]) / maxf(total, 1)), 14)
		bar.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		row.add_child(bar)
		box.add_child(row)
	box.add_child(UI.label(Game.t("prebattle.tip"), 16, UI.LOCKED_INK))
	return p


# ------------------------------------------------------------------ squad and powers

func open_squad_editor() -> void:
	var p := {"from": "prebattle", "era": era, "stage": stage}
	Game.nav.go("squad", p)


func select_preset(i: int) -> void:
	if Squad.set_active_index(_profile, i):
		Game.save.save()
	_rebuild_loadout()


## Re-reads the squad and powers from the profile and redraws both panels.
func _rebuild_loadout() -> void:
	squad = Squad.active(_profile)
	powers = Squad.equipped_powers(_profile)
	for pair in [["squad_panel", 1], ["powers_panel", 2]]:
		var old := _body.get_node_or_null(str(pair[0]))
		if old != null:
			_body.remove_child(old)
			old.queue_free()
	var sp := _squad_panel()
	_body.add_child(sp)
	_body.move_child(sp, 1)
	var pp := _powers_panel()
	_body.add_child(pp)
	_body.move_child(pp, 2)


func _squad_panel() -> Control:
	unit_cards.clear()
	empty_slots.clear()
	preset_tabs.clear()
	slot_notes = slot_notes.filter(func(n): return is_instance_valid(n) and (n as Node).name.begins_with("power_slot_note"))
	var p := UI.panel()
	p.name = "squad_panel"
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 8)
	p.add_child(box)
	var open := Squad.slots(_profile)
	box.add_child(UI.label(Game.t("prebattle.squad", [squad.size(), open]), 20, UI.TEAL))
	var tabs := HBoxContainer.new()
	tabs.add_theme_constant_override("separation", 8)
	for i in Squad.preset_count(_profile):
		var b := UI.button(Game.t("squad.preset_n", [i + 1]), "teal" if i == Squad.active_index(_profile) else "ghost", Vector2(0, UI.MIN_TOUCH), 16)
		b.name = "preset_%d" % i
		b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		b.pressed.connect(select_preset.bind(i))
		tabs.add_child(b)
		preset_tabs.append(b)
	box.add_child(tabs)
	var grid := GridContainer.new()
	grid.columns = 3
	grid.add_theme_constant_override("h_separation", 8)
	grid.add_theme_constant_override("v_separation", 8)
	box.add_child(grid)
	for i in Squad.max_slots():
		if i >= open:
			var lk := MetaUI.card_button(Vector2(0, 110), "locked")
			(lk.get_node("box") as Control).add_child(UI.label(Game.t("prebattle.slot_n", [i + 1]), 15, UI.LOCKED_INK, HORIZONTAL_ALIGNMENT_CENTER))
			var note := UI.label(Game.t("ui.unlocks_boss", [Squad.slot_unlock_era()]), 13, UI.LOCKED_INK, HORIZONTAL_ALIGNMENT_CENTER)
			note.name = "slot_note_%d" % (i + 1)
			(lk.get_node("box") as Control).add_child(note)
			slot_notes.append(note)
			grid.add_child(lk)
		elif i < squad.size():
			grid.add_child(_unit_card(str(squad[i])))
		else:
			var e := MetaUI.card_button(Vector2(0, 110), "empty")
			e.name = "empty_slot_%d" % (i + 1)
			(e.get_node("box") as Control).add_child(UI.label(Game.t("prebattle.add_unit"), 16, UI.LOCKED_INK, HORIZONTAL_ALIGNMENT_CENTER))
			e.pressed.connect(open_squad_editor)
			empty_slots.append(e)
			grid.add_child(e)
	box.add_child(UI.label(Game.t("prebattle.edit_hint"), 14, UI.LOCKED_INK))
	return p


func _unit_card(id: String) -> Control:
	var u := DataDB.unit(id)
	var stats := DataDB.unit_stats(id, Game.economy.unit_level(id), int(u["era"]))
	var c := MetaUI.card_button(Vector2(0, 110))
	c.name = "unit_" + id
	var cb: Control = c.get_node("box")
	cb.add_child(UI.label(Game.t(str(u["name_key"])), 15, UI.INK, HORIZONTAL_ALIGNMENT_CENTER))
	cb.add_child(UI.label(Game.t("role." + str(u["role"])), 14, UI.TEAL, HORIZONTAL_ALIGNMENT_CENTER))
	cb.add_child(UI.label(Game.t("prebattle.unit_cost", [int(round(float(stats["cost"])))]), 14, UI.LOCKED_INK, HORIZONTAL_ALIGNMENT_CENTER))
	c.pressed.connect(open_squad_editor)
	unit_cards[id] = c
	return c


func _powers_panel() -> Control:
	power_buttons.clear()
	slot_notes = slot_notes.filter(func(n): return is_instance_valid(n) and not (n as Node).name.begins_with("power_slot_note"))
	var p := UI.panel()
	p.name = "powers_panel"
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 6)
	p.add_child(box)
	box.add_child(UI.label(Game.t("prebattle.powers"), 20, UI.TEAL))
	var open := Squad.power_slots(_profile)
	for i in Squad.max_power_slots():
		if i >= open:
			var note := UI.label(Game.t("ui.unlocks_boss", [Squad.power_slot_unlock_era()]), 14, UI.LOCKED_INK)
			note.name = "power_slot_note_%d" % (i + 1)
			var lk := MetaUI.card_button(Vector2(0, 56), "locked")
			(lk.get_node("box") as Control).add_child(UI.label(Game.t("prebattle.power_n", [i + 1]), 14, UI.LOCKED_INK))
			(lk.get_node("box") as Control).add_child(note)
			slot_notes.append(note)
			box.add_child(lk)
			continue
		var b := MetaUI.card_button(Vector2(0, 72), "normal" if i < powers.size() else "empty")
		b.name = "power_slot_%d" % i
		var bb: Control = b.get_node("box")
		if i < powers.size():
			var d := DataDB.power(str(powers[i]))
			bb.add_child(UI.label(Game.t(str(d.get("name_key", ""))), 17, UI.INK))
			var desc := UI.label(DataDB.describe(d), 13, UI.LOCKED_INK)
			desc.name = "power_" + str(powers[i])
			bb.add_child(desc)
		else:
			bb.add_child(UI.label(Game.t("prebattle.power_empty"), 15, UI.LOCKED_INK))
		b.pressed.connect(cycle_power.bind(i))
		power_buttons.append(b)
		box.add_child(b)
	box.add_child(UI.label(Game.t("prebattle.power_swap_hint"), 14, UI.LOCKED_INK))
	return p


## Puts the next unlocked power into `slot` (cycling through Squad.unlocked_powers; a power already equipped in
## another slot swaps places). A slot with no power takes the first one not equipped yet.
func cycle_power(slot: int) -> void:
	var avail := Squad.unlocked_powers(_profile)
	if avail.is_empty() or slot >= Squad.power_slots(_profile):
		return
	var next := ""
	if slot < powers.size():
		next = avail[(avail.find(str(powers[slot])) + 1) % avail.size()]
	else:
		for id in avail:
			if not (id in powers):
				next = id
				break
	if next == "":
		return
	var out := Squad.power_with_slot(powers, slot, next)
	if Squad.set_equipped_powers_and_save(Game.save, out):
		_rebuild_loadout()


# ------------------------------------------------------------------ Food Boost (optional rewarded ad)

func _boost_text() -> String:
	return Game.t("prebattle.food_boost", [MetaUI.percent(_boost_fraction)])


func _boost_panel() -> Control:
	boost_button = MetaUI.ad_button("food_boost", _boost_text())
	boost_button.pressed.connect(_on_boost_pressed)
	_refresh_boost()
	return boost_button


func _refresh_boost() -> void:
	if boost_button == null:
		return
	var done := Game.t("prebattle.food_boost_on", [MetaUI.percent(_boost_fraction)]) if food_boost else ""
	MetaUI.refresh_ad_button(boost_button, "food_boost", _boost_text(), done)


func _on_boost_pressed() -> void:
	if food_boost:
		return
	Game.claim_bonus("food_boost", {"food_fraction": _boost_fraction})


func _on_reward(placement: String, _reward: Dictionary) -> void:
	if placement == "food_boost":
		food_boost = true
		_refresh_boost()


func _on_availability(placement: String) -> void:
	if placement == "food_boost":
		_refresh_boost()


func _on_ad_failed(placement: String, _reason: String) -> void:
	if placement == "food_boost":
		_refresh_boost()


func start_battle() -> void:
	var route := Story.before_battle(Game.save.profile, era, stage, {"era": era, "stage": stage, "squad": squad.duplicate(),
			"powers": powers.duplicate(), "food_boost": food_boost})   # stage 1 of an era: opening comic once
	Game.nav.go(route[0], route[1])
