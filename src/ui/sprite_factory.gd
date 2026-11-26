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
	## Per-animation format: row -> anchor (feet) in the frame, and the placeholder nodes shown
	## for rows whose art is missing (the sprite is hidden then).
	var anchors: Dictionary = {}
	var hit_frames: Dictionary = {}
	var placeholder_nodes: Array = []
	var flipped := false

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
			# Partial art (idle but no attack...): show the placeholder for that animation.
			if sprite != null and not placeholder_nodes.is_empty():
				sprite.stop()
				_show_sprite(false)
				current_row = row
			return false
		_show_sprite(true)
		if anchors.has(row):
			var a: Vector2 = anchors[row]
			var fr := sprite.sprite_frames.get_frame_texture(row, 0)
			var w := float(fr.get_width()) if fr != null else a.x * 2.0
			sprite.offset = Vector2(-(w - a.x) if flipped else -a.x, -a.y)
		if restart or current_row != row:
			sprite.play(row)
		current_row = row
		return true

	func _show_sprite(on: bool) -> void:
		if sprite != null:
			sprite.visible = on
		for n in placeholder_nodes:
			(n as CanvasItem).visible = not on

	func stop_row() -> void:
		if sprite != null:
			sprite.stop()

	func _on_frame_changed() -> void:
		if current_row == "attack" and sprite.frame == int(hit_frames.get("attack", hit_frame)):
			hit_frame_reached.emit()

	func _on_animation_finished() -> void:
		row_finished.emit(current_row)

static func make_animated(id: String, facing_override := "") -> Node2D:
	var entry := SpriteManifest.get_entry(id)
	var actor := Actor.new()
	actor.name = id if id != "" else "Sprite"
	actor.id = id
	actor.entry = entry
	if SpriteManifest.is_anim_format(entry) and str(entry.get("kind", "sheet")) == "sheet":
		_build_per_anim(actor, id, entry, facing_override)
		return actor
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

## Per-animation format: each animation has its own atlas. Animations whose file or data is
## missing/invalid are simply left out (they show the placeholder); no usable animation at all
## gives a plain placeholder.
static func _build_per_anim(actor: Actor, id: String, entry: Dictionary, facing_override: String) -> void:
	var frames := SpriteFrames.new()
	if frames.has_animation("default"):
		frames.remove_animation("default")
	var anims: Dictionary = entry["anims"]
	var order := ["idle"]
	for k in anims.keys():
		if k != "idle":
			order.append(str(k))
	var first := ""
	for anim in order:
		if typeof(anims.get(anim, null)) != TYPE_DICTIONARY:
			continue
		var a: Dictionary = anims[anim]
		var tex := _load_texture(a)
		var fw := int(a.get("frame_w", 0))
		var fh := int(a.get("frame_h", 0))
		var n := int(a.get("frames", 25))
		var cols := maxi(1, int(a.get("cols", 5)))
		if tex == null or fw <= 0 or fh <= 0 or n <= 0 \
				or tex.get_width() < fw * mini(cols, n) or tex.get_height() < fh * int(ceil(float(n) / cols)):
			continue
		frames.add_animation(anim)
		frames.set_animation_speed(anim, maxf(1.0, float(a.get("fps", 12))))
		frames.set_animation_loop(anim, bool(a.get("loop", anim in LOOP_ROWS)))
		for i in range(n):
			var at := AtlasTexture.new()
			at.atlas = tex
			at.region = Rect2((i % cols) * fw, floori(float(i) / cols) * fh, fw, fh)
			frames.add_frame(anim, at)
		var anc: Variant = a.get("anchor", [fw / 2.0, fh])
		var ax := fw / 2.0
		var ay := float(fh)
		if typeof(anc) == TYPE_ARRAY and (anc as Array).size() >= 2:
			ax = float(anc[0])
			ay = float(anc[1])
		actor.anchors[anim] = Vector2(ax, ay)
		if a.has("hit_frame"):
			actor.hit_frames[anim] = int(a["hit_frame"])
		if first == "":
			first = anim
	var nominal := int(entry.get("nominal_h", entry.get("frame_h", 0)))
	if nominal > 0:
		var e2 := entry.duplicate()
		e2["frame_h"] = nominal
		_build_placeholder(actor, id, e2, facing_override)
	else:
		_build_placeholder(actor, id, entry, facing_override)
	if first == "":
		return  # nothing usable: plain placeholder
	actor.is_placeholder = false
	actor.placeholder_nodes = actor.get_children()
	var spr := AnimatedSprite2D.new()
	spr.sprite_frames = frames
	spr.centered = false
	spr.flip_h = _needs_flip(entry, facing_override)
	actor.flipped = spr.flip_h
	actor.add_child(spr)
	actor.sprite = spr
	actor.hit_frame = int(entry.get("hit_frame", 2))
	spr.frame_changed.connect(actor._on_frame_changed)
	spr.animation_finished.connect(actor._on_animation_finished)
	actor.play_row("idle" if frames.has_animation("idle") else first)

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

static var _tex_cache: Dictionary = {}   # resolved path -> Texture2D (hits only)
static var _cache_gen := -1


## Drops the cached textures (used at exit by the test runner so no RID is reported as leaked).
static func clear_caches() -> void:
	_tex_cache.clear()
	_trim_cache.clear()
	_cache_gen = -1

static func _load_texture(entry: Dictionary) -> Texture2D:
	var p := str(entry.get("path", ""))
	if p == "":
		return null
	return _load_path(p)

static func _load_path(p: String) -> Texture2D:
	if _cache_gen != SpriteManifest.generation:
		_tex_cache.clear()
		_cache_gen = SpriteManifest.generation
	p = SpriteManifest.resolve_path(p)
	if _tex_cache.has(p):
		return _tex_cache[p]
	var tex: Texture2D = null
	if ResourceLoader.exists(p):
		var res: Variant = ResourceLoader.load(p)
		if res is Texture2D:
			tex = res
	if tex == null and FileAccess.file_exists(p):
		var img := Image.load_from_file(p)
		if img != null and not img.is_empty():
			tex = ImageTexture.create_from_image(img)
	if tex != null:
		_tex_cache[p] = tex
	return tex

## ---- Reusable art lookups (all return null / empty when the id or the file is missing, so every
## caller keeps its code-drawn placeholder). Ids by convention: icon_*, power_<id>, proj_*, fx_*,
## base_p<era> / base_e<era>, bg_era<N>.

## Texture of a static / image entry (icon_coin, bg_era1, base_p1 ...) or null.
static func texture_of(id: String) -> Texture2D:
	var e := SpriteManifest.get_entry(id)
	if e.is_empty() or SpriteManifest.is_anim_format(e):
		return null
	return _load_texture(e)

## "facing" of a manifest entry ("right" when unspecified).
static func facing_of(id: String) -> String:
	return str(SpriteManifest.get_entry(id).get("facing", "right"))

## First frame of an animation of an animated character (idle by default) or null.
static func frame_texture(id: String, anim := "idle", index := 0) -> Texture2D:
	var a := SpriteManifest.get_anim(id, anim)
	if a.is_empty():
		return null
	var tex := _load_texture(a)
	var fw := int(a.get("frame_w", 0))
	var fh := int(a.get("frame_h", 0))
	var cols := maxi(1, int(a.get("cols", 5)))
	if tex == null or fw <= 0 or fh <= 0 or tex.get_width() < fw * cols or tex.get_height() < fh * (index / cols + 1):
		return null
	var at := AtlasTexture.new()
	at.atlas = tex
	at.region = Rect2((index % cols) * fw, (index / cols) * fh, fw, fh)
	return at

## Portrait of a unit: idle frame 0, else the first frame of any animation, else its ref image, else null.
static func portrait_of(id: String) -> Texture2D:
	var t := frame_texture(id, "idle", 0)
	if t != null:
		return t
	for anim in SpriteManifest.anim_names(id):
		t = frame_texture(id, str(anim), 0)
		if t != null:
			return t
	var rp := SpriteManifest.ref_path(id)
	if rp != "":
		return _load_path(rp)
	return null

static var _trim_cache: Dictionary = {}

## Portrait cropped to the visible (non-transparent) part, with a small margin: what a unit card shows.
static func portrait_trimmed(id: String) -> Texture2D:
	if _cache_gen != SpriteManifest.generation:
		_tex_cache.clear()
		_trim_cache.clear()
		_cache_gen = SpriteManifest.generation
	if _trim_cache.has(id):
		return _trim_cache[id]
	var t := portrait_of(id)
	var out := t
	if t is AtlasTexture:
		var at := t as AtlasTexture
		var img := at.get_image()
		if img != null and not img.is_empty():
			var ur := img.get_used_rect()
			if ur.size.x > 0 and ur.size.y > 0:
				ur = ur.grow(4).intersection(Rect2i(Vector2i.ZERO, img.get_size()))
				var at2 := AtlasTexture.new()
				at2.atlas = at.atlas
				at2.region = Rect2(at.region.position + Vector2(ur.position), Vector2(ur.size))
				out = at2
	elif t != null:
		var img2 := t.get_image()
		if img2 != null and not img2.is_empty():
			var ur2 := img2.get_used_rect()
			if ur2.size.x > 0 and ur2.size.y > 0:
				ur2 = ur2.grow(4).intersection(Rect2i(Vector2i.ZERO, img2.get_size()))
				var at3 := AtlasTexture.new()
				at3.atlas = t
				at3.region = Rect2(ur2)
				out = at3
	if out != null:
		_trim_cache[id] = out
	return out

## A TextureRect showing the art `id`, fitted inside `size` (aspect kept), or null when missing.
## `flip` mirrors it horizontally (to face the other way).
static func icon(id: String, size: Variant = 28.0, flip := false) -> TextureRect:
	return rect_of(texture_of(id), size, flip)

static func rect_of(tex: Texture2D, size: Variant = 28.0, flip := false) -> TextureRect:
	if tex == null:
		return null
	var sz: Vector2 = size if size is Vector2 else Vector2(float(size), float(size))
	var r := TextureRect.new()
	r.texture = tex
	r.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	r.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	r.custom_minimum_size = sz
	r.size = sz
	r.flip_h = flip
	r.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return r

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
