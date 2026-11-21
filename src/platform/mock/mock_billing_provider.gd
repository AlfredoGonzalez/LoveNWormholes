class_name MockBillingProvider
extends BillingProvider
## Editor/test billing provider with Play-Billing-like semantics: a purchase stays "unacknowledged" until
## acknowledge(token) is called, and is re-delivered by redeliver_unacknowledged() (what a restart does).

var initialized := false
var next_token := 1
var unacked := {}                 # token -> product_id
var owned_non_consumables: Array = []   # returned by restore()
var non_consumable_ids: Array = []      # which ids behave as non-consumable (added to owned on purchase)
var force_fail := false
var fail_reason := "user_cancelled"
var manual := false               # purchase() waits; the test calls complete_purchase()
var block_ack := false            # simulate the app being killed before acknowledge
var acknowledged: Array = []
var purchase_calls := {}
var restore_calls := 0
var pending_product := ""

func initialize() -> void:
	initialized = true

func purchase(product_id: String) -> void:
	purchase_calls[product_id] = purchase_calls.get(product_id, 0) + 1
	if force_fail:
		failed.emit(product_id, fail_reason)
		return
	if manual:
		pending_product = product_id
		failed.emit(product_id, "pending")
		return
	complete_purchase(product_id)

func complete_purchase(product_id: String) -> String:
	var token := "mock_token_%d" % next_token
	next_token += 1
	unacked[token] = product_id
	if non_consumable_ids.has(product_id) and not owned_non_consumables.has(product_id):
		owned_non_consumables.append(product_id)
	purchased.emit(product_id, token)
	return token

## What the store does on next start for purchases that were never acknowledged.
func redeliver_unacknowledged() -> void:
	for token in unacked.keys():
		purchased.emit(unacked[token], token)

func restore() -> void:
	restore_calls += 1
	restored.emit(owned_non_consumables.duplicate())

func acknowledge(token: String) -> void:
	if block_ack:
		return
	unacked.erase(token)
	acknowledged.append(token)

func local_price(product_id: String) -> String:
	return "$0.99"
