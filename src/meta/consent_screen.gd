class_name ConsentScreen
extends Screen
## UMP-like consent screen (spec 7.1, 8.7, 9.1). Shown at the first launch (boot order: studio intro, consent, title)
## and re-opened from Settings > Privacy options. Audience 13+, Latin America. Ads only load after a choice.
## params: {next: "title"} screen to open after the choice (default "title"); {from: "settings"} marks a re-open
## (a Back button appears and the current choice is shown).
## Accept = personalized ads + analytics; Decline = non-personalized ads, no analytics storage. Either way the
## game is fully playable and no ad is ever shown without a tap on an ad button.

var accept_button: Button
var decline_button: Button
var policy_button: Button
var back_button: Button
var _built := false


func _ready() -> void:
	ensure_built()


func ensure_built() -> void:
	if _built:
		return
	_built = true
	add_child(UI.background())
	var m := MarginContainer.new()
	m.set_anchors_preset(Control.PRESET_FULL_RECT)
	for side in ["left", "right", "top", "bottom"]:
		m.add_theme_constant_override("margin_" + side, 20)
	add_child(m)
	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", 12)
	m.add_child(v)

	var reopened := is_reopen()
	if reopened:
		back_button = UI.button(Game.t("ui.back"), "ghost", Vector2(96, UI.MIN_TOUCH), 20)
		back_button.name = "consent_back"
		back_button.pressed.connect(_leave)
		v.add_child(back_button)

	var scroll := ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	v.add_child(scroll)
	var body := VBoxContainer.new()
	body.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	body.add_theme_constant_override("separation", 12)
	scroll.add_child(body)

	body.add_child(UI.label(Game.t("privacy.title"), 30, UI.INK, HORIZONTAL_ALIGNMENT_CENTER))
	body.add_child(_wrapped(Game.t("privacy.intro"), 18))
	var panel := UI.panel()
	body.add_child(panel)
	var pv := VBoxContainer.new()
	pv.add_theme_constant_override("separation", 8)
	panel.add_child(pv)
	for k in ["privacy.point_optional", "privacy.point_data", "privacy.point_accept", "privacy.point_decline",
			"privacy.point_age"]:
		pv.add_child(_wrapped("• " + Game.t(k), 16))
	if reopened:
		var st := Game.consent.state()
		body.add_child(UI.label(Game.t("settings.privacy_state", [Game.t("settings.consent_" + st)]), 16, UI.TEAL))
	body.add_child(_wrapped(Game.t("privacy.change_later"), 14, UI.LOCKED_INK))

	policy_button = UI.button(Game.t("settings.privacy_policy"), "ghost", Vector2(0, UI.MIN_TOUCH), 18)
	policy_button.name = "consent_policy"
	policy_button.pressed.connect(open_policy)
	policy_button.visible = policy_url() != ""
	body.add_child(policy_button)

	accept_button = UI.button(Game.t("privacy.accept"), "primary", Vector2(0, 60), 22)
	accept_button.name = "consent_accept"
	accept_button.pressed.connect(func(): choose(true))
	v.add_child(accept_button)
	decline_button = UI.button(Game.t("privacy.decline"), "ghost", Vector2(0, 56), 20)
	decline_button.name = "consent_decline"
	decline_button.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	decline_button.pressed.connect(func(): choose(false))
	v.add_child(decline_button)


func _wrapped(text: String, size: int, color := UI.INK) -> Label:
	var l := UI.label(text, size, color)
	l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	l.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	return l


func is_reopen() -> bool:
	return str(params.get("from", "")) == "settings"


## Privacy policy link from config/app_links.json (empty until the page exists, then the button is hidden).
static func policy_url() -> String:
	var f := FileAccess.open("res://config/app_links.json", FileAccess.READ)
	if f == null:
		return ""
	var d = JSON.parse_string(f.get_as_text())
	return str(d.get("privacy_policy_url", "")) if typeof(d) == TYPE_DICTIONARY else ""


func open_policy() -> void:
	var u := policy_url()
	if u != "":
		OS.shell_open(u)


func choose(accepted: bool) -> void:
	accept_button.disabled = true
	decline_button.disabled = true
	if Game.consent.provider.is_form_required():
		# The platform form (UMP) is async: leave once the choice has been stored.
		Game.consent.changed.connect(func(_s): _leave(), CONNECT_ONE_SHOT)
		Game.consent.set_choice(accepted)
		return
	Game.consent.set_choice(accepted)
	_leave()


func _leave() -> void:
	Game.nav.go(str(params.get("next", "title")), params.get("next_params", {}))
