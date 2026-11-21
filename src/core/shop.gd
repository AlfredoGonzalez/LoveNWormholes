class_name Shop
extends RefCounted
## Shop logic (spec 7.3, 9.1): what is on sale, localized prices, applying purchased contents, entitlements and
## the Gem items. UI-free; ShopScreen only calls this and listens to `changed`.
##
## Purchases go through BillingService (token granted once, persisted, then acknowledged). This class is the
## listener of `BillingService.purchase_granted`: it adds the contents to the same profile, BEFORE the service
## saves, so grant + token + ownership reach the disk in one write.
##
## "Remove ads": the game has no banners/interstitials, so nothing is "removed". The Golden Pass is the entitlement:
## rewarded-ad bonuses apply without watching (ad buttons are replaced by direct claims) and the Worm Farm cap
## gets +balance.offline.golden_pass_bonus_hours. Everything else stays free (spec R11, 7.3).

signal changed
signal purchase_error(product_id: String, kind: String)   # kind: "cancelled" | "network" | "failed"

const GOLDEN_PASS := "golden_pass"
const PRESET_ITEM := "squad_preset_slot"
const NETWORK_REASONS := ["network_error", "service_unavailable", "service_disconnected", "timeout", "offline"]
const CANCEL_REASONS := ["user_cancelled", "cancelled", "canceled"]

var billing: BillingService
var economy: Economy
var save_service: SaveService
var data: Dictionary
var pending := {}          # product id -> true while the store reports the purchase as pending
var _connected := false


func _init(p_billing: BillingService, p_economy: Economy, p_save: SaveService, p_data: Dictionary = {}) -> void:
	billing = p_billing
	economy = p_economy
	save_service = p_save
	data = p_data if not p_data.is_empty() else DataDB.shop()
	billing.purchase_granted.connect(_on_granted)
	billing.purchase_failed.connect(_on_failed)
	billing.purchase_pending.connect(_on_pending)
	billing.purchase_refunded.connect(_on_refunded)
	billing.restore_finished.connect(_on_restore_finished)
	_connected = true


func shutdown() -> void:
	if _connected:
		billing.purchase_granted.disconnect(_on_granted)
		billing.purchase_failed.disconnect(_on_failed)
		billing.purchase_pending.disconnect(_on_pending)
		billing.purchase_refunded.disconnect(_on_refunded)
		billing.restore_finished.disconnect(_on_restore_finished)
		_connected = false


var profile: Dictionary:
	get: return save_service.profile


# ---------------------------------------------------------------- catalog

func product(product_id: String) -> Dictionary:
	for p in data.get("products", []):
		if str(p["id"]) == product_id:
			return p
	return {}


func products_by_prefix(prefix: String) -> Array:
	var out: Array = []
	for p in data.get("products", []):
		if str(p["id"]).begins_with(prefix):
			out.append(p)
	return out


func gem_packs() -> Array:
	return products_by_prefix("gems_")


func skins() -> Array:
	return products_by_prefix("skin_")


func is_one_time(product_id: String) -> bool:
	return bool(product(product_id).get("one_time", false))


## One-time and non-consumable products show as owned once bought.
func owns(product_id: String) -> bool:
	return billing.owns(product_id)


func can_buy(product_id: String) -> bool:
	return not product(product_id).is_empty() and not pending.has(product_id) and not owns(product_id)


## Price text: the store's localized price when the provider has one, else the USD reference tier of shop.json.
func price_text(product_id: String) -> String:
	var local := billing.local_price(product_id)
	if local != "":
		return local
	return fallback_price(product_id)


func fallback_price(product_id: String) -> String:
	var usd := float(product(product_id).get("price_usd", 0.0))
	return "$%.2f" % usd if usd > 0.0 else ""


# ---------------------------------------------------------------- buying

## Starts a purchase. False when it is not allowed (unknown, owned non-consumable, already pending).
func buy(product_id: String) -> bool:
	if not can_buy(product_id):
		return false
	var ok := billing.purchase(product_id)
	if ok:
		changed.emit()
	return ok


func restore() -> void:
	billing.restore()


func _on_granted(product_id: String, _token: String, grants: Dictionary) -> void:
	pending.erase(product_id)
	apply_grants(grants)
	changed.emit()


## Adds the contents of a product. Currencies via Economy (no save: the BillingService saves right after);
## cosmetics, skins and entitlements are unique lists in the profile (adding twice changes nothing).
func apply_grants(grants: Dictionary) -> void:
	economy.add_bundle(grants, false)
	for key in ["cosmetics", "skins", "entitlements"]:
		if not grants.has(key):
			continue
		if typeof(profile.get(key)) != TYPE_ARRAY:
			profile[key] = []
		for id in grants[key]:
			if not (profile[key] as Array).has(id):
				(profile[key] as Array).append(id)


func _on_failed(product_id: String, reason: String) -> void:
	pending.erase(product_id)
	var kind := "failed"
	if reason in CANCEL_REASONS:
		kind = "cancelled"
	elif reason in NETWORK_REASONS:
		kind = "network"
	purchase_error.emit(product_id, kind)
	changed.emit()


func _on_pending(product_id: String) -> void:
	pending[product_id] = true
	changed.emit()


func _on_refunded(_product_id: String) -> void:
	changed.emit()


func _on_restore_finished(_newly: Array) -> void:
	changed.emit()


# ---------------------------------------------------------------- entitlements

## Golden Pass = the "remove ads" entitlement of this game (see the class comment).
func golden_pass_active() -> bool:
	return billing.owns(GOLDEN_PASS)


func ads_removed() -> bool:
	return golden_pass_active()


func offline_extra_hours() -> float:
	return DataDB.bal_f("offline.golden_pass_bonus_hours") if golden_pass_active() else 0.0


# ---------------------------------------------------------------- Gem items (soft currency)

func gem_item(item_id: String) -> Dictionary:
	for it in data.get("gem_items", []):
		if str(it["id"]) == item_id:
			return it
	return {}


func gem_item_price(item_id: String) -> int:
	return int(gem_item(item_id).get("gems", 0))


## Whether the item can still be bought (the preset slot stops at squad.presets_max).
func gem_item_available(item_id: String) -> bool:
	if gem_item(item_id).is_empty():
		return false
	if item_id == PRESET_ITEM:
		return Squad.preset_count(profile) < Squad.preset_max()
	return false


## Buys a Gem item. Gems never buy Coins or stats: the only item is the extra squad preset slot (spec 7.3).
## Returns {ok, reason}; reason is "unknown" | "unavailable" | "not_enough_gems" | "".
func buy_gem_item(item_id: String) -> Dictionary:
	if gem_item(item_id).is_empty():
		return {"ok": false, "reason": "unknown"}
	if not gem_item_available(item_id):
		return {"ok": false, "reason": "unavailable"}
	if not economy.can_afford("gems", gem_item_price(item_id)):
		return {"ok": false, "reason": "not_enough_gems"}
	var count := Squad.preset_count(profile)
	economy.spend("gems", gem_item_price(item_id), false)
	var lo: Dictionary = profile["loadout"]
	var presets: Array = lo.get("squad_presets", [])
	while presets.size() <= count:
		presets.append([])
	lo["squad_presets"] = presets
	save_service.save()
	changed.emit()
	return {"ok": true, "reason": ""}
