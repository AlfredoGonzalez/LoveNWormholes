class_name AnalyticsService
extends RefCounted
## Thin wrapper over an AnalyticsProvider that only lets the events of spec 8.6 through.

const EVENTS := [
	"session_start", "tutorial_step", "stage_start", "stage_end", "unit_upgrade", "power_used",
	"ad_offered", "ad_started", "ad_rewarded", "ad_failed", "iap_view", "iap_purchase",
	"capsule_open", "era_unlocked",
]

var provider: AnalyticsProvider
var enabled := true
var rejected: Array = []   # unknown event names that were dropped (visible to tests)

func _init(p_provider: AnalyticsProvider = null) -> void:
	provider = p_provider if p_provider != null else AnalyticsProvider.new()

func log_event(event_name: String, params: Dictionary = {}) -> bool:
	if not EVENTS.has(event_name):
		rejected.append(event_name)
		return false
	if enabled:
		provider.log_event(event_name, params)
	return true

func stage_end(stage_id: String, result: String, duration_sec: float, squad: Array, tries: int) -> void:
	log_event("stage_end", {"stage": stage_id, "result": result, "duration": duration_sec, "squad": squad, "tries": tries})

func capsule_open(rarity: String, pity: int) -> void:
	log_event("capsule_open", {"rarity": rarity, "pity": pity})
