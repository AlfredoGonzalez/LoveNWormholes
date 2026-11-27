class_name BattleHud
extends Control
## Top HUD (base HP bars, Food bar, speed and pause buttons) and the bottom 30%: one card per squad unit
## and the power buttons in the lower corners. Reads the sim, never changes it; button presses are
## reported through signals and the screen decides what to do.

signal card_pressed(index: int)
signal power_pressed(index: int)
signal pause_pressed
signal speed_pressed
signal recenter_pressed
signal radar_seek(world_x: float)   ## radar tapped / dragged: the world x to centre the camera on

const W := 540.0
const CARD_Y := 690.0
const CARD_H := 116.0
const POWER_SIZE := 96.0

var player_bar: ProgressBar
var enemy_bar: ProgressBar
var food_bar: ProgressBar
var player_text: Label
var enemy_text: Label
var food_text: Label
var income_text: Label
var speed_button: Button
var radar: BattleRadar
var recenter_button: RecenterButton
var pause_button: Button
var toast_label: Label
var underdog_label: Label
var boss_bar: ProgressBar
var boss_text: Label
var _toast_big := false
var cards: Array[CardButton] = []
var power_buttons: Array[CardButton] = []
var _toast_t := 0.0
var _enemy_name := ""
var _ids: Array = []


func _init() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	name = "BattleHud"


func _bar(parent: Control, rect: Rect2, fill: Color) -> ProgressBar:
	var b := ProgressBar.new()
	b.show_percentage = false
	b.min_value = 0.0
	b.max_value = 1.0
	b.step = 0.0
	b.value = 1.0
	b.position = rect.position
	b.size = rect.size
	b.custom_minimum_size = rect.size
	b.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var bg := UI.style(Color(0, 0, 0, 0.35), UI.BORDER, 10, 2, false)
	bg.content_margin_top = 0
	bg.content_margin_bottom = 0
	var fg := UI.style(fill, Color(fill.darkened(0.4), 0.0), 10, 0, false)
	b.add_theme_stylebox_override("background", bg)
	b.add_theme_stylebox_override("fill", fg)
	parent.add_child(b)
	return b


func _bar_text(bar: ProgressBar, size_px := 15) -> Label:
	var l := UI.label("", size_px, Color.WHITE, HORIZONTAL_ALIGNMENT_CENTER)
	l.set_anchors_preset(Control.PRESET_FULL_RECT)
	l.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	l.autowrap_mode = TextServer.AUTOWRAP_OFF
	l.clip_text = true
	l.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.9))
	l.add_theme_constant_override("outline_size", 4)
	l.mouse_filter = Control.MOUSE_FILTER_IGNORE
	bar.add_child(l)
	return l


func build(sim: BattleSim, squad: Array, powers: Array, era: int) -> void:
	_ids = squad
	_enemy_name = Game.t("era.%d.enemy_base" % era)
	# Row 1: pause, Food bar, speed.
	pause_button = UI.button("II", "ghost", Vector2(52, 52), 22)
	pause_button.position = Vector2(10, 10)
	pause_button.size = Vector2(52, 52)
	pause_button.focus_mode = Control.FOCUS_NONE
	pause_button.pressed.connect(func(): pause_pressed.emit())
	add_child(pause_button)
	food_bar = _bar(self, Rect2(72, 14, 306, 36), UI.ORANGE)
	food_text = _bar_text(food_bar, 20)
	var food_icon := SpriteFactory.icon("icon_food", 40.0)
	if food_icon != null:   # icon sits on the left end of the Food bar; the text keeps its centre
		food_icon.name = "FoodIcon"
		food_icon.position = Vector2(-2, -2)
		food_bar.add_child(food_icon)
	income_text = UI.label("", 15, UI.INK, HORIZONTAL_ALIGNMENT_LEFT)
	income_text.position = Vector2(384, 20)
	income_text.size = Vector2(76, 26)
	income_text.autowrap_mode = TextServer.AUTOWRAP_OFF
	income_text.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(income_text)
	speed_button = UI.button("x1", "teal", Vector2(64, 52), 22)
	speed_button.position = Vector2(466, 10)
	speed_button.size = Vector2(64, 52)
	speed_button.focus_mode = Control.FOCUS_NONE
	speed_button.pressed.connect(func(): speed_pressed.emit())
	add_child(speed_button)
	# Row 2: base HP bars.
	player_bar = _bar(self, Rect2(10, 70, 255, 24), UI.BLUE)
	player_text = _bar_text(player_bar)
	enemy_bar = _bar(self, Rect2(275, 70, 255, 24), UI.RED)
	enemy_text = _bar_text(enemy_bar)
	underdog_label = UI.label("", 14, UI.INK, HORIZONTAL_ALIGNMENT_CENTER)
	underdog_label.position = Vector2(10, 128)
	underdog_label.size = Vector2(250, 22)
	underdog_label.autowrap_mode = TextServer.AUTOWRAP_OFF
	underdog_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(underdog_label)
	# Lane radar (camera window + units) right under the base bars; tap / drag it to move the camera.
	radar = BattleRadar.new()
	radar.position = Vector2(10, 98)
	radar.size = Vector2(W - 20.0, 24)
	radar.seek.connect(func(wx: float): radar_seek.emit(wx))
	add_child(radar)
	# Boss HP bar (hidden unless a boss is on the field), under the radar.
	boss_bar = _bar(self, Rect2(275, 126, 255, 22), UI.ORANGE)
	boss_text = _bar_text(boss_bar, 13)
	boss_bar.visible = false
	# Toast line under the bars.
	toast_label = UI.label("", 22, Color.WHITE, HORIZONTAL_ALIGNMENT_CENTER)
	toast_label.position = Vector2(20, 158)
	toast_label.size = Vector2(500, 60)
	toast_label.add_theme_color_override("font_outline_color", Color(0.2, 0.05, 0.0, 0.95))
	toast_label.add_theme_constant_override("outline_size", 7)
	toast_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	toast_label.visible = false
	add_child(toast_label)
	recenter_button = RecenterButton.new()   # over the ground strip between the lane and the cards
	recenter_button.position = Vector2(W - 58.0, 628.0)
	recenter_button.size = Vector2(48, 48)
	recenter_button.pressed.connect(func(): recenter_pressed.emit())
	add_child(recenter_button)
	_build_cards(sim)
	_build_powers(sim, powers)


func _build_cards(sim: BattleSim) -> void:
	var n := sim.cards.size()
	if n == 0:
		return
	var gap := 8.0
	var margin := 12.0
	var cw := minf(112.0, (W - 2.0 * margin - gap * float(n - 1)) / float(n))
	var total := cw * float(n) + gap * float(n - 1)
	var x0 := (W - total) / 2.0
	for i in n:
		var st: Dictionary = sim.cards[i]["stats"]
		var id := str(st["id"])
		var c := CardButton.new(Game.t("unit.%s.name" % id), str(int(st["cost"])), UI.BLUE, Vector2(cw, CARD_H))
		c.position = Vector2(x0 + float(i) * (cw + gap), CARD_Y)
		c.size = Vector2(cw, CARD_H)
		c.name = "Card%d" % i
		c.fit_title()
		c.set_art(SpriteFactory.portrait_trimmed(id), "portrait")
		c.activated.connect(func(): card_pressed.emit(i))
		add_child(c)
		cards.append(c)


func _build_powers(sim: BattleSim, powers: Array) -> void:
	var n := sim.powers.size()
	for i in n:
		var pid := str(sim.powers[i]["id"])
		var b := CardButton.new(Game.t("power.%s.name" % pid), Game.t("battle.power_ready"), UI.TEAL, Vector2(POWER_SIZE, POWER_SIZE))
		var x := 12.0
		match i:
			0: x = 12.0
			1: x = W - POWER_SIZE - 12.0
			_: x = (W - POWER_SIZE) / 2.0
		b.set_art(SpriteFactory.texture_of("power_" + pid), "icon")
		b.position = Vector2(x, 960.0 - POWER_SIZE - 14.0)
		b.size = Vector2(POWER_SIZE, POWER_SIZE)
		b.name = "Power%d" % i
		b.activated.connect(func(): power_pressed.emit(i))
		add_child(b)
		power_buttons.append(b)


func set_underdog(stacks: int) -> void:
	underdog_label.text = Game.t("battle.underdog_badge", [stacks]) if stacks > 0 else ""


## `alarm` = boss warning: bigger, red banner so it reads at a glance.
func toast(text: String, seconds := 1.4, alarm := false) -> void:
	toast_label.text = text
	toast_label.visible = true
	_toast_t = seconds
	toast_label.add_theme_font_size_override("font_size", 28 if alarm else 22)
	toast_label.add_theme_color_override("font_color", Color(1.0, 0.9, 0.2) if alarm else Color.WHITE)
	toast_label.add_theme_color_override("font_outline_color", Color(0.55, 0.05, 0.0, 1.0) if alarm else Color(0.2, 0.05, 0.0, 0.95))


func tick_toast(dt: float) -> void:
	if _toast_t > 0.0:
		_toast_t -= dt
		if _toast_t <= 0.0:
			toast_label.visible = false


func _refresh_boss(sim: BattleSim) -> void:
	var boss: SimUnit = null
	for u in sim.units:
		if u.is_boss and u.alive() and u.side == BattleSim.ENEMY:
			boss = u
			break
	boss_bar.visible = boss != null
	if boss == null:
		return
	boss_bar.value = clampf(boss.hp / maxf(1.0, boss.max_hp), 0.0, 1.0)
	var key := "boss.%s.name" % boss.id
	var nm := Game.t(key) if Localization.has_key(key) else boss.id
	boss_text.text = "%s  %d%%" % [nm, int(ceil(boss_bar.value * 100.0))]


func refresh(sim: BattleSim, speed: int) -> void:
	_refresh_boss(sim)
	player_bar.value = clampf(sim.player_base_hp / maxf(1.0, sim.player_base_max), 0.0, 1.0)
	enemy_bar.value = clampf(sim.enemy_base_hp / maxf(1.0, sim.enemy_base_max), 0.0, 1.0)
	player_text.text = Game.t("battle.base_player", [int(ceil(sim.player_base_hp)), int(sim.player_base_max)])
	enemy_text.text = Game.t("battle.base_enemy", [_enemy_name, int(ceil(sim.enemy_base_hp)), int(sim.enemy_base_max)])
	food_bar.value = clampf(sim.food / maxf(1.0, sim.food_cap), 0.0, 1.0)
	food_text.text = Game.t("battle.food", [int(sim.food), int(sim.food_cap)])
	income_text.text = Game.t("battle.income", [snappedf(sim.food_income, 0.1)])
	speed_button.text = Game.t("battle.speed", [speed])
	for i in cards.size():
		var c: Dictionary = sim.cards[i]
		var st: Dictionary = c["stats"]
		var cd := float(c["cd"])
		var total := maxf(0.001, float(st["spawn_cooldown"]))
		var state := "ready"
		if cd > 0.0001:
			state = "wait"
		elif sim.food < float(st["cost"]):
			state = "poor"
		elif not sim.card_ready(i):
			state = "off"   # population cap
		cards[i].refresh(state, str(int(st["cost"])), clampf(cd / total, 0.0, 1.0),
				Game.t("battle.cooldown", [snappedf(cd, 0.1)]) if cd > 0.0001 else "")
	for i in power_buttons.size():
		var p: Dictionary = sim.powers[i]
		var cd2 := float(p["cd"])
		var total2 := maxf(0.001, float(p["cooldown"]))
		var stolen := float(p["stolen_t"]) > 0.0
		var state2 := "ready"
		if stolen:
			state2 = "off"
		elif cd2 > 0.0001:
			state2 = "wait"
		power_buttons[i].refresh(state2, Game.t("battle.power_ready") if state2 == "ready" else "",
				clampf(cd2 / total2, 0.0, 1.0), Game.t("battle.cooldown", [int(ceil(cd2))]) if cd2 > 0.0001 else "")
