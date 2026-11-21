class_name AnalyticsService
extends RefCounted
## Thin wrapper over an AnalyticsProvider that only lets the events of spec 8.6 through (plus a few
## operational ones, see docs/ANALYTICS.md). No PII: parameters whose key looks personal are dropped, and
## no event ever carries a name, email, account, device or advertising id.

const EVENTS := [
	"session_start", "tutorial_step", "stage_start", "stage_end", "unit_upgrade", "power_used",
	"ad_offered", "ad_started", "ad_rewarded", "ad_failed", "iap_view", "iap_purchase",
	"capsule_open", "era_unlocked",
	# not in spec 8.6, operational (docs/ANALYTICS.md)
	"consent_set", "daily_claim", "offline_claim",
]

## Parameter keys that are never forwarded (defence in depth: nothing in the game sends them).
const PII_KEYS := ["email", "name", "user", "user_id", "username", "phone", "ip", "ad_id", "advertising_id",
	"device_id", "android_id", "address", "location", "lat", "lon", "token", "account"]

var provider: AnalyticsProvider
var enabled := true
var rejected: Array = []   # unknown event names that were dropped (visible to tests)
var dropped_keys: Array = []   # PII-looking parameter keys that were dropped (visible to tests)

func _init(p_provider: AnalyticsProvider = null) -> void:
	provider = p_provider if p_provider != null else AnalyticsProvider.new()

func log_event(event_name: String, params: Dictionary = {}) -> bool:
	if not EVENTS.has(event_name):
		rejected.append(event_name)
		return false
	if enabled:
		provider.log_event(event_name, _clean(params))
	return true

func _clean(params: Dictionary) -> Dictionary:
	var out := {}
	for k in params:
		if PII_KEYS.has(str(k).to_lower()):
			dropped_keys.append(str(k))
			continue
		out[k] = params[k]
	return out

## Consent gate: forwarded to the provider (Firebase analytics storage on/off).
func set_collection_allowed(allowed: bool) -> void:
	provider.set_collection_enabled(allowed)

func session_start(first_session: bool, language: String) -> void:
	log_event("session_start", {"first_session": first_session, "lang": language})

func tutorial_step(step_id: String, index: int) -> void:
	log_event("tutorial_step", {"step": step_id, "index": index})

func iap_view(product_id: String) -> void:
	log_event("iap_view", {"product": product_id})

func era_unlocked(era: int) -> void:
	log_event("era_unlocked", {"era": era})

func unit_upgrade(kind: String, id: String, level: int) -> void:
	log_event("unit_upgrade", {"kind": kind, "id": id, "level": level})

func stage_end(stage_id: String, result: String, duration_sec: float, squad: Array, tries: int) -> void:
	log_event("stage_end", {"stage": stage_id, "result": result, "duration": duration_sec, "squad": squad, "tries": tries})

func capsule_open(rarity: String, pity: int) -> void:
	log_event("capsule_open", {"rarity": rarity, "pity": pity})
