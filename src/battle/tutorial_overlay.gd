class_name TutorialOverlay
extends Control
## Tutorial layer on top of the battle: a dimmed screen with a pulsing hole around the highlighted control and a
## speech bubble (Squirmy placeholder, text, "Got it" for info steps, "Skip tutorial" always).
## It only reports what the player did; TutorialDirector decides what happens. Blocking steps (`hold`) swallow
## every tap outside the highlighted rect; non blocking ones let taps through (only the bubble catches them).

signal advance            ## info step acknowledged (button, or a tap on a blocking info step)
signal target_tapped      ## action step: the highlighted control was tapped
signal skip_requested

const W := 540.0
const PAD := 8.0

var hole := Rect2()       ## highlighted rect in this control's coordinates (size 0 = none)
var blocking := true
var kind := "info"
var bubble: PanelContainer
var text_label: Label
var next_button: Button
var skip_button: Button
var _t := 0.0


func _init() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_STOP
	name = "TutorialOverlay"
	visible = false


func _ready() -> void:
	bubble = UI.panel()
	bubble.name = "bubble"
	bubble.position = Vector2(20, 300)
	bubble.custom_minimum_size = Vector2(W - 40.0, 0)
	bubble.size = Vector2(W - 40.0, 10)
	add_child(bubble)
	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", 8)
	bubble.add_child(v)
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 10)
	v.add_child(row)
	row.add_child(UI.placeholder("Squirmy", UI.GREEN, Vector2(64, 64)))
	text_label = UI.label("", 20)
	text_label.name = "text"
	text_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	text_label.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	text_label.custom_minimum_size = Vector2(340, 0)   # so the wrapped height is measured at a real width
	row.add_child(text_label)
	var btns := HBoxContainer.new()
	btns.add_theme_constant_override("separation", 8)
	v.add_child(btns)
	skip_button = UI.button(Game.t("tut.skip"), "ghost", Vector2(0, UI.MIN_TOUCH), 16)
	skip_button.name = "skip"
	skip_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	skip_button.pressed.connect(func(): skip_requested.emit())
	btns.add_child(skip_button)
	next_button = UI.button(Game.t("tut.got_it"), "primary", Vector2(0, UI.MIN_TOUCH), 18)
	next_button.name = "next"
	next_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	next_button.pressed.connect(func(): advance.emit())
	btns.add_child(next_button)


## rect: highlighted area in this control's coordinates (Rect2() for none).
func show_step(text: String, rect: Rect2, p_kind: String, p_blocking: bool) -> void:
	hole = rect.grow(PAD) if rect.size != Vector2.ZERO else Rect2()
	kind = p_kind
	blocking = p_blocking
	text_label.text = text
	next_button.visible = kind == "info"
	visible = true
	mouse_filter = Control.MOUSE_FILTER_STOP if blocking else Control.MOUSE_FILTER_IGNORE
	# The bubble goes to the half of the screen the highlight is not in.
	var by := 200.0 if hole.size != Vector2.ZERO and hole.position.y > 400.0 else 300.0
	bubble.position = Vector2(20, by)
	_fit()
	call_deferred("_fit")
	queue_redraw()


func _fit() -> void:
	if bubble != null:
		bubble.reset_size()
		bubble.size.x = W - 40.0


func hide_step() -> void:
	visible = false
	hole = Rect2()


func _process(delta: float) -> void:
	if visible and hole.size != Vector2.ZERO:
		_t += delta
		queue_redraw()


func _draw() -> void:
	if not visible:
		return
	var full := Rect2(Vector2.ZERO, size if size != Vector2.ZERO else Vector2(W, 960.0))
	var dim := Color(0.08, 0.05, 0.02, 0.62)
	if not blocking:
		dim.a = 0.0
	if hole.size == Vector2.ZERO:
		if blocking:
			draw_rect(full, dim)
		return
	if blocking:
		draw_rect(Rect2(0, 0, full.size.x, hole.position.y), dim)
		draw_rect(Rect2(0, hole.end.y, full.size.x, full.size.y - hole.end.y), dim)
		draw_rect(Rect2(0, hole.position.y, hole.position.x, hole.size.y), dim)
		draw_rect(Rect2(hole.end.x, hole.position.y, full.size.x - hole.end.x, hole.size.y), dim)
	var pulse := 0.5 + 0.5 * sin(_t * 5.0)
	var col := Color(UI.GOLD, 0.65 + 0.35 * pulse)
	draw_rect(hole.grow(pulse * 3.0), col, false, 4.0)


func _gui_input(event: InputEvent) -> void:
	if not blocking or not (event is InputEventMouseButton):
		return
	var mb := event as InputEventMouseButton
	if not mb.pressed or mb.button_index != MOUSE_BUTTON_LEFT:
		return
	accept_event()
	if kind == "info":
		advance.emit()
	elif hole.has_point(mb.position):
		target_tapped.emit()
