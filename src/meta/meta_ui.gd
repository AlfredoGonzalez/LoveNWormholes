class_name MetaUI
extends RefCounted
## Small helpers shared by the menu-flow screens (title, levels, prebattle, result).

const DEFAULT_POWERS := ["squirm_slam", "apple_rain"]
const SQUAD_SIZE := 3


## The 3 Era-1 units used as the squad in the vertical slice.
static func default_squad() -> Array:
	var ids: Array = []
	for u in DataDB.units_of_era(1):
		ids.append(str(u["id"]))
		if ids.size() >= SQUAD_SIZE:
			break
	return ids


static func default_powers() -> Array:
	var eq: Array = Game.save.profile["loadout"].get("equipped_powers", [])
	if not eq.is_empty():
		return eq.duplicate()
	return DEFAULT_POWERS.duplicate()


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
