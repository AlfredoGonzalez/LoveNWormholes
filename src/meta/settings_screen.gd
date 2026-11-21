class_name SettingsScreen
extends Screen
## Settings (spec 8.7, 9.3, 9.4, mockup Settings.dc.html). Every change goes through the set_* methods, which apply
## it to the running services and persist it in Game.save.profile["settings"] (+ Game.save.save()).
## Consent is a MOCK here: profile["consent"]["state"] is "unknown" | "accepted" | "declined".

const CREDITS_PATH := "res://assets/audio/CREDITS.md"
const TEXT_SIZES := [["settings.text_small", 0.85], ["settings.text_normal", 1.0], ["settings.text_large", 1.25]]

var _body: VBoxContainer
var _status: Label
var _show_privacy := false
var _show_credits := false
var _confirm_delete := false
var _restore_wait := false
var _status_text := ""


var _built := false


func _ready() -> void:
	ensure_built()


## Builds the node tree once (idempotent: tests call it when the screen is not ready yet).
func ensure_built() -> void:
	if _built:
		return
	_built = true
	add_child(UI.background())
	var margin := MarginContainer.new()
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	for side in ["left", "right", "top", "bottom"]:
		margin.add_theme_constant_override("margin_" + side, 16)
	add_child(margin)
	var scroll := ScrollContainer.new()
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	margin.add_child(scroll)
	_body = VBoxContainer.new()
	_body.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_body.add_theme_constant_override("separation", 10)
	scroll.add_child(_body)
	_build()


# ---------------------------------------------------------------- state (public, persisted)

func settings() -> Dictionary:
	return Game.save.profile["settings"]


func _persist(save := true) -> void:
	Game.audio.apply_settings(settings())
	if save:
		Game.save.save()


func set_music(v: float, save := true) -> void:
	settings()["music"] = clampf(v, 0.0, 1.0)
	_persist(save)


func set_sfx(v: float, save := true) -> void:
	settings()["sfx"] = clampf(v, 0.0, 1.0)
	_persist(save)


func set_muted(m: bool) -> void:
	settings()["muted"] = m
	_persist()


func set_vibration(on: bool) -> void:
	settings()["vibration"] = on
	_persist()


## Stored only; applying it to the screens is future work.
func set_text_size(scale: float) -> void:
	settings()["text_size"] = scale
	_persist()


func set_language(lang: String) -> void:
	Game.set_language(lang)   # also persists
	_build()


func set_consent(state: String) -> void:
	if not state in ["unknown", "accepted", "declined"]:
		return
	Game.save.profile["consent"]["state"] = state
	Game.save.save()
	_build()


func restore_purchases() -> void:
	_restore_wait = true
	_status_text = Game.t("settings.restore_wait")
	if not Game.billing.restore_finished.is_connected(_on_restore_finished):
		Game.billing.restore_finished.connect(_on_restore_finished, CONNECT_ONE_SHOT)
	Game.billing.restore()
	_build()


func _on_restore_finished(newly_owned: Array) -> void:
	_restore_wait = false
	_status_text = Game.t("settings.restore_done", [newly_owned.size()]) if not newly_owned.is_empty() else Game.t("settings.restore_none")
	if is_inside_tree():
		_build()


## Erases the save, boots a fresh profile and goes to the title screen.
func delete_local_data() -> void:
	var path: String = Game.save.path
	var host: Control = Game.nav.host
	Game.ads.shutdown()
	Game.billing.shutdown()
	Game.save.delete_all()
	Game.boot(path)
	Game.nav.host = host
	Game.start_services()
	Game.nav.go("title")


func credits_lines() -> Array:
	var out: Array = []
	var f := FileAccess.open(CREDITS_PATH, FileAccess.READ)
	if f == null:
		return out
	for line in f.get_as_text().split("\n"):
		if line.begins_with("- "):
			out.append(line.substr(2).strip_edges())
	return out


# ---------------------------------------------------------------- UI

func _clear() -> void:
	for c in _body.get_children():
		_body.remove_child(c)
		c.queue_free()


func _build() -> void:
	_clear()
	var top := HBoxContainer.new()
	top.add_theme_constant_override("separation", 8)
	_body.add_child(top)
	var back := UI.button(Game.t("ui.back"), "ghost", Vector2(96, 0), 20)
	back.pressed.connect(_go_back)
	top.add_child(back)
	var title := UI.label(Game.t("settings.title"), 28, UI.INK, HORIZONTAL_ALIGNMENT_CENTER)
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	top.add_child(title)

	# Language
	var lang_panel := _section(Game.t("settings.language"))
	var lang_row := HBoxContainer.new()
	lang_row.add_theme_constant_override("separation", 8)
	lang_panel.add_child(lang_row)
	for pair in [["en", "settings.lang_en"], ["es", "settings.lang_es"]]:
		var on: bool = Localization.get_language() == pair[0]
		var b := UI.button(Game.t(pair[1]), "primary" if on else "ghost", Vector2(0, 0), 20)
		b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		b.pressed.connect(set_language.bind(pair[0]))
		lang_row.add_child(b)

	# Audio
	var audio_panel := _section(Game.t("settings.music"))
	audio_panel.add_child(_slider(float(settings().get("music", 0.7)), set_music))
	var sfx_title := UI.label(Game.t("settings.sfx"), 20)
	audio_panel.add_child(sfx_title)
	audio_panel.add_child(_slider(float(settings().get("sfx", 1.0)), set_sfx))
	var mute := _toggle(Game.t("settings.mute"), bool(settings().get("muted", false)))
	mute.pressed.connect(func(): set_muted(not bool(settings().get("muted", false))); _build())
	audio_panel.add_child(mute)

	# Vibration and text size
	var play_panel := _section(Game.t("settings.vibration"))
	var vib := _toggle(Game.t("settings.vibration"), bool(settings().get("vibration", true)))
	vib.pressed.connect(func(): set_vibration(not bool(settings().get("vibration", true))); _build())
	play_panel.add_child(vib)
	play_panel.add_child(UI.label(Game.t("settings.text_size"), 20))
	var size_row := HBoxContainer.new()
	size_row.add_theme_constant_override("separation", 6)
	play_panel.add_child(size_row)
	var cur_size := float(settings().get("text_size", 1.0))
	for ts in TEXT_SIZES:
		var b := UI.button(Game.t(ts[0]), "primary" if is_equal_approx(cur_size, float(ts[1])) else "ghost", Vector2(0, 0), 16)
		b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		b.pressed.connect(func(): set_text_size(float(ts[1])); _build())
		size_row.add_child(b)

	# Privacy
	var priv := _link_row(Game.t("settings.privacy_options"))
	priv.pressed.connect(func(): _show_privacy = not _show_privacy; _build())
	_body.add_child(priv)
	if _show_privacy:
		var pp := UI.panel()
		_body.add_child(pp)
		var pv := VBoxContainer.new()
		pv.add_theme_constant_override("separation", 8)
		pp.add_child(pv)
		var state := str(Game.save.profile["consent"].get("state", "unknown"))
		pv.add_child(UI.label(Game.t("settings.privacy_state", [Game.t("settings.consent_" + state)]), 18))
		pv.add_child(UI.label(Game.t("settings.privacy_note"), 14, UI.LOCKED_INK))
		var cr := HBoxContainer.new()
		cr.add_theme_constant_override("separation", 8)
		pv.add_child(cr)
		var acc := UI.button(Game.t("consent.accept"), "primary", Vector2(0, 0), 18)
		acc.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		acc.pressed.connect(set_consent.bind("accepted"))
		cr.add_child(acc)
		var dec := UI.button(Game.t("consent.decline"), "ghost", Vector2(0, 0), 18)
		dec.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		dec.pressed.connect(set_consent.bind("declined"))
		cr.add_child(dec)

	# Restore purchases
	var rest := _link_row(Game.t("settings.restore"))
	rest.disabled = _restore_wait
	rest.pressed.connect(restore_purchases)
	_body.add_child(rest)
	if _status_text != "":
		_status = UI.label(_status_text, 15, UI.TEAL)
		_body.add_child(_status)

	# Credits
	var cred := _link_row(Game.t("settings.credits"))
	cred.pressed.connect(func(): _show_credits = not _show_credits; _build())
	_body.add_child(cred)
	if _show_credits:
		var cp := UI.panel()
		_body.add_child(cp)
		var cv := VBoxContainer.new()
		cv.add_theme_constant_override("separation", 4)
		cp.add_child(cv)
		var lines := credits_lines()
		for l in lines:
			cv.add_child(UI.label(str(l), 14))
		cv.add_child(UI.label(Game.t("settings.credits_audio_note"), 14, UI.LOCKED_INK))

	# Delete local data
	var del := _link_row(Game.t("settings.delete_data"))
	del.pressed.connect(func(): _confirm_delete = true; _build())
	_body.add_child(del)
	if _confirm_delete:
		var dp := UI.panel(Color("FBE3DF"))
		_body.add_child(dp)
		var dv := VBoxContainer.new()
		dv.add_theme_constant_override("separation", 8)
		dp.add_child(dv)
		dv.add_child(UI.label(Game.t("settings.delete_confirm"), 16, UI.INK))
		var dr := HBoxContainer.new()
		dr.add_theme_constant_override("separation", 8)
		dv.add_child(dr)
		var yes := UI.button(Game.t("settings.delete_yes"), "primary", Vector2(0, 0), 16)
		yes.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		yes.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		yes.pressed.connect(delete_local_data)
		dr.add_child(yes)
		var no := UI.button(Game.t("ui.cancel"), "ghost", Vector2(0, 0), 16)
		no.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		no.pressed.connect(func(): _confirm_delete = false; _build())
		dr.add_child(no)

	var ver := str(ProjectSettings.get_setting("application/config/version", "0.1.0"))
	_body.add_child(UI.label(Game.t("settings.version", [ver]), 13, UI.LOCKED_INK, HORIZONTAL_ALIGNMENT_CENTER))


func _go_back() -> void:
	Game.nav.go("levels" if str(params.get("from", "")) == "levels" else "title")


func _section(title: String) -> VBoxContainer:
	var p := UI.panel()
	_body.add_child(p)
	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", 8)
	p.add_child(v)
	v.add_child(UI.label(title, 20))
	return v


func _link_row(text: String) -> Button:
	var b := UI.button(text, "ghost", Vector2(0, 56), 20)
	b.alignment = HORIZONTAL_ALIGNMENT_LEFT
	b.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	return b


func _toggle(text: String, on: bool) -> Button:
	var b := UI.button("%s: %s" % [text, Game.t("ui.on") if on else Game.t("ui.off")], "teal" if on else "ghost", Vector2(0, 56), 18)
	b.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	return b


func _slider(value: float, setter: Callable) -> HBoxContainer:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 10)
	var s := HSlider.new()
	s.min_value = 0.0
	s.max_value = 1.0
	s.step = 0.05
	s.value = value
	s.custom_minimum_size = Vector2(0, UI.MIN_TOUCH)
	s.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(s)
	var pct := UI.label(Game.t("settings.volume_pct", [roundi(value * 100.0)]), 16, UI.INK, HORIZONTAL_ALIGNMENT_RIGHT)
	pct.custom_minimum_size.x = 56
	row.add_child(pct)
	s.value_changed.connect(func(v: float):
		setter.call(v, false)
		pct.text = Game.t("settings.volume_pct", [roundi(v * 100.0)]))
	s.drag_ended.connect(func(_changed: bool): Game.save.save())
	return row
