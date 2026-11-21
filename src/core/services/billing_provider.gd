class_name BillingProvider
extends RefCounted
## Interface for in-app purchases (spec 7.3, 8.3). Implementations: platform/mock, platform/android, platform/ios.
## `purchased` may fire again after a restart for an unacknowledged purchase; the caller (BillingService)
## must grant each purchase token exactly once and then call acknowledge().

signal purchased(product_id: String, token: String)
signal failed(product_id: String, reason: String)
signal restored(owned: Array)   # Array[String] of non-consumable product ids
signal refunded(product_id: String)   # the store refunded/revoked a purchase

func initialize() -> void:
	pass

func purchase(_product_id: String) -> void:
	failed.emit(_product_id, "not_implemented")

func restore() -> void:
	restored.emit([])

func acknowledge(_token: String) -> void:
	pass

func local_price(_product_id: String) -> String:
	return ""
