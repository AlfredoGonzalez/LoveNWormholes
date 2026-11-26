class_name HomeScreen
extends Screen
## Home hub (mockup Home / HomeOffline): currency chips, Shards chip, Squirmy on the burrow, next-stage panel
## with the enemy role mix and Play, settings, daily-reward button (badge) and the bottom navigation.
## Popups (children of this screen): the offline Worm Farm claim (once per app session, only when coins are pending)
## and the Daily overlay (login reward, 3 quests, optional Bonus Capsule ad).
## Ad rewards are applied by Game's global listener (Quests.apply_reward); this screen only reacts to the
## resulting Economy / Quests signals. params.now (optional) overrides the clock, for tests.

const NAV := ["squad", "upgrades", "capsules", "shop", "map"]
const NAV_ROUTES := {"squad": "squad", "upgrades": "upgrades", "capsules": "capsules", "shop": "shop", "map": "levels"}
const SKY := Color("CFE9F2")
const GROUND := Color("8FBF6A")

var play_button: Button
var settings_button: Button
var daily_button: Button
var daily_badge: Label
var nav_buttons := {}          # nav id -> Button
var nav_notes := {}            # nav id -> Label (unlock note / coming soon)
var nav_dots := {}             # nav id -> Control (alert dot)
var shards_chip: Control
var offline_popup: Control
var offline_claim_button: Button
var offline_double_button: Button
var daily_overlay: Control
var login_claim_button: Button
var quest_claim_buttons := {}  # quest id -> Button
var bonus_button: Button
var next_stage := {}
var stage_line: Label
var era_line: Label
var role_chips: Array = []
var _profile: Dictionary
var _bar_slot: HBoxContainer
var _bar: Control
var _daily_body: VBoxContainer
var _offline_pending := 0


func _now() -> float:
	return float(params.get("now", Time.get_unix_time_from_system()))


func _ready() -> void:
	_profile = Game.save.profile
	if Story.ending_pending(_profile):   # game_completed and the ending comic not seen yet: play it, then back here
		var r := Story.route(_profile, "ending", "home")
		Game.nav.go.call_deferred(r[0], r[1])
		return
	next_stage = Progress.next_stage(_profile)
	_build()
	_connect_signals()
	# Offline Worm Farm: shown once per Home visit, only when something is pending.
	_offline_pending = Game.economy.offline_pending(_now(), Game.shop.offline_extra_hours())
	if _offline_pending > 0 and not Game.offline_popup_shown:
		Game.offline_popup_shown = true
		_show_offline()
	Game.mark_seen(_now())   # last_seen, and the farm timer starts on the very first visit


func _exit_tree() -> void:
	if Game.economy != null:
		for pair in [[Game.economy.currency_changed, _on_currency], [Game.economy.offline_claimed, _on_offline_claimed],
				[Game.economy.daily_claimed, _on_daily_claimed]]:
			if (pair[0] as Signal).is_connected(pair[1]):
				(pair[0] as Signal).disconnect(pair[1])
	if Game.quests != null and Game.quests.changed.is_connected(_on_quests_changed):
		Game.quests.changed.disconnect(_on_quests_changed)
	if Game.ads != null and Game.ads.availability_changed.is_connected(_on_availability):
		Game.ads.availability_changed.disconnect(_on_availability)


func _connect_signals() -> void:
	Game.economy.currency_changed.connect(_on_currency)
	Game.economy.offline_claimed.connect(_on_offline_claimed)
	Game.economy.daily_claimed.connect(_on_daily_claimed)
	Game.quests.changed.connect(_on_quests_changed)
	Game.ads.availability_changed.connect(_on_availability)


# ------------------------------------------------------------------ layout

func _build() -> void:
	add_child(UI.background(SKY))
	var ground := ColorRect.new()
	ground.color = GROUND
	ground.set_anchors_preset(Control.PRESET_FULL_RECT)
	ground.anchor_top = 0.46
	ground.offset_top = 0
	ground.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(ground)
	# Burrow and Squirmy (placeholders until real art).
	var base_tex := SpriteFactory.texture_of("base_p%d" % int(next_stage.get("era", 1)))
	var burrow: Control
	if base_tex != null:   # the player's base of the current era (base_p<era>), bottom on the ground line
		var bw := 230.0
		var bh := bw * float(base_tex.get_height()) / maxf(1.0, float(base_tex.get_width()))
		burrow = SpriteFactory.rect_of(base_tex, Vector2(bw, bh), SpriteFactory.facing_of("base_p%d" % int(next_stage.get("era", 1))) == "left")
		burrow.position = Vector2(10, 500.0 - bh)
	else:
		burrow = UI.placeholder(Game.t("hero.player_base"), Color("B07A4A"), Vector2(210, 170))
		burrow.position = Vector2(20, 330)
	burrow.name = "burrow"
	burrow.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(burrow)
	var squirmy := SpriteFactory.make_animated("squirmy")
	squirmy.name = "squirmy"
	squirmy.position = Vector2(390, 470)
	squirmy.scale = Vector2(0.5, 0.5)
	add_child(squirmy)
	if squirmy.has_method("play_row"):
		squirmy.play_row("idle")

	var m := MarginContainer.new()
	m.set_anchors_preset(Control.PRESET_FULL_RECT)
	for side in ["left", "right", "top", "bottom"]:
		m.add_theme_constant_override("margin_" + side, 12)
	m.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(m)
	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", 8)
	v.mouse_filter = Control.MOUSE_FILTER_IGNORE
	m.add_child(v)

	var top := HBoxContainer.new()
	top.add_theme_constant_override("separation", 8)
	_bar_slot = HBoxContainer.new()
	_bar_slot.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	top.add_child(_bar_slot)
	_refresh_bar()
	settings_button = UI.button("⚙", "ghost", Vector2(52, 52), 24)
	settings_button.name = "settings_button"
	settings_button.pressed.connect(func(): Game.nav.go("settings"))
	top.add_child(settings_button)
	daily_button = UI.button("◉", "ghost", Vector2(52, 52), 24)
	daily_button.name = "daily_button"
	daily_button.tooltip_text = Game.t("home.daily_badge")
	daily_button.pressed.connect(open_daily)
	top.add_child(daily_button)
	daily_badge = UI.label("", 12, Color.WHITE, HORIZONTAL_ALIGNMENT_CENTER)
	daily_badge.name = "daily_badge"
	daily_badge.autowrap_mode = TextServer.AUTOWRAP_OFF
	daily_badge.add_theme_stylebox_override("normal", UI.style(UI.RED, UI.BORDER, 10, 2, false))
	daily_badge.set_anchors_preset(Control.PRESET_TOP_RIGHT)
	daily_badge.grow_horizontal = Control.GROW_DIRECTION_BEGIN
	daily_badge.offset_left = 4
	daily_badge.offset_right = 4
	daily_badge.offset_top = -6
	daily_badge.mouse_filter = Control.MOUSE_FILTER_IGNORE
	daily_button.add_child(daily_badge)
	v.add_child(top)

	var row2 := HBoxContainer.new()
	shards_chip = UI.chip("◇", Game.t("home.shards", [_shards(), DataDB.bal_i("campaign.eras", 5)]))
	shards_chip.name = "shards_chip"
	row2.add_child(shards_chip)
	v.add_child(row2)

	var spacer := Control.new()
	spacer.size_flags_vertical = Control.SIZE_EXPAND_FILL
	spacer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	v.add_child(spacer)

	v.add_child(_build_stage_panel())
	v.add_child(_build_nav())
	_refresh_alerts()


func _build_stage_panel() -> Control:
	var p := UI.panel()
	p.name = "stage_panel"
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 6)
	p.add_child(box)
	var era := int(next_stage["era"])
	var st := int(next_stage["stage"])
	era_line = UI.label(Game.t("home.era_line", [era, Game.t("era.%d.short" % era)]), 18, UI.TEAL)
	era_line.name = "era_line"
	box.add_child(era_line)
	stage_line = UI.label(_stage_text(era, st), 24, UI.INK)
	stage_line.name = "stage_line"
	box.add_child(stage_line)
	if Progress.is_stage_cleared(_profile, era, st):
		var done := UI.label(Game.t("home.all_cleared"), 14, UI.LOCKED_INK)
		done.name = "all_cleared_note"
		box.add_child(done)
	var chips := HFlowContainer.new()
	chips.name = "role_chips"
	chips.add_theme_constant_override("h_separation", 6)
	chips.add_theme_constant_override("v_separation", 4)
	var mix := _role_mix(DataDB.stage(era, st))
	for r in DataDB.ROLES:
		if mix.has(r):
			var c := UI.chip("", Game.t("home.scout_item", [Game.t("role." + r), mix[r]]))
			c.name = "role_" + r
			chips.add_child(c)
			role_chips.append(c)
	box.add_child(chips)
	play_button = UI.button(Game.t("home.play"), "primary", Vector2(0, 72), 32)
	play_button.name = "play_button"
	play_button.pressed.connect(_on_play)
	box.add_child(play_button)
	return p


func _stage_text(era: int, st: int) -> String:
	var n := Game.t("map.stage", [st])
	var key := "stage.%d.%d.name" % [era, st]
	var def := DataDB.stage(era, st)
	var title := ""
	if bool(def.get("rewards", {}).get("boss", false)) or DataDB.is_boss_stage(DataDB.stage_number(era, st)):
		for w in def.get("waves", []):
			if w.has("boss"):
				title = Game.t(str(DataDB.boss(str(w["boss"])).get("name_key", "")))
	elif Localization.has_key(key):
		title = Game.t(key)
	if title == "":
		return n
	return Game.t("home.stage_line", [st, title])


## Enemy role mix of a stage from its waves (bosses add their role and escorts): {role: count}.
static func _role_mix(stage_def: Dictionary) -> Dictionary:
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


func _build_nav() -> Control:
	var h := HBoxContainer.new()
	h.name = "nav"
	h.add_theme_constant_override("separation", 6)
	for f in NAV:
		var col := VBoxContainer.new()
		col.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		col.add_theme_constant_override("separation", 2)
		var b := UI.button(Game.t("nav." + f), "ghost", Vector2(0, 60), 15)
		b.name = "nav_" + f
		b.clip_text = true
		col.add_child(b)
		nav_buttons[f] = b
		var dot := Panel.new()
		dot.name = "dot_" + f
		dot.add_theme_stylebox_override("panel", UI.style(UI.RED, UI.BORDER, 8, 2, false))
		dot.custom_minimum_size = Vector2(16, 16)
		dot.set_anchors_preset(Control.PRESET_TOP_RIGHT)
		dot.offset_left = -14
		dot.offset_top = -4
		dot.offset_right = 2
		dot.offset_bottom = 12
		dot.mouse_filter = Control.MOUSE_FILTER_IGNORE
		dot.visible = false
		b.add_child(dot)
		nav_dots[f] = dot
		var note: Label
		var route: String = NAV_ROUTES[f]
		if f != "map" and not Progress.feature_unlocked(_profile, f):
			b.disabled = true
			note = UI.locked_note(Progress.feature_unlock_stage(f))
		elif f != "map" and not Game.nav.can_go(route):
			b.disabled = true
			note = UI.label(Game.t("meta.coming_soon"), 12, UI.LOCKED_INK, HORIZONTAL_ALIGNMENT_CENTER)
		else:
			b.pressed.connect(func(): Game.nav.go(route))
			note = UI.label("", 12, UI.LOCKED_INK, HORIZONTAL_ALIGNMENT_CENTER)
		note.name = "note_" + f
		note.add_theme_font_size_override("font_size", 12)
		note.custom_minimum_size = Vector2(0, 30)
		col.add_child(note)
		nav_notes[f] = note
		h.add_child(col)
	return h


# ------------------------------------------------------------------ chips, alerts

func _shards() -> int:
	var n := 0
	for era in range(1, DataDB.bal_i("campaign.eras", 5) + 1):
		if Progress.highest_in_era(_profile, era) >= DataDB.bal_i("campaign.boss_stage", 10):
			n += 1
	return n


func _refresh_bar() -> void:
	if _bar != null and is_instance_valid(_bar):
		_bar_slot.remove_child(_bar)
		_bar.queue_free()
	_bar = MetaUI.currency_bar()
	_bar_slot.add_child(_bar)


func _daily_alerts() -> int:
	var n := 1 if Game.economy.can_claim_daily(_now()) else 0
	return n + Game.quests.claimable_count(_now())


func _can_upgrade_something() -> bool:
	var e: Economy = Game.economy
	var coins := e.get_amount("coins")
	for era in range(1, DataDB.bal_i("campaign.eras", 5) + 1):
		if not Progress.is_era_unlocked(_profile, era):
			continue
		for u in DataDB.units_of_era(era):
			var cost := e.unit_upgrade_cost(e.unit_level(str(u["id"])) + 1)
			if cost >= 0 and coins >= cost:
				return true
	for cost in [e.burrow_cost(e.burrow_level() + 1), e.base_cost(e.base_level() + 1)]:
		if cost >= 0 and coins >= cost:
			return true
	return false


func _refresh_alerts() -> void:
	var n := _daily_alerts()
	daily_badge.text = str(n)
	daily_badge.visible = n > 0
	var up: Control = nav_dots["upgrades"]
	up.visible = Progress.feature_unlocked(_profile, "upgrades") and _can_upgrade_something()


func has_alert(nav_id: String) -> bool:
	return nav_dots.has(nav_id) and (nav_dots[nav_id] as Control).visible


func _on_currency(_c: String, _v: int, _d: int) -> void:
	_refresh_bar()
	_refresh_alerts()


func _on_quests_changed() -> void:
	_refresh_alerts()
	_rebuild_daily()


func _on_availability(placement: String) -> void:
	if placement == "double_farm" and offline_double_button != null and is_instance_valid(offline_double_button):
		_refresh_double_farm()
	elif placement == "bonus_capsule":
		_rebuild_daily()


# ------------------------------------------------------------------ navigation

func _on_play() -> void:
	Game.nav.go("prebattle", {"era": int(next_stage["era"]), "stage": int(next_stage["stage"])})


func _toast(text: String) -> void:
	var p := UI.panel(UI.GOLD)
	p.name = "toast"
	p.add_child(UI.label(text, 18, UI.INK, HORIZONTAL_ALIGNMENT_CENTER))
	p.set_anchors_preset(Control.PRESET_CENTER_TOP)
	p.offset_top = 120
	p.offset_left = -150
	p.offset_right = 150
	p.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(p)
	if is_inside_tree():
		get_tree().create_timer(2.5).timeout.connect(p.queue_free)


func _popup_shell(popup_name: String) -> Array:
	## Returns [overlay, content VBox] (dim background + centered panel).
	var overlay := Control.new()
	overlay.name = popup_name
	overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	var dim := ColorRect.new()
	dim.color = Color(0, 0, 0, 0.55)
	dim.set_anchors_preset(Control.PRESET_FULL_RECT)
	overlay.add_child(dim)
	var center := CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	overlay.add_child(center)
	var panel := UI.panel()
	panel.custom_minimum_size = Vector2(470, 0)
	center.add_child(panel)
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 10)
	panel.add_child(box)
	add_child(overlay)
	return [overlay, box]


# ------------------------------------------------------------------ offline Worm Farm popup

func _show_offline() -> void:
	var shell := _popup_shell("offline_popup")
	offline_popup = shell[0]
	var box: VBoxContainer = shell[1]
	var e: Economy = Game.economy
	var cap := e.offline_cap_hours(Game.shop.offline_extra_hours())
	var last := float(_profile["timestamps"].get("offline_farm", 0))
	var minutes := int(minf((_now() - last) / 60.0, cap * 60.0))
	box.add_child(UI.label(Game.t("offline.title"), 28, UI.INK, HORIZONTAL_ALIGNMENT_CENTER))
	box.add_child(UI.label(Game.t("offline.body"), 18, UI.INK, HORIZONTAL_ALIGNMENT_CENTER))
	var away := UI.label(Game.t("ui.hours_minutes", [minutes / 60, minutes % 60]), 34, UI.TEAL, HORIZONTAL_ALIGNMENT_CENTER)
	away.name = "offline_away"
	box.add_child(away)
	var coin_art := SpriteFactory.icon("icon_coin", 44.0)
	var coins := UI.label(("%d" if coin_art != null else "● %d") % _offline_pending, 40, UI.INK, HORIZONTAL_ALIGNMENT_CENTER)
	coins.name = "offline_coins"
	if coin_art != null:
		var crow := HBoxContainer.new()
		crow.alignment = BoxContainer.ALIGNMENT_CENTER
		crow.add_child(coin_art)
		crow.add_child(coins)
		box.add_child(crow)
	else:
		box.add_child(coins)
	var capl := UI.label(Game.t("offline.cap", [int(round(cap))]), 14, UI.LOCKED_INK, HORIZONTAL_ALIGNMENT_CENTER)
	capl.name = "offline_cap"
	box.add_child(capl)
	offline_claim_button = UI.button(Game.t("offline.claim", [_offline_pending]), "primary", Vector2(0, 64), 24)
	offline_claim_button.name = "offline_claim"
	offline_claim_button.pressed.connect(_on_offline_claim)
	box.add_child(offline_claim_button)
	offline_double_button = UI.button("", "teal", Vector2(0, 60), 18)
	offline_double_button.name = "offline_double"
	offline_double_button.pressed.connect(_on_offline_double)
	box.add_child(offline_double_button)
	_refresh_double_farm()


func _double_mult() -> int:
	return maxi(DataDB.bal_i("ads.double_farm_mult", 2), 1)


func _refresh_double_farm() -> void:
	MetaUI.refresh_ad_button(offline_double_button, "double_farm", Game.t("offline.double", [_offline_pending * _double_mult()]))


func _on_offline_claim() -> void:
	offline_claim_button.disabled = true   # one tap, one payment
	Game.economy.claim_offline(_now(), Game.shop.offline_extra_hours())


## The reward is granted ONLY from Game.ads.reward_granted (applied by the global listener).
func _on_offline_double() -> void:
	Game.claim_bonus("double_farm", {"coins": _offline_pending, "multiplier": _double_mult(), "extra_hours": Game.shop.offline_extra_hours()})


func _on_offline_claimed(_coins: int) -> void:
	if offline_popup != null and is_instance_valid(offline_popup):
		offline_popup.queue_free()
		offline_popup = null
		offline_claim_button = null
		offline_double_button = null
		_toast(Game.t("meta.reward_received"))
	_refresh_bar()


# ------------------------------------------------------------------ Daily overlay

func open_daily() -> void:
	if daily_overlay != null and is_instance_valid(daily_overlay):
		return
	var shell := _popup_shell("daily_overlay")
	daily_overlay = shell[0]
	var box: VBoxContainer = shell[1]
	box.add_child(UI.label(Game.t("daily.title"), 28, UI.INK, HORIZONTAL_ALIGNMENT_CENTER))
	var scroll := ScrollContainer.new()
	scroll.custom_minimum_size = Vector2(0, 520)
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	box.add_child(scroll)
	_daily_body = VBoxContainer.new()
	_daily_body.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_daily_body.add_theme_constant_override("separation", 10)
	scroll.add_child(_daily_body)
	var close := UI.button(Game.t("ui.close"), "ghost", Vector2(0, 56), 20)
	close.name = "daily_close"
	close.pressed.connect(close_daily)
	box.add_child(close)
	_rebuild_daily()


func close_daily() -> void:
	if daily_overlay != null and is_instance_valid(daily_overlay):
		daily_overlay.queue_free()
	daily_overlay = null
	_daily_body = null
	login_claim_button = null
	bonus_button = null
	quest_claim_buttons.clear()
	_refresh_alerts()


func _rebuild_daily() -> void:
	if _daily_body == null or not is_instance_valid(_daily_body):
		return
	for c in _daily_body.get_children():
		_daily_body.remove_child(c)
		c.queue_free()
	quest_claim_buttons.clear()
	login_claim_button = null
	bonus_button = null
	var now := _now()
	var e: Economy = Game.economy
	# (a) daily login
	var lp := UI.panel()
	lp.name = "login_panel"
	var lb := VBoxContainer.new()
	lb.add_theme_constant_override("separation", 6)
	lp.add_child(lb)
	lb.add_child(UI.label(Game.t("daily.login_title"), 20, UI.TEAL))
	lb.add_child(UI.label(Game.t("home.daily_login", [DataDB.bal_i("daily.login_gems", 10), DataDB.bal_i("daily.login_capsules", 1)]), 16))
	var streak := int(_profile["timestamps"].get("daily_streak", 0))
	if streak > 0:
		var sl := UI.label(Game.t("home.streak", [streak]), 16, UI.ORANGE)
		sl.name = "streak_label"
		lb.add_child(sl)
	lb.add_child(UI.label(Game.t("daily.streak_next", [DataDB.bal_i("daily.streak_day", 7)]), 14, UI.LOCKED_INK))
	if e.can_claim_daily(now):
		login_claim_button = UI.button(Game.t("ui.claim"), "primary", Vector2(0, 56), 22)
		login_claim_button.name = "login_claim"
		login_claim_button.pressed.connect(_on_login_claim)
		lb.add_child(login_claim_button)
	else:
		var done := UI.label(Game.t("daily.login_claimed"), 16, UI.LOCKED_INK)
		done.name = "login_claimed_note"
		lb.add_child(done)
	_daily_body.add_child(lp)
	# (b) quests
	_daily_body.add_child(UI.label(Game.t("home.daily_quests"), 20, UI.TEAL))
	for it in Game.quests.items(now):
		_daily_body.add_child(_quest_row(it))
	# (c) Bonus Capsule ad (max 1 per day)
	bonus_button = UI.button("", "teal", Vector2(0, 60), 18)
	bonus_button.name = "bonus_capsule"
	bonus_button.pressed.connect(_on_bonus_pressed)
	var text := Game.t("ads.bonus_capsule.desc", [DataDB.bal_i("ads.bonus_capsule_count", 1)])
	if Game.quests.bonus_capsule_available(now):
		MetaUI.refresh_ad_button(bonus_button, "bonus_capsule", text)
	else:
		MetaUI.refresh_ad_button(bonus_button, "bonus_capsule", text, Game.t("daily.bonus_used"))
	_daily_body.add_child(bonus_button)


func _quest_row(it: Dictionary) -> Control:
	var id := str(it["id"])
	var def := Quests.quest_def(id)
	var target := Game.quests.target_of(id)
	var prog := mini(int(it["progress"]), target)
	var p := UI.panel()
	p.name = "quest_" + id
	var b := VBoxContainer.new()
	b.add_theme_constant_override("separation", 4)
	p.add_child(b)
	b.add_child(UI.label(Game.t(str(def.get("name_key", "")), [target]), 18))
	var bar := ProgressBar.new()
	bar.name = "bar_" + id
	bar.min_value = 0
	bar.max_value = target
	bar.value = prog
	bar.show_percentage = false
	bar.custom_minimum_size = Vector2(0, 16)
	b.add_child(bar)
	var rw: Dictionary = def.get("reward", {})
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 8)
	var info := UI.label("%s\n%s" % [Game.t("quest.progress", [prog, target]),
			Game.t("quest.reward", [int(rw.get("coins", 0)), int(rw.get("gems", 0))])], 14, UI.LOCKED_INK)
	info.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(info)
	var btn := UI.button(Game.t("quest.claimed") if bool(it["claimed"]) else Game.t("ui.claim"), "primary", Vector2(120, 52), 18)
	btn.name = "claim_" + id
	btn.disabled = bool(it["claimed"]) or prog < target
	btn.pressed.connect(_on_quest_claim.bind(id))
	row.add_child(btn)
	quest_claim_buttons[id] = btn
	b.add_child(row)
	return p


func _on_login_claim() -> void:
	login_claim_button.disabled = true
	var r := Game.economy.claim_daily(_now())
	if bool(r.get("claimed", false)):
		_toast(Game.t("home.streak_bonus", [int(r["streak"])]) if bool(r.get("streak_bonus", false)) else Game.t("meta.reward_received"))


func _on_daily_claimed(_r: Dictionary) -> void:
	_refresh_alerts()
	_rebuild_daily.call_deferred()


func _on_quest_claim(id: String) -> void:
	if Game.quests.claim(id, _now()):
		_toast(Game.t("meta.reward_received"))


func _on_bonus_pressed() -> void:
	if Game.quests.bonus_capsule_available(_now()):
		Game.claim_bonus("bonus_capsule", {"capsules": DataDB.bal_i("ads.bonus_capsule_count", 1)})
