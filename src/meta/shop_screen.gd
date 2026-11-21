class_name ShopScreen
extends Screen
## Shop (spec 7.3, 9.1; mockup Shop): Starter pack, Golden Pass, Gem packs, Gem items, hero skins, free items and
## Restore purchases. All logic lives in Game.shop (Shop) / Game.billing; this screen only shows and forwards.
## Prices come from the store provider (localized) with the USD reference tier of data/shop.json as fallback.
## There are no ads to remove: the Golden Pass makes rewarded bonuses automatic (see Shop).
##
## `params`: {"from": "home" | "result"} for the back button; {"now": unix time} for tests.

var buy_buttons: Dictionary = {}       # product id -> Button
var gem_item_buttons: Dictionary = {}  # gem item id -> Button
var restore_button: Button
var daily_button: Button
var bonus_button: Button
var capsules_card: Control            # null unless Navigator.can_go("capsules")
var capsules_button: Button
var status_label: Label
var status_text := ""

var _chips: HBoxContainer
var _list: VBoxContainer
var _built := false
var _dirty := false
var _restore_wait := false


func _ready() -> void:
	ensure_built()


func _exit_tree() -> void:
	if Game.shop != null:
		for pair in [[Game.shop.changed, _request_refresh], [Game.shop.purchase_error, _on_purchase_error]]:
			if (pair[0] as Signal).is_connected(pair[1]):
				(pair[0] as Signal).disconnect(pair[1])
	if Game.economy.currency_changed.is_connected(_on_currency_changed):
		Game.economy.currency_changed.disconnect(_on_currency_changed)
	if Game.billing.restore_finished.is_connected(_on_restore_finished):
		Game.billing.restore_finished.disconnect(_on_restore_finished)


func _now() -> float:
	return float(params.get("now", Time.get_unix_time_from_system()))


## Builds the node tree once (idempotent: tests call it when the screen is not ready yet).
func ensure_built() -> void:
	if _built:
		return
	_built = true
	var root := MetaUI.scaffold(self, 16)
	var top := HBoxContainer.new()
	top.add_theme_constant_override("separation", 8)
	root.add_child(top)
	var back := UI.button(Game.t("ui.back"), "ghost", Vector2(96, 0), 20)
	back.name = "back"
	back.pressed.connect(func(): Game.nav.go("levels" if str(params.get("from", "home")) == "levels" else "home"))
	top.add_child(back)
	var title := UI.label(Game.t("shop.title"), 28, UI.INK, HORIZONTAL_ALIGNMENT_CENTER)
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	top.add_child(title)
	_chips = MetaUI.currency_bar()
	root.add_child(_chips)
	status_label = UI.label("", 16, UI.TEAL, HORIZONTAL_ALIGNMENT_CENTER)
	status_label.name = "status"
	root.add_child(status_label)
	var scroll := ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	root.add_child(scroll)
	_list = VBoxContainer.new()
	_list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_list.add_theme_constant_override("separation", 10)
	scroll.add_child(_list)
	Game.shop.changed.connect(_request_refresh)
	Game.shop.purchase_error.connect(_on_purchase_error)
	Game.economy.currency_changed.connect(_on_currency_changed)
	refresh()
	# iap_view: the player opened the Shop and sees these real-money products (not logged on purchase).
	if Game.analytics != null:
		for pid in buy_buttons:
			Game.analytics.iap_view(str(pid))


func _request_refresh() -> void:
	if _dirty:
		return
	_dirty = true
	_apply_refresh.call_deferred()


func _apply_refresh() -> void:
	_dirty = false
	if is_inside_tree():
		refresh()


func _on_currency_changed(_c: String, _v: int, _d: int) -> void:
	_request_refresh()


func _on_purchase_error(_product_id: String, kind: String) -> void:
	status_text = Game.t({"cancelled": "shop.err_cancelled", "network": "shop.err_network"}.get(kind, "shop.purchase_failed"))
	_set_status()


func _set_status() -> void:
	if status_label != null and is_instance_valid(status_label):
		status_label.text = status_text


# ---------------------------------------------------------------- actions (public: tests call them)

func buy(product_id: String) -> bool:
	status_text = ""
	var ok := Game.shop.buy(product_id)
	if ok:
		Game.audio.play_sfx("buy")
	if ok and Game.shop.owns(product_id):
		status_text = Game.t("shop.bought")
	_set_status()
	return ok


func restore_purchases() -> void:
	if _restore_wait:
		return
	_restore_wait = true
	status_text = Game.t("settings.restore_wait")
	_set_status()
	if not Game.billing.restore_finished.is_connected(_on_restore_finished):
		Game.billing.restore_finished.connect(_on_restore_finished, CONNECT_ONE_SHOT)
	Game.billing.restore()
	_request_refresh()


func _on_restore_finished(newly_owned: Array) -> void:
	_restore_wait = false
	status_text = Game.t("settings.restore_done", [newly_owned.size()]) if not newly_owned.is_empty() else Game.t("settings.restore_none")
	_set_status()


func buy_gem_item(item_id: String) -> void:
	var r: Dictionary = Game.shop.buy_gem_item(item_id)
	if bool(r["ok"]):
		Game.audio.play_sfx("buy")
	status_text = Game.t("shop.item_bought") if bool(r["ok"]) else (Game.t("shop.not_enough_gems") if r["reason"] == "not_enough_gems" else "")
	_set_status()


func claim_daily() -> void:
	var r: Dictionary = Game.economy.claim_daily(_now())
	if bool(r.get("claimed", false)):
		Game.audio.play_sfx("coin")
		status_text = Game.t("shop.daily_claimed")
		_set_status()
		_request_refresh()


## Golden Pass: the Bonus Capsule applies without watching an ad (still max per day). Otherwise a rewarded ad.
func claim_bonus_capsule() -> void:
	if not Game.quests.bonus_capsule_available(_now()):
		return
	var reward := {"capsules": DataDB.bal_i("ads.bonus_capsule_count", 1)}
	Game.claim_bonus("bonus_capsule", reward)
	_request_refresh()


# ---------------------------------------------------------------- UI

func refresh() -> void:
	buy_buttons.clear()
	gem_item_buttons.clear()
	capsules_card = null
	capsules_button = null
	daily_button = null
	bonus_button = null
	for c in _list.get_children():
		_list.remove_child(c)
		c.queue_free()
	var fresh := MetaUI.currency_bar()
	var idx := _chips.get_index()
	var parent := _chips.get_parent()
	parent.add_child(fresh)
	parent.move_child(fresh, idx)
	parent.remove_child(_chips)
	_chips.queue_free()
	_chips = fresh
	_set_status()

	var s: Shop = Game.shop
	# Featured: starter pack (one time) and Golden Pass.
	_list.add_child(_header("shop.section_featured"))
	_list.add_child(_product_card("starter_pack", true))
	_list.add_child(_product_card(Shop.GOLDEN_PASS, true))

	# Capsules card: filled in by the Capsules screen owner; shown only when that screen exists.
	_build_capsules_slot()

	_list.add_child(_header("shop.section_gems"))
	for p in s.gem_packs():
		_list.add_child(_product_card(str(p["id"])))

	var item_box := _gem_items()
	if item_box != null:
		_list.add_child(_header("shop.section_gem_items"))
		_list.add_child(item_box)

	_list.add_child(_header("shop.section_skins"))
	for p in s.skins():
		_list.add_child(_product_card(str(p["id"])))

	_list.add_child(_header("shop.section_free"))
	_build_free_items()

	restore_button = UI.button(Game.t("shop.restore"), "ghost", Vector2(0, 56), 20)
	restore_button.name = "restore"
	restore_button.disabled = _restore_wait
	restore_button.pressed.connect(restore_purchases)
	_list.add_child(restore_button)


func _header(key: String) -> Label:
	return UI.label(Game.t(key), 22, UI.TEAL)


## Hook for the Time Capsules card (spec 7.4): only when the 'capsules' screen is registered.
func _build_capsules_slot() -> void:
	if Game.nav == null or not Game.nav.can_go("capsules"):
		return
	var p := UI.panel()
	p.name = "capsules_card"
	capsules_card = p
	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", 6)
	p.add_child(v)
	v.add_child(UI.label(Game.t("shop.capsules_title"), 22))
	v.add_child(UI.label(Game.t("shop.capsules_desc"), 15, UI.LOCKED_INK))
	capsules_button = UI.button(Game.t("shop.capsules_open"), "teal", Vector2(0, 56), 20)
	capsules_button.name = "capsules_open"
	capsules_button.pressed.connect(func(): Game.nav.go("capsules", {"from": "shop"}))
	v.add_child(capsules_button)
	_list.add_child(p)


func _product_card(product_id: String, featured := false) -> Control:
	var s: Shop = Game.shop
	var def := s.product(product_id)
	var p := UI.panel(Color("FFF0C9") if featured else UI.PANEL)
	p.name = "card_" + product_id
	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", 6)
	p.add_child(v)
	v.add_child(UI.label(Game.t(str(def.get("name_key", ""))), 22))
	v.add_child(UI.label(Game.t(str(def.get("desc_key", ""))), 15, UI.LOCKED_INK))
	if product_id == Shop.GOLDEN_PASS:
		v.add_child(UI.label(Game.t("product.golden_pass.extra", [int(DataDB.bal_f("offline.golden_pass_bonus_hours"))]), 15, UI.LOCKED_INK))
		v.add_child(UI.label(Game.t("shop.no_ads_note"), 14, UI.LOCKED_INK))
	if s.is_one_time(product_id):
		v.add_child(UI.label(Game.t("shop.one_time"), 14, UI.RED))
	var b: Button
	if s.owns(product_id):
		b = UI.button(Game.t("shop.purchased"), "off", Vector2(0, 56), 20)
		b.disabled = true
	elif s.pending.has(product_id):
		b = UI.button(Game.t("shop.purchase_pending"), "off", Vector2(0, 56), 20)
		b.disabled = true
	else:
		b = UI.button(Game.t("shop.buy", [s.price_text(product_id)]), "primary", Vector2(0, 56), 20)
		b.pressed.connect(buy.bind(product_id))
	b.name = "buy_" + product_id
	buy_buttons[product_id] = b
	v.add_child(b)
	return p


func _gem_items() -> Control:
	var s: Shop = Game.shop
	var box: VBoxContainer = null
	for it in DataDB.shop().get("gem_items", []):
		var id := str(it["id"])
		if not s.gem_item_available(id):
			continue
		if box == null:
			box = VBoxContainer.new()
			box.add_theme_constant_override("separation", 8)
		var p := UI.panel()
		p.name = "gem_item_" + id
		var v := VBoxContainer.new()
		v.add_theme_constant_override("separation", 6)
		p.add_child(v)
		v.add_child(UI.label(Game.t(str(it["name_key"])), 20))
		var b := UI.button(Game.t("shop.gem_price", [s.gem_item_price(id)]), "teal", Vector2(0, 56), 20)
		b.name = "buy_" + id
		b.disabled = not Game.economy.can_afford("gems", s.gem_item_price(id))
		b.pressed.connect(buy_gem_item.bind(id))
		gem_item_buttons[id] = b
		v.add_child(b)
		box.add_child(p)
	return box


func _build_free_items() -> void:
	var now := _now()
	var gems := DataDB.bal_i("daily.login_gems", 10)
	var p := UI.panel()
	p.name = "free_daily"
	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", 6)
	p.add_child(v)
	v.add_child(UI.label(Game.t("shop.daily_gift", [gems]), 20))
	var can_daily: bool = Game.economy.can_claim_daily(now)
	daily_button = UI.button(Game.t("shop.claim") if can_daily else Game.t("shop.daily_done"), "teal" if can_daily else "off", Vector2(0, 56), 20)
	daily_button.name = "daily_claim"
	daily_button.disabled = not can_daily
	daily_button.pressed.connect(claim_daily)
	v.add_child(daily_button)
	_list.add_child(p)

	var bp := UI.panel()
	bp.name = "free_bonus"
	var bv := VBoxContainer.new()
	bv.add_theme_constant_override("separation", 6)
	bp.add_child(bv)
	var count := DataDB.bal_i("ads.bonus_capsule_count", 1)
	var auto: bool = Game.shop.ads_removed()
	var avail: bool = Game.quests.bonus_capsule_available(now)
	if auto:
		bonus_button = UI.button(Game.t("shop.bonus_capsule_auto", [count]) if avail else Game.t("daily.bonus_used"), "teal" if avail else "off", Vector2(0, 56), 18)
		bonus_button.disabled = not avail
	else:
		bonus_button = MetaUI.ad_button("bonus_capsule", Game.t("ads.bonus_capsule.desc", [count]))
		if not avail:
			MetaUI.refresh_ad_button(bonus_button, "bonus_capsule", "", Game.t("daily.bonus_used"))
	bonus_button.name = "bonus_capsule"
	bonus_button.pressed.connect(claim_bonus_capsule)
	bv.add_child(bonus_button)
	_list.add_child(bp)
