extends TestCase
## Shop logic (Shop) over BillingService + MockBillingProvider, plus the ShopScreen with an isolated profile.

const P := "user://t_shop.json"


func _clean() -> void:
	for p in [P, "user://t_shop.bak.json", P + ".tmp"]:
		if FileAccess.file_exists(p):
			DirAccess.remove_absolute(p)


class Rig:
	var provider: MockBillingProvider
	var save: SaveService
	var billing: BillingService
	var eco: Economy
	var shop: Shop


func _products() -> Dictionary:
	var out := {}
	for pr in DataDB.shop().get("products", []):
		out[str(pr["id"])] = {"type": str(pr["type"]), "grants": pr.get("contents", {})}
	return out


func _rig(provider: MockBillingProvider = null, fresh := true) -> Rig:
	if fresh:
		_clean()
	var r := Rig.new()
	r.provider = provider if provider != null else MockBillingProvider.new()
	for pr in DataDB.shop()["products"]:
		if pr["type"] == "non_consumable":
			r.provider.non_consumable_ids.append(pr["id"])
	r.save = SaveService.new(P)
	r.save.load_profile()
	r.eco = Economy.new(DataDB.balance(), r.save)
	r.billing = BillingService.new(r.provider, r.save, _products())
	r.shop = Shop.new(r.billing, r.eco, r.save)
	return r


func _drop(r: Rig) -> void:
	r.shop.shutdown()
	r.billing.shutdown()
	_clean()


func test_consumable_grant_and_persist() -> void:
	var r := _rig()
	r.billing.start()
	assert_true(r.shop.buy("gems_450"))
	assert_eq(r.eco.get_amount("gems"), 450)
	var disk := SaveService.new(P)
	disk.load_profile()
	assert_eq(disk.profile["currencies"]["gems"], 450, "persisted by the billing save")
	assert_eq(disk.profile["purchases_granted"].size(), 1)
	_drop(r)


func test_grant_idempotent_on_redelivery() -> void:
	var r := _rig()
	r.provider.block_ack = true   # killed before the acknowledge
	r.shop.buy("gems_80")
	assert_eq(r.eco.get_amount("gems"), 80)
	r.provider.redeliver_unacknowledged()
	r.provider.redeliver_unacknowledged()
	assert_eq(r.eco.get_amount("gems"), 80, "same token never grants twice")
	# full restart: reload the profile from disk and re-deliver again
	r.shop.shutdown()
	r.billing.shutdown()
	var r2 := _rig(r.provider, false)
	r2.provider.block_ack = false
	r2.billing.start()
	r2.provider.redeliver_unacknowledged()
	assert_eq(r2.eco.get_amount("gems"), 80, "still 80 after restart")
	assert_eq(r2.provider.unacked.size(), 0, "acknowledged at last")
	_drop(r2)


func test_starter_pack_contents_and_one_time() -> void:
	var r := _rig()
	assert_true(r.shop.can_buy("starter_pack"))
	assert_true(r.shop.buy("starter_pack"))
	assert_eq(r.eco.get_amount("gems"), 300)
	assert_eq(r.eco.get_amount("capsules"), 3)
	assert_true(r.save.profile["cosmetics"].has("starter_cap"))
	assert_true(r.shop.owns("starter_pack"))
	assert_true(not r.shop.can_buy("starter_pack"))
	assert_true(not r.shop.buy("starter_pack"), "one time only")
	assert_eq(r.eco.get_amount("gems"), 300)
	_drop(r)


func test_restore_grants_owned_once() -> void:
	var r := _rig()
	r.provider.owned_non_consumables = ["golden_pass", "skin_pirate"]
	r.shop.restore()
	assert_true(r.shop.golden_pass_active())
	assert_true(r.shop.owns("skin_pirate"))
	assert_true(r.save.profile["skins"].has("pirate"))
	assert_true(r.save.profile["cosmetics"].has("golden_cap"))
	var n: int = r.save.profile["purchases_granted"].size()
	r.shop.restore()
	assert_eq(r.save.profile["purchases_granted"].size(), n, "second restore grants nothing")
	assert_eq((r.save.profile["skins"] as Array).size(), 1)
	_drop(r)


func test_pending_then_complete_and_recovery() -> void:
	var r := _rig()
	r.provider.manual = true
	assert_true(r.shop.buy("gems_1000"))
	assert_true(r.shop.pending.has("gems_1000"))
	assert_eq(r.eco.get_amount("gems"), 0, "nothing granted while pending")
	assert_true(not r.shop.buy("gems_1000"), "no double purchase while pending")
	r.provider.complete_purchase("gems_1000")
	assert_true(not r.shop.pending.has("gems_1000"))
	assert_eq(r.eco.get_amount("gems"), 1000)
	_drop(r)


func test_pending_recovered_after_close() -> void:
	var r := _rig()
	r.provider.block_ack = true
	r.provider.manual = true
	r.shop.buy("gems_450")
	r.provider.complete_purchase("gems_450")   # completed outside the app
	r.shop.shutdown()
	r.billing.shutdown()
	# the app was closed before the save; restart with a fresh profile on disk
	_clean()
	var r2 := _rig(r.provider, false)
	r2.save.profile = r2.save.default_profile()
	r2.provider.block_ack = false
	r2.billing.start()
	r2.provider.redeliver_unacknowledged()
	assert_eq(r2.eco.get_amount("gems"), 450)
	_drop(r2)


func test_cancel_and_network_errors() -> void:
	var r := _rig()
	var kinds: Array = []
	r.shop.purchase_error.connect(func(_p, k): kinds.append(k))
	r.provider.force_fail = true
	r.provider.fail_reason = "user_cancelled"
	r.shop.buy("gems_80")
	r.provider.fail_reason = "network_error"
	r.shop.buy("gems_80")
	r.provider.fail_reason = "billing_unavailable"
	r.shop.buy("gems_80")
	assert_eq(kinds, ["cancelled", "network", "failed"])
	assert_eq(r.eco.get_amount("gems"), 0)
	assert_true(r.shop.can_buy("gems_80"), "can retry")
	_drop(r)


func test_golden_pass_entitlement_and_refund() -> void:
	var r := _rig()
	assert_true(not r.shop.ads_removed())
	assert_eq(r.shop.offline_extra_hours(), 0.0)
	r.shop.buy("golden_pass")
	assert_true(r.shop.ads_removed())
	assert_eq(r.shop.offline_extra_hours(), DataDB.bal_f("offline.golden_pass_bonus_hours"))
	assert_true(r.save.profile["owned_products"].has("golden_pass"))
	r.provider.refund("golden_pass")
	assert_true(not r.shop.golden_pass_active(), "refund switches the entitlement off")
	var disk := SaveService.new(P)
	disk.load_profile()
	assert_true(not disk.profile["owned_products"].has("golden_pass"))
	# refund of an unowned/consumable product changes nothing
	r.provider.refund("gems_80")
	_drop(r)


func test_price_fallback_and_localized() -> void:
	var r := _rig()
	assert_eq(r.shop.price_text("gems_80"), "$0.99", "fallback from shop.json")
	assert_eq(r.shop.price_text("gems_2200"), "$19.99")
	assert_eq(r.shop.price_text("nope"), "")
	r.provider.prices["gems_80"] = "MX$19.00"
	assert_eq(r.shop.price_text("gems_80"), "MX$19.00", "store price wins")
	assert_eq(r.shop.price_text("gems_450"), "$4.99")
	_drop(r)


func test_gem_item_preset_slot() -> void:
	var r := _rig()
	var price := r.shop.gem_item_price(Shop.PRESET_ITEM)
	assert_true(price > 0)
	assert_eq(r.shop.buy_gem_item(Shop.PRESET_ITEM)["reason"], "not_enough_gems")
	r.eco.add("gems", price + 5)
	var before := Squad.preset_count(r.save.profile)
	var res := r.shop.buy_gem_item(Shop.PRESET_ITEM)
	assert_true(res["ok"])
	assert_eq(Squad.preset_count(r.save.profile), before + 1)
	assert_eq(r.eco.get_amount("gems"), 5)
	r.eco.add("gems", 10000)
	while r.shop.gem_item_available(Shop.PRESET_ITEM):
		r.shop.buy_gem_item(Shop.PRESET_ITEM)
	assert_eq(Squad.preset_count(r.save.profile), Squad.preset_max())
	assert_eq(r.shop.buy_gem_item(Shop.PRESET_ITEM)["reason"], "unavailable")
	assert_eq(r.shop.buy_gem_item("coins_for_gems")["reason"], "unknown")
	_drop(r)


# ---------------------------------------------------------------- screen

class RecNav extends Navigator:
	var calls: Array = []
	var capsules := false
	func can_go(n: String) -> bool:
		return n != "capsules" or capsules
	func go(screen_name: String, p: Dictionary = {}) -> bool:
		calls.append([screen_name, p])
		return true


func _g():
	var ml := Engine.get_main_loop()
	if ml == null or not (ml is SceneTree) or (ml as SceneTree).root == null:
		return null
	return (ml as SceneTree).root.get_node_or_null("Game")


func _screen(nav: RecNav) -> ShopScreen:
	var g = _g()
	for p in ["user://test_shop_screen.json", "user://test_shop_screen.bak.json", "user://test_shop_screen.json.tmp"]:
		if FileAccess.file_exists(p):
			DirAccess.remove_absolute(p)
	g.boot("user://test_shop_screen.json")
	g.nav = nav
	var s := ShopScreen.new()
	s.setup({})
	Engine.get_main_loop().root.add_child(s)
	return s


func _end(s: ShopScreen) -> void:
	s.get_parent().remove_child(s)
	s.free()
	for p in ["user://test_shop_screen.json", "user://test_shop_screen.bak.json", "user://test_shop_screen.json.tmp"]:
		if FileAccess.file_exists(p):
			DirAccess.remove_absolute(p)


func test_screen_cards_and_buy() -> void:
	if _g() == null:
		return
	var nav := RecNav.new()
	var s := _screen(nav)
	for id in ["starter_pack", "golden_pass", "gems_80", "gems_450", "gems_1000", "gems_2200", "skin_pirate"]:
		assert_true(s.buy_buttons.has(id), id)
	assert_true("$0.99" in (s.buy_buttons["gems_80"] as Button).text)
	assert_true(s.capsules_card == null, "no capsules card without the screen")
	assert_true(s.restore_button != null)
	(s.buy_buttons["gems_450"] as Button).pressed.emit()
	assert_eq(_g().economy.get_amount("gems"), 450)
	s.refresh()
	(s.buy_buttons["starter_pack"] as Button).pressed.emit()
	s.refresh()
	assert_true((s.buy_buttons["starter_pack"] as Button).disabled, "owned: button disabled")
	assert_eq(_g().economy.get_amount("capsules"), 3)
	_end(s)


func test_screen_capsules_slot_only_when_available() -> void:
	if _g() == null:
		return
	var nav := RecNav.new()
	nav.capsules = true
	var s := _screen(nav)
	assert_true(s.capsules_card != null)
	s.capsules_button.pressed.emit()
	assert_eq(nav.calls[-1][0], "capsules")
	_end(s)


func test_screen_restore_and_golden_bonus() -> void:
	if _g() == null:
		return
	var s := _screen(RecNav.new())
	_g()._mock_billing.owned_non_consumables = ["golden_pass"]
	s.restore_purchases()
	assert_true(_g().shop.golden_pass_active())
	assert_true(s.status_text != "")
	s.refresh()
	var before: int = _g().economy.get_amount("capsules")
	assert_true(not s.bonus_button.disabled)
	s.bonus_button.pressed.emit()
	assert_eq(_g().economy.get_amount("capsules"), before + DataDB.bal_i("ads.bonus_capsule_count", 1), "golden pass: no ad needed")
	s.claim_bonus_capsule()
	assert_eq(_g().economy.get_amount("capsules"), before + DataDB.bal_i("ads.bonus_capsule_count", 1), "max once per day")
	_end(s)
