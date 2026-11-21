class_name AdProvider
extends RefCounted
## Interface for rewarded-video ads (spec 7.1, 8.3). Implementations: platform/mock, platform/android, platform/ios.
## Rules: only user-initiated rewarded ads. The reward is granted ONLY from `rewarded`, which implementations
## must emit exactly once per completed ad, after the SDK's user-earned-reward callback.

signal rewarded(placement: String)
signal closed(placement: String)
signal failed(placement: String, reason: String)
signal ready_changed(placement: String, is_ready: bool)

func initialize(_consent_known: bool) -> void:
	pass

func is_ready(_placement: String) -> bool:
	return false

func preload_ad(_placement: String) -> void:
	pass

func show(_placement: String) -> void:
	failed.emit(_placement, "not_implemented")
