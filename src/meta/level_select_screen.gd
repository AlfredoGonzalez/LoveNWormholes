class_name LevelSelectScreen
extends Screen
## World map (mockup WorldMap): currency chips, era tabs, zigzag stage path with stars, Play, bottom bar.

const OFFSETS := [-90, 0, 90, 0]
const NODE_SIZE := 68.0
const BOSS_SIZE := 92.0
const BAR_FEATURES := ["upgrades", "squad", "shop", "capsules"]

var selected_era := 1
var play_button: Button
var stage_buttons := {}       # stage index -> Button (selected era)
var bar_buttons := {}         # "upgrades" / "squad" / "shop" / "capsules" / "settings" -> Button
var bar_notes := {}           # feature -> Label (unlock note / coming soon)
var era_buttons := {}         # era -> Button
var _scroll: ScrollContainer
var _path_box: VBoxContainer
var _profile: Dictionary


func _ready() -> void:
	_profile = Game.save.profile
	var next := Progress.next_stage(_profile)
	selected_era = int(next["era"])
	var v := MetaUI.scaffold(self, 12)

	var top := HBoxContainer.new()
	top.add_theme_constant_override("separation", 8)
	top.add_child(MetaUI.currency_bar())
	var title := UI.label(Game.t("map.title"), 20, UI.INK, HORIZONTAL_ALIGNMENT_RIGHT)
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	top.add_child(title)
	v.add_child(top)

	var tabs := HBoxContainer.new()
	tabs.add_theme_constant_override("separation", 6)
	for era in range(1, DataDB.bal_i("campaign.eras", 5) + 1):
		var b := UI.button(Game.t("map.era_tab", [era]), "ghost", Vector2(0, UI.MIN_TOUCH), 16)
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

	play_button = UI.button("", "primary", Vector2(0, 64), 26)
	play_button.name = "play_button"
	play_button.pressed.connect(_on_play)
	v.add_child(play_button)
	v.add_child(_build_bottom_bar())
	select_era(selected_era)


func select_era(era: int) -> void:
	selected_era = era
	for e in era_buttons:
		var locked := not Progress.is_era_unlocked(_profile, e)
		var b: Button = era_buttons[e]
		b.text = Game.t("map.era_tab", [e])
		b.add_theme_stylebox_override("normal", UI.style(UI.ORANGE if e == era else (UI.LOCKED if locked else UI.PANEL)))
	_rebuild_path()
	_refresh_play()


func _rebuild_path() -> void:
	for c in _path_box.get_children():
		_path_box.remove_child(c)
		c.queue_free()
	stage_buttons.clear()
	_path_box.add_child(UI.label(Game.t("era.%d.name" % selected_era), 20, UI.TEAL, HORIZONTAL_ALIGNMENT_CENTER))
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
	if idx == 5:
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


func _refresh_play() -> void:
	var next := Progress.next_stage(_profile)
	play_button.text = Game.t("map.play_stage", [next["era"], next["stage"]])


func open_stage(era: int, stage: int) -> void:
	if Progress.is_stage_unlocked(_profile, era, stage):
		Game.nav.go("prebattle", {"era": era, "stage": stage})


func _on_play() -> void:
	var next := Progress.next_stage(_profile)
	open_stage(int(next["era"]), int(next["stage"]))


func _build_bottom_bar() -> Control:
	var h := HBoxContainer.new()
	h.add_theme_constant_override("separation", 6)
	var entries := BAR_FEATURES.duplicate()
	entries.append("settings")
	for f in entries:
		var col := VBoxContainer.new()
		col.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		col.add_theme_constant_override("separation", 2)
		var label_key: String = "title.settings" if f == "settings" else "nav." + f
		var b := UI.button(Game.t(label_key), "ghost", Vector2(0, 56), 14)
		b.name = "bar_" + f
		b.clip_text = true
		col.add_child(b)
		bar_buttons[f] = b
		var note: Control = null
		if f == "settings":
			b.pressed.connect(func(): Game.nav.go("settings"))
		elif not Progress.feature_unlocked(_profile, f):
			b.disabled = true
			note = UI.locked_note(Progress.feature_unlock_stage(f))
		elif f == "upgrades" or Game.nav.can_go(f):
			b.pressed.connect(func(): Game.nav.go(f))
		else:
			b.disabled = true
			note = UI.label(Game.t("meta.coming_soon"), 14, UI.LOCKED_INK, HORIZONTAL_ALIGNMENT_CENTER)
		var nl: Label = note if note is Label else UI.label("", 14)
		nl.name = "note_" + f
		nl.add_theme_font_size_override("font_size", 12)
		nl.custom_minimum_size = Vector2(0, 30)
		col.add_child(nl)
		bar_notes[f] = nl
		h.add_child(col)
	return h
