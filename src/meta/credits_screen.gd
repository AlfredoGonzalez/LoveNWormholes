class_name CreditsScreen
extends Screen
## Credits (Settings > Credits, spec 9.1 row 14, 10): studio, design, art and audio placeholders, the engine,
## and the licensed-file list from assets/audio/CREDITS.md (SettingsScreen.credits_lines).
## params: {from: <what Settings was opened from>}; Back returns to Settings with it.

var back_button: Button
var _built := false


func _ready() -> void:
	ensure_built()


func ensure_built() -> void:
	if _built:
		return
	_built = true
	var v := MetaUI.scaffold(self, 16)
	v.add_theme_constant_override("separation", 10)
	var top := HBoxContainer.new()
	v.add_child(top)
	back_button = UI.button(Game.t("ui.back"), "ghost", Vector2(96, 0), 20)
	back_button.name = "back_button"
	back_button.pressed.connect(back)
	top.add_child(back_button)
	var title := UI.label(Game.t("credits.title"), 28, UI.INK, HORIZONTAL_ALIGNMENT_CENTER)
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	top.add_child(title)
	var scroll := ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	v.add_child(scroll)
	var body := VBoxContainer.new()
	body.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	body.add_theme_constant_override("separation", 10)
	scroll.add_child(body)
	body.add_child(UI.placeholder("LOGO", UI.GOLD, Vector2(0, 110)))
	body.add_child(UI.label(Game.t("credits.game"), 24, UI.INK, HORIZONTAL_ALIGNMENT_CENTER))
	body.add_child(UI.label(Game.t("credits.studio"), 18, UI.TEAL, HORIZONTAL_ALIGNMENT_CENTER))
	for pair in [["credits.design_title", "credits.design"], ["credits.art_title", "credits.art"],
			["credits.audio_title", "credits.audio"], ["credits.engine_title", "credits.engine"]]:
		body.add_child(_section(Game.t(pair[0]), Game.t(pair[1])))
	var files := SettingsScreen.credits_lines()
	var fp := _section(Game.t("credits.files_title"), "")
	var fv: VBoxContainer = fp.get_child(0)
	if files.is_empty():
		fv.add_child(UI.label(Game.t("credits.files_none"), 14, UI.LOCKED_INK))
	for l in files:
		fv.add_child(UI.label(str(l), 14))
	body.add_child(fp)
	body.add_child(UI.label(Game.t("credits.thanks"), 18, UI.INK, HORIZONTAL_ALIGNMENT_CENTER))


func _section(title: String, text: String) -> PanelContainer:
	var p := UI.panel()
	var b := VBoxContainer.new()
	b.add_theme_constant_override("separation", 4)
	p.add_child(b)
	b.add_child(UI.label(title, 20, UI.TEAL))
	if text != "":
		b.add_child(UI.label(text, 17))
	return p


func back() -> void:
	Game.nav.go("settings", {"from": str(params.get("from", ""))})
