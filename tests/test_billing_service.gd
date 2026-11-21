extends TestCase

const P := "user://t_bill.json"
const PRODUCTS := {
	"gems_80": {"type": "consumable", "grants": {"gems": 80}},
	"starter_pack": {"type": "non_consumable", "grants": {"gems": 300, "capsules": 3}},
	"golden_pass": {"type": "non_consumable", "grants": {}},
}

func _clean() -> void:
	for p in [P, "user://t_bill.bak.json", P + ".tmp", "user://t_bill_copy.json"]:
		if FileAccess.file_exists(p):
			DirAccess.remove_absolute(p)

class Rig:
	var provider: MockBillingProvider
	var save: SaveService
	var billing: BillingService
	var eco: Economy
	var grants: Array = []

func _rig(provider: MockBillingProvider = null, fresh := true) -> Rig:
	if fresh:
		_clean()
	var r := Rig.new()
	r.provider = provider if provider != null else MockBillingProvider.new()
	r.provider.non_consumable_ids = ["starter_pack", "golden_pass"]
	r.save = SaveService.new(P)
	r.save.load_profile()
	r.eco = Economy.new({}, r.save)
	r.billing = BillingService.new(r.provider, r.save, PRODUCTS)
	var grants := r.grants   # capture pieces, not the rig (avoids a reference cycle)
	var eco := r.eco
	r.billing.purchase_granted.connect(func(pid, tok, g):
		grants.append([pid, tok])
		eco.add_bundle(g, false))   # listener mutates the profile; the service saves
	return r

func test_consumable_granted_once() -> void:
	var r := _rig()
	r.billing.start()
	assert_true(r.billing.purchase("gems_80"))
	assert_eq(r.grants.size(), 1)
	assert_eq(r.eco.get_amount("gems"), 80)
	assert_eq(r.provider.acknowledged.size(), 1)
	assert_eq(r.save.profile["purchases_granted"].size(), 1)
	assert_true(not r.billing.owns("gems_80"), "consumables are not owned")
	assert_true(r.billing.purchase("gems_80"), "can buy again")
	assert_eq(r.eco.get_amount("gems"), 160)
	_clean()

func test_kill_before_ack_redelivery_grants_once() -> void:
	var r := _rig()
	r.provider.block_ack = true   # app killed before acknowledge
	r.billing.purchase("gems_80")
	assert_eq(r.eco.get_amount("gems"), 80)
	assert_eq(r.provider.unacked.size(), 1)
	r.billing.shutdown()
	# restart: same store state, profile reloaded from disk
	r.provider.block_ack = false
	var r2 := _rig(r.provider, false)
	r2.billing.start()
	r.provider.redeliver_unacknowledged()
	assert_eq(r2.grants.size(), 0, "token already granted: no second grant")
	assert_eq(r2.eco.get_amount("gems"), 80)
	assert_eq(r2.provider.unacked.size(), 0, "now acknowledged")
	r2.provider.redeliver_unacknowledged()
	assert_eq(r2.eco.get_amount("gems"), 80)
	_clean()

func test_kill_before_persist_grants_after_redelivery() -> void:
	# Kill before the save: the purchase was never persisted, the store still holds it unacknowledged.
	var r := _rig()
	r.provider.unacked["tok_x"] = "gems_80"
	r.billing.shutdown()
	var r2 := _rig(r.provider, false)
	r2.billing.start()
	r.provider.redeliver_unacknowledged()
	assert_eq(r2.grants.size(), 1)
	assert_eq(r2.eco.get_amount("gems"), 80)
	assert_eq(r2.provider.unacked.size(), 0)
	r.provider.redeliver_unacknowledged()
	assert_eq(r2.eco.get_amount("gems"), 80)
	_clean()

func test_non_consumable_and_restore_idempotent() -> void:
	var r := _rig()
	r.billing.start()
	assert_true(r.billing.purchase("starter_pack"))
	assert_true(r.billing.owns("starter_pack"))
	assert_eq(r.eco.get_amount("gems"), 300)
	assert_eq(r.eco.get_amount("capsules"), 3)
	assert_true(not r.billing.purchase("starter_pack"), "already owned")
	r.billing.restore()
	r.billing.restore()
	assert_eq(r.eco.get_amount("gems"), 300, "restore does not re-grant owned products")
	assert_eq(r.grants.size(), 1)
	_clean()

func test_restore_on_fresh_install_idempotent() -> void:
	var prov := MockBillingProvider.new()
	prov.owned_non_consumables = ["golden_pass", "unknown_item"]
	var r := _rig(prov)
	var restored := []
	r.billing.restore_finished.connect(func(n): restored.append(n))
	r.billing.start()
	assert_true(r.billing.owns("golden_pass"))
	assert_true(not r.billing.owns("unknown_item"))
	assert_eq(restored[0], ["golden_pass"])
	r.billing.restore()
	assert_eq(restored[1], [])
	r.billing.shutdown()
	var r2 := _rig(prov, false)   # restart
	r2.billing.start()
	assert_true(r2.billing.owns("golden_pass"))
	assert_eq(r2.grants.size(), 0)
	_clean()

func test_failure_and_pending() -> void:
	var r := _rig()
	var failed := []
	var pending := []
	r.billing.purchase_failed.connect(func(p, why): failed.append([p, why]))
	r.billing.purchase_pending.connect(func(p): pending.append(p))
	r.provider.force_fail = true
	r.billing.purchase("gems_80")
	assert_eq(failed, [["gems_80", "user_cancelled"]])
	r.provider.force_fail = false
	r.provider.manual = true
	r.billing.purchase("gems_80")
	assert_eq(pending, ["gems_80"])
	assert_eq(r.eco.get_amount("gems"), 0, "nothing granted while pending")
	r.provider.complete_purchase("gems_80")   # the pending purchase later completes
	assert_eq(r.eco.get_amount("gems"), 80)
	assert_true(not r.billing.purchase("unknown"), "unknown product rejected")
	_clean()
