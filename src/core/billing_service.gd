class_name BillingService
extends RefCounted
## In-app purchases (spec 7.3). Each purchase token is granted exactly once:
## the token (and, for non-consumables, the owned product) is recorded in the profile, the listeners of
## `purchase_granted` apply the contents to the same profile, and only then is the profile saved and the
## purchase acknowledged. A kill before the save means nothing was persisted and the store re-delivers the
## unacknowledged purchase on the next start; a kill after the save but before the ack re-delivers a token that
## is already recorded, which is only acknowledged (never granted twice).
##
## `products`: product id -> {"type": "consumable" | "non_consumable", "grants": {coins, gems, capsules, ...}}.

signal purchase_granted(product_id: String, token: String, grants: Dictionary)
signal purchase_failed(product_id: String, reason: String)
signal purchase_pending(product_id: String)
signal restore_finished(newly_owned: Array)
signal purchase_refunded(product_id: String)

const RESTORE_TOKEN_PREFIX := "restored:"

var provider: BillingProvider
var save_service: SaveService
var products: Dictionary
var analytics: AnalyticsService
var _connected := false

func _init(p_provider: BillingProvider, p_save: SaveService, p_products: Dictionary,
		p_analytics: AnalyticsService = null) -> void:
	provider = p_provider
	save_service = p_save
	products = p_products
	analytics = p_analytics
	provider.purchased.connect(_on_purchased)
	provider.failed.connect(_on_failed)
	provider.restored.connect(_on_restored)
	provider.refunded.connect(_on_refunded)
	_connected = true

func shutdown() -> void:
	if _connected:
		provider.purchased.disconnect(_on_purchased)
		provider.failed.disconnect(_on_failed)
		provider.restored.disconnect(_on_restored)
		provider.refunded.disconnect(_on_refunded)
		_connected = false

## On app start: initialize the store (which re-delivers unacknowledged purchases) and restore.
func start() -> void:
	provider.initialize()
	provider.restore()

func purchase(product_id: String) -> bool:
	if not products.has(product_id) or (is_non_consumable(product_id) and owns(product_id)):
		return false
	if analytics != null:
		analytics.iap_view(product_id)   # the player opened the purchase flow for this product
	provider.purchase(product_id)
	return true

func restore() -> void:
	provider.restore()

func is_non_consumable(product_id: String) -> bool:
	return products.get(product_id, {}).get("type", "consumable") == "non_consumable"

func owns(product_id: String) -> bool:
	return save_service.profile["owned_products"].has(product_id)

func local_price(product_id: String) -> String:
	return provider.local_price(product_id)

func _on_purchased(product_id: String, token: String) -> void:
	if not products.has(product_id):
		return   # unknown product: neither granted nor acknowledged
	var p := save_service.profile
	if p["purchases_granted"].has(token):
		provider.acknowledge(token)   # already granted before a kill/restart: just finish the handshake
		return
	_grant(product_id, token)
	save_service.save()   # persisted before acknowledge
	provider.acknowledge(token)

func _grant(product_id: String, token: String) -> void:
	var p := save_service.profile
	p["purchases_granted"].append(token)
	if is_non_consumable(product_id) and not p["owned_products"].has(product_id):
		p["owned_products"].append(product_id)
	if analytics != null:
		analytics.log_event("iap_purchase", {"product": product_id})
	purchase_granted.emit(product_id, token, products[product_id].get("grants", {}))

func _on_failed(product_id: String, reason: String) -> void:
	if reason == "pending":
		purchase_pending.emit(product_id)
	else:
		purchase_failed.emit(product_id, reason)

func _on_restored(owned: Array) -> void:
	var newly: Array = []
	for product_id in owned:
		if not products.has(product_id) or not is_non_consumable(product_id) or owns(product_id):
			continue
		var token: String = RESTORE_TOKEN_PREFIX + product_id
		if save_service.profile["purchases_granted"].has(token):
			continue
		_grant(product_id, token)
		newly.append(product_id)
	if not newly.is_empty():
		save_service.save()
	restore_finished.emit(newly)

## A refunded non-consumable is no longer owned (entitlements such as the Golden Pass switch off). Currency that was
## already granted stays (never clawed back), and the granted tokens are kept so a re-delivery cannot grant it twice.
func _on_refunded(product_id: String) -> void:
	if not products.has(product_id) or not is_non_consumable(product_id) or not owns(product_id):
		return
	save_service.profile["owned_products"].erase(product_id)
	save_service.save()
	purchase_refunded.emit(product_id)
