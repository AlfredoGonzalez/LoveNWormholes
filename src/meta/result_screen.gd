class_name ResultScreen
extends Screen
## Victory / Defeat (mockups Victory, Defeat). On entry it settles the battle with Economy.settle_battle
## EXACTLY ONCE: the result is cached in the `params` dictionary under "_settled", so re-creating the screen
## with the same params, or pressing any button, never pays again. The battle screen builds a fresh params
## dictionary for every battle end, so a resumed (Second Wind) battle settles on its own.

var won := false
var era := 1
var stage := 1
var stars := 0
var settled: Dictionary = {}
var squad: Array = []
var powers: Array = []
var home_button: Button
var next_button: Button
var retry_button: Button
var change_squad_button: Button
var double_button: Button
var wind_button: Button
var shop_button: Button
var coins_shown := 0
var _coins_label: Label
var _doubled := false
var _double_extra := 0
var _chips: HBoxContainer
var stats_row: Control


func _ready() -> void:
	won = str(params.get("result", "lose")) == "win"
	era = int(params.get("era", 1))
	stage = int(params.get("stage", 1))
	squad = (params.get("squad", []) as Array).duplicate() if not (params.get("squad", []) as Array).is_empty() else MetaUI.default_squad()
	powers = (params.get("powers", []) as Array).duplicate() if not (params.get("powers", []) as Array).is_empty() else MetaUI.default_powers()
	if won:
		stars = Progress.stars_for_win(float(params.get("base_hp_fraction", 1.0)))
	_settle_once()
	_doubled = bool(params.get("_doubled", false))
	coins_shown = int(settled.get("coins", 0)) + int(params.get("_double_extra", 0))

	var v := MetaUI.scaffold(self, 18)
	v.add_theme_constant_override("separation", 12)
	_chips = MetaUI.currency_bar()
	v.add_child(_chips)
	var scroll := ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	v.add_child(scroll)
	var body := VBoxContainer.new()
	body.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	body.add_theme_constant_override("separation", 12)
	scroll.add_child(body)
	if won:
		_build_victory(body)
	else:
		_build_defeat(body)
	v.add_child(_build_buttons())
	if Game.ads != null:
		Game.ads.reward_granted.connect(_on_reward)
		Game.ads.availability_changed.connect(_on_availability)
	Game.economy.currency_changed.connect(_on_currency_changed)


## Chips follow the wallet live (Double Coins, a reverted loss...).
func _on_currency_changed(_c: String, _v: int, _d: int) -> void:
	if _chips == null or not is_instance_valid(_chips) or _chips.get_parent() == null:
		return
	var parent := _chips.get_parent()
	var idx := _chips.get_index()
	var fresh := MetaUI.currency_bar()
	parent.add_child(fresh)
	parent.move_child(fresh, idx)
	parent.remove_child(_chips)
	_chips.queue_free()
	_chips = fresh


func _stats_row() -> Control:
	var st: Dictionary = params.get("stats", {}) if params.get("stats", {}) is Dictionary else {}
	var row := HFlowContainer.new()
	row.name = "stats_row"
	row.alignment = FlowContainer.ALIGNMENT_CENTER
	row.add_theme_constant_override("h_separation", 14)
	row.add_theme_constant_override("v_separation", 2)
	var items := [
		["stat_kills", int(st.get("kills", 0))],
		["stat_spawned", int(st.get("units_spawned", 0))],
		["stat_powers", int(st.get("powers_used", 0))],
	]
	for it in items:
		var l := UI.label(Game.t("result." + str(it[0]), [it[1]]), 16, UI.LOCKED_INK, HORIZONTAL_ALIGNMENT_CENTER)
		l.autowrap_mode = TextServer.AUTOWRAP_OFF
		row.add_child(l)
	var tl := UI.label(Game.t("result.time", [MetaUI.format_time(float(params.get("time", 0.0)))]), 16, UI.LOCKED_INK, HORIZONTAL_ALIGNMENT_CENTER)
	tl.autowrap_mode = TextServer.AUTOWRAP_OFF
	row.add_child(tl)
	return row


func _exit_tree() -> void:
	if Game.ads != null:
		if Game.ads.reward_granted.is_connected(_on_reward):
			Game.ads.reward_granted.disconnect(_on_reward)
		if Game.ads.availability_changed.is_connected(_on_availability):
			Game.ads.availability_changed.disconnect(_on_availability)
	if Game.economy != null and Game.economy.currency_changed.is_connected(_on_currency_changed):
		Game.economy.currency_changed.disconnect(_on_currency_changed)


func _settle_once() -> void:
	if params.has("_settled"):
		settled = params["_settled"]
		return
	settled = Game.economy.settle_battle(era, stage, won, stars if won else 0, 1)
	params["_settled"] = settled
	Game.quests.record_battle_stats(params.get("stats", {}))   # daily quests + profile.stats (once per battle)


# ------------------------------------------------------------------ layouts

func _banner(text: String, color: Color) -> Control:
	var p := UI.panel(color)
	p.name = "banner"
	var l := UI.label(text, 44, UI.INK, HORIZONTAL_ALIGNMENT_CENTER)
	l.name = "banner_text"
	p.add_child(l)
	return p


func _build_victory(body: VBoxContainer) -> void:
	body.add_child(_banner(Game.t("victory.title"), UI.GOLD))
	var st := UI.label(MetaUI.stars_text(stars), 48, UI.GOLD, HORIZONTAL_ALIGNMENT_CENTER)
	st.name = "stars"
	body.add_child(st)
	stats_row = _stats_row()
	body.add_child(stats_row)
	var rp := UI.panel()
	rp.name = "rewards_panel"
	var rb := VBoxContainer.new()
	rb.add_theme_constant_override("separation", 6)
	rp.add_child(rb)
	rb.add_child(UI.label(Game.t("victory.rewards"), 20, UI.TEAL))
	_coins_label = UI.label("", 26, UI.INK)
	_coins_label.name = "coins_label"
	var coin_art := SpriteFactory.icon("icon_coin", 32.0)
	if coin_art != null:
		var crow := HBoxContainer.new()
		crow.add_theme_constant_override("separation", 6)
		crow.add_child(coin_art)
		_coins_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		crow.add_child(_coins_label)
		rb.add_child(crow)
	else:
		rb.add_child(_coins_label)
	_update_coins_label()
	if int(settled.get("gems", 0)) > 0:
		rb.add_child(UI.label(Game.t("result.gems", [settled["gems"]]), 24, UI.BLUE))
	if int(settled.get("capsules", 0)) > 0:
		rb.add_child(UI.label(Game.t("result.capsules", [settled["capsules"]]), 22, UI.TEAL))
	if bool(settled.get("boss_first_clear", false)):
		var n := UI.label(Game.t("victory.boss_first_clear", [settled["gems"], settled["capsules"]]), 16, UI.RED)
		n.name = "first_clear_note"
		rb.add_child(n)
	elif bool(settled.get("first_clear", false)):
		var n2 := UI.label(Game.t("victory.first_clear", [DataDB.bal_i("rewards.first_clear_coin_mult", 2), settled["gems"]]), 16, UI.RED)
		n2.name = "first_clear_note"
		rb.add_child(n2)
	body.add_child(rp)
	double_button = MetaUI.ad_button("double_coins", Game.t("victory.double_coins", [_double_amount()]))
	double_button.pressed.connect(_on_double_pressed)
	_refresh_double()
	body.add_child(double_button)


func _double_mult() -> int:
	return maxi(DataDB.bal_i("ads.double_coins_mult", 2), 1)


func _double_amount() -> int:
	return int(settled.get("coins", 0)) * (_double_mult() - 1)


func _update_coins_label() -> void:
	if _coins_label != null:
		_coins_label.text = Game.t("result.coins", [coins_shown])


func _refresh_double() -> void:
	if double_button == null:
		return
	MetaUI.refresh_ad_button(double_button, "double_coins", Game.t("victory.double_coins", [_double_amount()]),
			Game.t("result.doubled") if _doubled else "")


func _build_defeat(body: VBoxContainer) -> void:
	body.add_child(_banner(Game.t("defeat.title"), UI.LOCKED))
	var flavor := UI.label(Game.t("defeat.flavor"), 20, UI.INK, HORIZONTAL_ALIGNMENT_CENTER)
	flavor.name = "flavor"
	body.add_child(flavor)
	stats_row = _stats_row()
	body.add_child(stats_row)
	var rp := UI.panel()
	rp.name = "rewards_panel"
	var rb := VBoxContainer.new()
	rb.add_theme_constant_override("separation", 6)
	rp.add_child(rb)
	_coins_label = UI.label("", 26, UI.INK)
	_coins_label.name = "coins_label"
	var coin_art := SpriteFactory.icon("icon_coin", 32.0)
	if coin_art != null:
		var crow := HBoxContainer.new()
		crow.add_theme_constant_override("separation", 6)
		crow.add_child(coin_art)
		_coins_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		crow.add_child(_coins_label)
		rb.add_child(crow)
	else:
		rb.add_child(_coins_label)
	_update_coins_label()
	rb.add_child(UI.label(Game.t("defeat.mercy", [MetaUI.percent(DataDB.bal_f("rewards.loss_fraction", 0.4))]), 16, UI.LOCKED_INK))
	body.add_child(rp)
	var ud := Game.economy.underdog(era, stage)
	var up := UI.panel(UI.PANEL)
	up.name = "underdog_panel"
	var ub := VBoxContainer.new()
	up.add_child(ub)
	if int(ud["stacks"]) > 0:
		ub.add_child(UI.label(Game.t("defeat.underdog", [ud["stacks"]]), 22, UI.ORANGE))
		ub.add_child(UI.label(Game.t("defeat.underdog_desc", [MetaUI.percent(float(ud["food_pct"])), MetaUI.percent(float(ud["base_hp_pct"]))]), 16))
	else:
		ub.add_child(UI.label(Game.t("result.underdog_none"), 16, UI.LOCKED_INK))
	body.add_child(up)
	var wind := DataDB.bal_f("ads.second_wind_base_hp_fraction", 0.25)
	wind_button = MetaUI.ad_button("second_wind", Game.t("result.second_wind_btn", [MetaUI.percent(wind)]))
	wind_button.pressed.connect(_on_wind_pressed)
	_refresh_wind()
	body.add_child(wind_button)


func _refresh_wind() -> void:
	if wind_button == null:
		return
	var wind := DataDB.bal_f("ads.second_wind_base_hp_fraction", 0.25)
	var used := _wind_spent()
	MetaUI.refresh_ad_button(wind_button, "second_wind", Game.t("result.second_wind_btn", [MetaUI.percent(wind)]),
			Game.t("ui.not_available") if used else "")


func _build_buttons() -> Control:
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 8)
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 8)
	box.add_child(row)
	home_button = UI.button(Game.t("victory.home"), "ghost", Vector2(0, 60), 20)
	home_button.name = "home_button"
	home_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	home_button.pressed.connect(func(): Game.nav.go("home"))
	if won:
		row.add_child(home_button)
		var nxt := Progress.next_stage(Game.save.profile)
		var has_next: bool = not (int(nxt["era"]) == era and int(nxt["stage"]) == stage)
		if has_next:
			next_button = UI.button(Game.t("victory.next"), "primary", Vector2(0, 60), 20)
			next_button.name = "next_button"
			next_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			next_button.pressed.connect(func(): Game.nav.go("prebattle", {"era": int(nxt["era"]), "stage": int(nxt["stage"])}))
			row.add_child(next_button)
	else:
		change_squad_button = UI.button(Game.t("defeat.change_squad"), "ghost", Vector2(0, 60), 18)
		change_squad_button.name = "change_squad_button"
		change_squad_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		change_squad_button.pressed.connect(func(): Game.nav.go("prebattle", {"era": era, "stage": stage}))
		row.add_child(change_squad_button)
		retry_button = UI.button(Game.t("defeat.retry"), "primary", Vector2(0, 60), 20)
		retry_button.name = "retry_button"
		retry_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		retry_button.pressed.connect(func(): Game.nav.go("battle", battle_params(false)))
		row.add_child(retry_button)
		box.add_child(home_button)
	if Progress.feature_unlocked(Game.save.profile, "shop") and Game.nav.can_go("shop"):
		shop_button = UI.button(Game.t("nav.shop"), "ghost", Vector2(0, UI.MIN_TOUCH), 18)
		shop_button.name = "shop_button"
		shop_button.pressed.connect(func(): Game.nav.go("shop", {"from": "result"}))
		box.add_child(shop_button)
	return box


func battle_params(resume: bool) -> Dictionary:
	var p := {"era": era, "stage": stage, "squad": squad.duplicate(), "powers": powers.duplicate(), "food_boost": false}
	if resume:
		p["resume"] = true
	return p


# ------------------------------------------------------------------ ads

func _on_double_pressed() -> void:
	if _doubled:
		return
	Game.claim_bonus("double_coins", {"coins": _double_amount(), "multiplier": _double_mult()})


## Second Wind is once per battle: also spent when this result comes from an already resumed battle.
func _wind_spent() -> bool:
	return bool(params.get("_wind_used", false)) or bool(params.get("second_wind_used", false))


func _on_wind_pressed() -> void:
	if _wind_spent():
		return
	Game.claim_bonus("second_wind", {"base_hp_fraction": DataDB.bal_f("ads.second_wind_base_hp_fraction", 0.25)})


func _on_reward(placement: String, reward: Dictionary) -> void:
	if placement == "double_coins" and won and not _doubled:
		_doubled = true
		params["_doubled"] = true
		var extra := mini(int(reward.get("coins", _double_amount())), _double_amount())
		params["_double_extra"] = extra
		Game.economy.add("coins", extra)
		coins_shown += extra
		_update_coins_label()
		_refresh_double()
	elif placement == "second_wind" and not won and not _wind_spent():
		params["_wind_used"] = true
		# The battle goes on, so the final result (not this defeat) is the one that pays: take the mercy
		# reward back, once. params outlives the screen, so re-entering cannot revert twice.
		if not bool(params.get("_reverted", false)):
			params["_reverted"] = true
			Game.economy.revert_loss(era, stage, settled)
		Game.nav.go("battle", battle_params(true))


func _on_availability(placement: String) -> void:
	if placement == "double_coins":
		_refresh_double()
	elif placement == "second_wind":
		_refresh_wind()
