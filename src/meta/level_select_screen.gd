class_name LevelSelectScreen
extends Screen
## World map (mockup WorldMap): currency chips, era tabs, zigzag stage path with stars, Play, bottom bar.
## World Map (mockup WorldMap): back to Home, currency chips, era tabs 1-5 (locked / coming soon notes), zigzag stage path with stars, boss node, Wormina echo markers and hint.
const OFFSETS := [-90, 0, 90, 0]
const NODE_SIZE := 68.0
const BOSS_SIZE := 92.0

var selected_era := 1
var back_button: Button
var stage_buttons := {}       # stage index -> Button (selected era)
var era_buttons := {}         # era -> Button
var echo_hint: Control
var _scroll: ScrollContainer
var _path_box: VBoxContainer
var _profile: Dictionary


func _ready() -> void:
	_profile = Game.save.profile
	var next := Progress.next_stage(_profile)
	selected_era = int(next["era"])
	var v := MetaUI.scaffold(self, 12)

	var top := HBoxContainer.new()
	top.add_theme_constant_override("separation", 10)
	back_button = UI.button("‹", "ghost", Vector2(52, 52), 28)
	back_button.name = "back_button"
	back_button.tooltip_text = Game.t("ui.back")
	back_button.pressed.connect(func(): Game.nav.go("home"))
	top.add_child(back_button)
	var title := UI.label(Game.t("map.title"), 28, UI.INK)
	title.name = "map_title"
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	top.add_child(title)
	v.add_child(top)
	v.add_child(MetaUI.currency_bar())

	var tabs := HBoxContainer.new()
	tabs.add_theme_constant_override("separation", 6)
	for era in range(1, DataDB.bal_i("campaign.eras", 5) + 1):
		var b := UI.button("", "ghost", Vector2(0, UI.MIN_TOUCH), 18)
		b.name = "era_%d" % era
		b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		b.pressed.connect(select_era.bind(era))
		tabs.add_child(b)
		era_buttons[era] = b
	v.add_child(tabs)

	_scroll = ScrollContainer.new()
	_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	v.add_child(_scroll)
	_path_box = VBoxContainer.new()
	_path_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_path_box.add_theme_constant_override("separation", 4)
	_scroll.add_child(_path_box)

	echo_hint = UI.panel()
	echo_hint.name = "echo_hint"
	echo_hint.add_child(UI.label("♥ " + Game.t("map.echo_hint", [5]), 16, UI.RED, HORIZONTAL_ALIGNMENT_CENTER))
	v.add_child(echo_hint)
	select_era(selected_era)


func select_era(era: int) -> void:
	selected_era = era
	for e in era_buttons:
		var locked := not Progress.is_era_unlocked(_profile, e)
		var b: Button = era_buttons[e]
		b.text = ("🔒 %d" if locked else "%d") % e
		b.tooltip_text = Game.t("map.locked_era", [e - 1]) if locked else Game.t("map.era_tab", [e])
		b.add_theme_stylebox_override("normal", UI.style(UI.ORANGE if e == era else (UI.LOCKED if locked else UI.PANEL)))
		b.add_theme_color_override("font_color", UI.LOCKED_INK if locked else UI.INK)
	_rebuild_path()


func _rebuild_path() -> void:
	for c in _path_box.get_children():
		_path_box.remove_child(c)
		c.queue_free()
	stage_buttons.clear()
	_path_box.add_child(UI.label(Game.t("home.era_line", [selected_era, Game.t("era.%d.short" % selected_era)]), 22, UI.TEAL, HORIZONTAL_ALIGNMENT_CENTER))
	if not Progress.is_era_unlocked(_profile, selected_era):
		var l := UI.label(Game.t("map.locked_era", [selected_era - 1]), 22, UI.LOCKED_INK, HORIZONTAL_ALIGNMENT_CENTER)
		l.name = "era_locked_note"
		_path_box.add_child(l)
		return
	var stages := DataDB.stages_of_era(selected_era)
	if stages.is_empty():
		var l := UI.label(Game.t("map.era_empty"), 22, UI.LOCKED_INK, HORIZONTAL_ALIGNMENT_CENTER)
		l.name = "era_empty_note"
		_path_box.add_child(l)
		return
	var next := Progress.next_stage(_profile)
	# Boss at the top, stage 1 at the bottom (the path climbs).
	for i in range(stages.size() - 1, -1, -1):
		var idx := int(stages[i]["index"])
		var is_current: bool = int(next["era"]) == selected_era and int(next["stage"]) == idx
		_path_box.add_child(_make_row(idx, i, is_current))
	call_deferred("_scroll_to_current", next)


func _make_row(idx: int, pos: int, is_current: bool) -> Control:
	var boss := DataDB.is_boss_stage(DataDB.stage_number(selected_era, idx))
	var unlocked := Progress.is_stage_unlocked(_profile, selected_era, idx)
	var cleared := Progress.is_stage_cleared(_profile, selected_era, idx)
	var size := BOSS_SIZE if boss else NODE_SIZE
	var row := HBoxContainer.new()
	row.alignment = BoxContainer.ALIGNMENT_CENTER
	row.name = "row_%d" % idx
	var off: int = 0 if boss else int(OFFSETS[pos % OFFSETS.size()])
	if off > 0:
		row.add_child(_gap(off * 2))
	var col := VBoxContainer.new()
	col.alignment = BoxContainer.ALIGNMENT_CENTER
	col.add_theme_constant_override("separation", 0)
	var b := Button.new()
	b.name = "stage_%d" % idx
	b.custom_minimum_size = Vector2(size, size)
	var bg := UI.LOCKED
	if cleared:
		bg = UI.GREEN
	if is_current:
		bg = UI.ORANGE
	elif boss and unlocked:
		bg = UI.GOLD
	var sb := UI.style(bg, UI.BORDER, int(size / 2), 4 if (is_current or boss) else 3)
	b.add_theme_stylebox_override("normal", sb)
	b.add_theme_stylebox_override("hover", sb)
	b.add_theme_stylebox_override("pressed", sb)
	b.add_theme_stylebox_override("disabled", sb)
	b.add_theme_font_size_override("font_size", 26 if boss else 22)
	b.add_theme_color_override("font_color", UI.INK)
	b.add_theme_color_override("font_disabled_color", UI.LOCKED_INK)
	if not unlocked:
		b.text = "🔒"
		b.disabled = true
	else:
		b.text = "B" if boss else str(idx)
		b.pressed.connect(open_stage.bind(selected_era, idx))
	col.add_child(b)
	stage_buttons[idx] = b
	var info := UI.label(MetaUI.stars_text(Progress.stage_stars(_profile, selected_era, idx)) if cleared else
			(Game.t("map.current") if is_current else ""), 14, UI.INK, HORIZONTAL_ALIGNMENT_CENTER)
	col.add_child(info)
	if boss:
		col.add_child(UI.label(Game.t("glossary.boss"), 14, UI.RED, HORIZONTAL_ALIGNMENT_CENTER))
	var rw: Dictionary = DataDB.stage(selected_era, idx).get("rewards", {})
	if bool(rw.get("echo", idx == 5)):
		var echo := UI.label("♥ " + Game.t("hero.wormina"), 14, UI.RED, HORIZONTAL_ALIGNMENT_CENTER)
		echo.name = "echo_marker"
		col.add_child(echo)
	row.add_child(col)
	if off < 0:
		row.add_child(_gap(-off * 2))
	return row


func _gap(w: int) -> Control:
	var c := Control.new()
	c.custom_minimum_size = Vector2(w, 0)
	c.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return c


func _scroll_to_current(next: Dictionary) -> void:
	if not is_inside_tree():
		return
	await get_tree().process_frame
	if not is_instance_valid(_scroll) or not is_inside_tree():
		return
	var idx := int(next["stage"]) if int(next["era"]) == selected_era else 1
	var b: Button = stage_buttons.get(idx)
	if b != null and is_instance_valid(b):
		_scroll.scroll_vertical = maxi(int(b.global_position.y - _scroll.global_position.y + _scroll.scroll_vertical - _scroll.size.y * 0.5), 0)


func open_stage(era: int, stage: int) -> void:
	if Progress.is_stage_unlocked(_profile, era, stage):
		Game.nav.go("prebattle", {"era": era, "stage": stage})
