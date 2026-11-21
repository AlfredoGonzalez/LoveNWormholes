class_name SpriteFactory
extends RefCounted
## Builds sprite nodes in code from the manifest. Missing art never crashes: a coloured
## placeholder rectangle (with the id as label) is returned instead.
## Node origin is the bottom-centre of the sprite (feet), so units can sit on a lane line.

const LOOP_ROWS := ["idle", "walk"]
const PLAYER_COLOR := Color(0.2, 0.45, 0.9)
const ENEMY_COLOR := Color(0.9, 0.25, 0.2)
const NEUTRAL_COLOR := Color(0.5, 0.5, 0.5)

class Actor extends Node2D:
	## Emitted when a non-looping row finishes.
	signal row_finished(row: String)
	## Emitted when the attack row reaches its hit frame.
	signal hit_frame_reached

	var id := ""
	var is_placeholder := false
	var entry: Dictionary = {}
	var frame_size := Vector2i.ZERO
	var hit_frame := 2
	var current_row := ""
	var sprite: AnimatedSprite2D = null  ## null for placeholders and static sprites

	func has_row(row: String) -> bool:
		return sprite != null and sprite.sprite_frames != null and sprite.sprite_frames.has_animation(row)

	func row_names() -> PackedStringArray:
		if sprite == null or sprite.sprite_frames == null:
			return PackedStringArray()
		return sprite.sprite_frames.get_animation_names()

	## Plays a row by name (idle, walk, attack, hurt, defeat / cast_slam ...). Returns false
	## (and does nothing) when the row does not exist, e.g. on a placeholder.
	func play_row(row: String, restart := true) -> bool:
		if not has_row(row):
			return false
		if restart or current_row != row:
			sprite.play(row)
		current_row = row
		return true

	func stop_row() -> void:
		if sprite != null:
			sprite.stop()

	func _on_frame_changed() -> void:
		if current_row == "attack" and sprite.frame == hit_frame:
			hit_frame_reached.emit()

	func _on_animation_finished() -> void:
		row_finished.emit(current_row)

static func make_animated(id: String, facing_override := "") -> Node2D:
	var entry := SpriteManifest.get_entry(id)
	var actor := Actor.new()
	actor.name = id if id != "" else "Sprite"
	actor.id = id
	actor.entry = entry
	var tex := _load_texture(entry)
	if entry.is_empty() or tex == null or str(entry.get("kind", "sheet")) != "sheet":
		_build_placeholder(actor, id, entry, facing_override)
		return actor
	var fw := int(entry.get("frame_w", 0))
	var fh := int(entry.get("frame_h", 0))
	var rows: Array = entry.get("rows", [])
	var per_row := int(entry.get("frames_per_row", 5))
	if fw <= 0 or fh <= 0 or rows.is_empty() or per_row <= 0 \
			or tex.get_width() < fw * per_row or tex.get_height() < fh * rows.size():
		_build_placeholder(actor, id, entry, facing_override)
		return actor
	var fps: Dictionary = entry.get("fps", {})
	var frames := SpriteFrames.new()
	if frames.has_animation("default"):
		frames.remove_animation("default")
	for r in range(rows.size()):
		var row := str(rows[r])
		frames.add_animation(row)
		frames.set_animation_speed(row, float(fps.get(row, 8)))
		frames.set_animation_loop(row, row in LOOP_ROWS)
		for c in range(per_row):
			var at := AtlasTexture.new()
			at.atlas = tex
			at.region = Rect2(c * fw, r * fh, fw, fh)
			frames.add_frame(row, at)
	var spr := AnimatedSprite2D.new()
	spr.sprite_frames = frames
	spr.centered = false
	spr.offset = Vector2(-fw / 2.0, -fh)
	spr.flip_h = _needs_flip(entry, facing_override)
	actor.add_child(spr)
	actor.sprite = spr
	actor.frame_size = Vector2i(fw, fh)
	actor.hit_frame = int(entry.get("hit_frame", 2))
	spr.frame_changed.connect(actor._on_frame_changed)
	spr.animation_finished.connect(actor._on_animation_finished)
	actor.play_row(str(rows[0]))
	return actor

static func make_static(id: String, facing_override := "") -> Node2D:
	var entry := SpriteManifest.get_entry(id)
	var actor := Actor.new()
	actor.name = id if id != "" else "Sprite"
	actor.id = id
	actor.entry = entry
	var tex := _load_texture(entry)
	if entry.is_empty() or tex == null:
		_build_placeholder(actor, id, entry, facing_override)
		return actor
	var spr := Sprite2D.new()
	spr.texture = tex
	spr.centered = false
	spr.offset = Vector2(-tex.get_width() / 2.0, -tex.get_height())
	spr.flip_h = _needs_flip(entry, facing_override)
	actor.add_child(spr)
	actor.frame_size = Vector2i(tex.get_width(), tex.get_height())
	return actor

static func _needs_flip(entry: Dictionary, facing_override: String) -> bool:
	if facing_override == "":
		return false
	return facing_override != str(entry.get("facing", facing_override))

static func _load_texture(entry: Dictionary) -> Texture2D:
	var p := str(entry.get("path", ""))
	if p == "":
		return null
	p = SpriteManifest.resolve_path(p)
	if ResourceLoader.exists(p):
		var res: Variant = ResourceLoader.load(p)
		if res is Texture2D:
			return res
	if FileAccess.file_exists(p):
		var img := Image.load_from_file(p)
		if img != null and not img.is_empty():
			return ImageTexture.create_from_image(img)
	return null

## "player", "enemy" or "neutral" from the id convention (p1_*, e1_*, b1_*, base_p1, squirmy).
static func side_of(id: String) -> String:
	var s := id.trim_prefix("base_")
	if s.begins_with("squirmy") or (s.length() > 1 and s[0] == "p" and s[1].is_valid_int()):
		return "player"
	if s.length() > 1 and (s[0] == "e" or s[0] == "b") and s[1].is_valid_int():
		return "enemy"
	return "neutral"

static func _default_size(id: String) -> Vector2i:
	if id.begins_with("base_"):
		return Vector2i(512, 384)
	if id.begins_with("squirmy"):
		return Vector2i(240, 384)
	if id.length() > 1 and id[0] == "b" and id[1].is_valid_int():
		return Vector2i(320, 512)
	if side_of(id) != "neutral":
		return Vector2i(160, 256)
	return Vector2i(128, 128)

static func _build_placeholder(actor: Actor, id: String, entry: Dictionary, facing_override: String) -> void:
	actor.is_placeholder = true
	var size := _default_size(id)
	if entry.has("frame_w") and entry.has("frame_h"):
		size = Vector2i(maxi(int(entry["frame_w"]), 16), maxi(int(entry["frame_h"]), 16))
	actor.frame_size = size
	var accent := NEUTRAL_COLOR
	match side_of(id):
		"player": accent = PLAYER_COLOR
		"enemy": accent = ENEMY_COLOR
	var origin := Vector2(-size.x / 2.0, -size.y)
	var body := ColorRect.new()
	body.name = "PlaceholderBody"
	body.color = Color(accent.r, accent.g, accent.b, 0.35)
	body.position = origin
	body.size = Vector2(size)
	body.mouse_filter = Control.MOUSE_FILTER_IGNORE
	actor.add_child(body)
	# Accent border (four thin bars).
	var t := 6.0
	for r in [Rect2(0, 0, size.x, t), Rect2(0, size.y - t, size.x, t),
			Rect2(0, 0, t, size.y), Rect2(size.x - t, 0, t, size.y)]:
		var bar := ColorRect.new()
		bar.color = accent
		bar.position = origin + r.position
		bar.size = r.size
		bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
		actor.add_child(bar)
	# Facing marker: accent block on the side the unit looks to.
	var facing := facing_override if facing_override != "" else ("left" if side_of(id) == "enemy" else "right")
	var fx := size.x - 3.0 * t if facing == "right" else 0.0
	var mark := ColorRect.new()
	mark.color = accent
	mark.position = origin + Vector2(fx, size.y * 0.35)
	mark.size = Vector2(3.0 * t, size.y * 0.15)
	mark.mouse_filter = Control.MOUSE_FILTER_IGNORE
	actor.add_child(mark)
	var label := Label.new()
	label.name = "PlaceholderLabel"
	label.text = id
	label.add_theme_font_size_override("font_size", 14)
	label.add_theme_color_override("font_color", Color.WHITE)
	label.add_theme_color_override("font_outline_color", Color.BLACK)
	label.add_theme_constant_override("outline_size", 4)
	label.position = origin + Vector2(t + 2.0, size.y / 2.0 - 10.0)
	label.size = Vector2(size.x - 2.0 * t - 4.0, 24)
	label.autowrap_mode = TextServer.AUTOWRAP_ARBITRARY
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	actor.add_child(label)
