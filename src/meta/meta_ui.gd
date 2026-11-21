class_name MetaUI
extends RefCounted
## Small helpers shared by the menu-flow screens (title, levels, prebattle, result).

## The active Time Squad (Squad.active): used where a battle needs a squad and none was passed.
static func default_squad() -> Array:
	return Squad.active(Game.save.profile)


static func default_powers() -> Array:
	return Squad.equipped_powers(Game.save.profile)


## A tappable card: a Button (so it is focusable and >= 48 px) with a "box" VBox on top for labels.
## kind: "normal" (cream), "selected" (gold border), "locked" (greyed, disabled), "empty" (greyed, tappable).
static func card_button(min_size: Vector2, kind := "normal") -> Button:
	var b := Button.new()
	b.custom_minimum_size = Vector2(min_size.x, maxf(min_size.y, UI.MIN_TOUCH))
	b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	b.clip_text = false
	var bg := UI.PANEL
	var border := UI.BORDER
	match kind:
		"selected":
			border = UI.ORANGE
		"locked", "empty":
			bg = UI.LOCKED
	b.add_theme_stylebox_override("normal", UI.style(bg, border, 16))
	b.add_theme_stylebox_override("hover", UI.style(bg.lightened(0.06), border, 16))
	b.add_theme_stylebox_override("pressed", UI.style(bg.darkened(0.1), border, 16, 3, false))
	b.add_theme_stylebox_override("disabled", UI.style(UI.LOCKED, UI.LOCKED_INK, 16))
	b.add_theme_stylebox_override("focus", StyleBoxEmpty.new())
	var box := VBoxContainer.new()
	box.name = "box"
	box.set_anchors_preset(Control.PRESET_FULL_RECT)
	box.offset_left = 6
	box.offset_right = -6
	box.offset_top = 4
	box.offset_bottom = -4
	box.alignment = BoxContainer.ALIGNMENT_CENTER
	box.mouse_filter = Control.MOUSE_FILTER_IGNORE
	box.add_theme_constant_override("separation", 2)
	b.add_child(box)
	b.disabled = kind == "locked"
	return b


## Removes every child immediately (not deferred) so a section can be rebuilt in the same frame.
static func clear_children(n: Node) -> void:
	for c in n.get_children():
		n.remove_child(c)
		c.queue_free()


## Full-screen margin + vertical box on top of the cream background. Returns the VBox.
static func scaffold(screen: Control, margin := 16) -> VBoxContainer:
	screen.add_child(UI.background())
	var m := MarginContainer.new()
	m.set_anchors_preset(Control.PRESET_FULL_RECT)
	for side in ["left", "right", "top", "bottom"]:
		m.add_theme_constant_override("margin_" + side, margin)
	screen.add_child(m)
	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", 10)
	m.add_child(v)
	return v


static func currency_bar() -> HBoxContainer:
	var h := HBoxContainer.new()
	h.add_theme_constant_override("separation", 8)
	var e: Economy = Game.economy
	for pair in [["coins", "●"], ["gems", "◆"], ["capsules", "◉"]]:
		var c := UI.chip(pair[1], str(e.get_amount(pair[0])))
		c.name = "chip_" + pair[0]
		h.add_child(c)
	return h


static func percent(fraction: float) -> int:
	return int(round(fraction * 100.0))


## Rewarded-ad button. The reward text is shown BEFORE the tap, with a video icon. When the placement is
## not available the button is disabled with "Not available right now" (never an error, never blocks).
## `done_text` (non-empty) replaces it once the reward was received.
static func refresh_ad_button(b: Button, placement: String, reward_text: String, done_text := "") -> void:
	if done_text != "":
		b.text = done_text
		b.disabled = true
		return
	if Game.ads != null and Game.ads.is_available(placement):
		b.text = "%s %s" % [Game.t("meta.video_icon"), reward_text]
		b.disabled = false
		Game.ads.note_offered(placement)   # analytics ad_offered, once per availability window
	else:
		b.text = "%s\n%s" % [reward_text, Game.t("ui.not_available")]
		b.disabled = true


static func ad_button(placement: String, reward_text: String) -> Button:
	var b := UI.button("", "teal", Vector2(0, 60), 18)
	b.name = "ad_" + placement
	refresh_ad_button(b, placement, reward_text)
	return b


static func format_time(seconds: float) -> String:
	var s := int(seconds)
	return "%d:%02d" % [s / 60, s % 60]


static func stars_text(n: int) -> String:
	var k := clampi(n, 0, 3)
	return "★".repeat(k) + "☆".repeat(3 - k)
