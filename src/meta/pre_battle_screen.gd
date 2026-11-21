class_name PreBattleScreen
extends Screen
## Pre-battle (mockup PreBattle): scout report, squad (3 Era-1 units this phase), powers, optional Food Boost ad.

var era := 1
var stage := 1
var squad: Array = []
var powers: Array = []
var food_boost := false
var start_button: Button
var back_button: Button
var boost_button: Button
var slot_notes: Array = []        # locked-slot labels (squad slots 4-5, third power slot)
var _boost_fraction := 0.3


func _ready() -> void:
	era = int(params.get("era", 1))
	stage = int(params.get("stage", 1))
	squad = MetaUI.default_squad()
	powers = MetaUI.default_powers()
	_boost_fraction = DataDB.bal_f("ads.food_boost_fraction", 0.3)
	var v := MetaUI.scaffold(self, 14)

	var head := HBoxContainer.new()
	back_button = UI.button(Game.t("ui.back"), "ghost", Vector2(110, UI.MIN_TOUCH), 18)
	back_button.name = "back_button"
	back_button.pressed.connect(func(): Game.nav.go("levels"))
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

func _squad_panel() -> Control:
	var p := UI.panel()
	p.name = "squad_panel"
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 8)
	p.add_child(box)
	box.add_child(UI.label(Game.t("prebattle.squad", [squad.size(), 5]), 20, UI.TEAL))
	var grid := GridContainer.new()
	grid.columns = 3
	grid.add_theme_constant_override("h_separation", 8)
	grid.add_theme_constant_override("v_separation", 8)
	box.add_child(grid)
	for id in squad:
		grid.add_child(_unit_card(str(id)))
	for slot in [4, 5]:
		var c := UI.panel(UI.LOCKED)
		c.custom_minimum_size = Vector2(0, 110)
		c.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		var cb := VBoxContainer.new()
		cb.alignment = BoxContainer.ALIGNMENT_CENTER
		c.add_child(cb)
		cb.add_child(UI.label(Game.t("prebattle.slot_n", [slot]), 16, UI.LOCKED_INK, HORIZONTAL_ALIGNMENT_CENTER))
		var note := UI.locked_note(Progress.feature_unlock_stage("squad"))
		note.name = "slot_note_%d" % slot
		cb.add_child(note)
		slot_notes.append(note)
		grid.add_child(c)
	return p


func _unit_card(id: String) -> Control:
	var u := DataDB.unit(id)
	var stats := DataDB.unit_stats(id, Game.economy.unit_level(id), int(u["era"]))
	var c := UI.panel()
	c.name = "unit_" + id
	c.custom_minimum_size = Vector2(0, 110)
	c.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var cb := VBoxContainer.new()
	cb.add_theme_constant_override("separation", 2)
	c.add_child(cb)
	cb.add_child(UI.label(Game.t(str(u["name_key"])), 15, UI.INK, HORIZONTAL_ALIGNMENT_CENTER))
	cb.add_child(UI.label(Game.t("role." + str(u["role"])), 14, UI.TEAL, HORIZONTAL_ALIGNMENT_CENTER))
	cb.add_child(UI.label(Game.t("prebattle.unit_cost", [int(round(float(stats["cost"])))]), 14, UI.LOCKED_INK, HORIZONTAL_ALIGNMENT_CENTER))
	return c


func _powers_panel() -> Control:
	var p := UI.panel()
	p.name = "powers_panel"
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 6)
	p.add_child(box)
	box.add_child(UI.label(Game.t("prebattle.powers"), 20, UI.TEAL))
	for id in powers:
		var d := DataDB.power(str(id))
		var l := UI.label("%s: %s" % [Game.t(str(d.get("name_key", ""))), DataDB.describe(d)], 16)
		l.name = "power_" + str(id)
		box.add_child(l)
	var note := UI.label(Game.t("prebattle.power_slot_locked", [1]), 14, UI.LOCKED_INK)
	note.name = "power_slot_note"
	box.add_child(note)
	slot_notes.append(note)
	return p


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
	Game.ads.show_ad("food_boost", {"food_fraction": _boost_fraction})


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
	Game.nav.go("battle", {"era": era, "stage": stage, "squad": squad.duplicate(), "powers": powers.duplicate(),
			"food_boost": food_boost})
