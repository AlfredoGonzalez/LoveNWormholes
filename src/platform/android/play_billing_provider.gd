class_name PlayBillingProvider
extends BillingProvider
## Google Play Billing through the official Godot Google Play Billing addon (GDScript class `BillingClient`,
## plugin singleton "GodotGooglePlayBilling", Godot 4.2+). Not referenced statically: AddonBridge finds the class
## by name at runtime, so the project compiles and runs headless without the addon.
##
## STATUS: follows the addon's documented API (start_connection, query_product_details, query_purchases,
## purchase, acknowledge_purchase, consume_purchase and the *_response / on_purchase_updated signals) but could
## not be run in the build sandbox. Verify with a Play licensed tester on an internal test track (docs/ANDROID.md).
## Without the addon every purchase fails with "billing_unavailable"; it never grants anything.
##
## Contract (BillingProvider): `purchased(product, token)` fires for every PURCHASED purchase that is not yet
## acknowledged/consumed, now and after each restart (BillingService grants each token once, then calls
## acknowledge(), which here consumes consumables and acknowledges non-consumables).

const PURCHASED := 1
const RESPONSE_OK := 0
const RESPONSE_USER_CANCELED := 1

var host: Node                      # the client is a Node; it must live in the tree
var product_ids: Array = []
var consumable_ids: Array = []
var _client = null
var _connected := false
var _token_product := {}            # token -> product id (to pick consume vs acknowledge)
var _prices := {}                   # product id -> formatted price
var _restore_pending := false


func is_supported() -> bool:
	return AddonBridge.has_addon_class("BillingClient")


## Frees the client node (Game re-boots after "Delete my local data").
func dispose() -> void:
	if _client != null and is_instance_valid(_client):
		_client.queue_free()
	_client = null
	_connected = false


func configure(p_product_ids: Array, p_consumable_ids: Array) -> void:
	product_ids = p_product_ids
	consumable_ids = p_consumable_ids


func initialize() -> void:
	if _client != null or not is_supported() or host == null:
		return
	_client = AddonBridge.make("BillingClient")
	host.add_child(_client)
	_client.connect("connected", _on_connected)
	_client.connect("disconnected", func(): _connected = false)
	_client.connect("connect_error", func(_code, _msg): _connected = false)
	_client.connect("query_product_details_response", _on_details)
	_client.connect("query_purchases_response", _on_purchases)
	_client.connect("on_purchase_updated", _on_purchase_updated)
	_client.call("start_connection")


func _on_connected() -> void:
	_connected = true
	if not product_ids.is_empty():
		_client.call("query_product_details", product_ids, "inapp")
	_client.call("query_purchases", "inapp")   # re-delivers unacknowledged purchases after a restart


func purchase(product_id: String) -> void:
	if _client == null or not _connected:
		failed.emit(product_id, "billing_unavailable")
		return
	_client.call("purchase", [product_id])


func restore() -> void:
	if _client == null or not _connected:
		restored.emit([])
		return
	_restore_pending = true
	_client.call("query_purchases", "inapp")


func acknowledge(token: String) -> void:
	if _client == null:
		return
	if consumable_ids.has(_token_product.get(token, "")):
		_client.call("consume_purchase", token)   # consuming also acknowledges
	else:
		_client.call("acknowledge_purchase", token)


func local_price(product_id: String) -> String:
	return str(_prices.get(product_id, ""))


func _on_details(response: Dictionary) -> void:
	if int(response.get("response_code", -1)) != RESPONSE_OK:
		return
	for d in response.get("product_details", response.get("product_details_list", [])):
		var offer = d.get("one_time_purchase_offer_details", {})
		_prices[str(d.get("product_id", ""))] = str(offer.get("formatted_price", "")) if typeof(offer) == TYPE_DICTIONARY else ""


func _on_purchases(response: Dictionary) -> void:
	var owned: Array = []
	for pur in response.get("purchases", []):
		if int(pur.get("purchase_state", 0)) != PURCHASED:
			continue
		var token := str(pur.get("purchase_token", ""))
		for pid in pur.get("product_ids", pur.get("products", [])):
			_token_product[token] = str(pid)
			if not consumable_ids.has(str(pid)):
				owned.append(str(pid))
			if not bool(pur.get("is_acknowledged", false)):
				purchased.emit(str(pid), token)
	if _restore_pending:
		_restore_pending = false
		restored.emit(owned)


func _on_purchase_updated(response: Dictionary) -> void:
	var code := int(response.get("response_code", -1))
	if code != RESPONSE_OK:
		var pid := str(product_ids[0]) if product_ids.size() == 1 else ""
		failed.emit(pid, "user_cancelled" if code == RESPONSE_USER_CANCELED else "error_%d" % code)
		return
	_on_purchases(response)
