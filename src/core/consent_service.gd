class_name ConsentService
extends RefCounted
## Consent state (spec 7.1, 8.7). The profile keeps it in profile.consent:
##   {state: "unknown" | "accepted" | "declined", version: int, updated_at: unix seconds}
##  - accepted: personalized ads + analytics storage;  declined: non-personalized ads, no analytics storage.
##  - Ads never load until the state is resolved (accepted or declined): Game starts AdService only then.
##  - Re-openable from Settings ("Privacy options"): set_choice() can be called again at any time.
## Values written by early builds ("granted", "limited") are mapped to accepted / declined.
## When the feature flag `consent_flow` is off (dev), the state counts as resolved so ads can start
## (non-personalized unless the player chose otherwise).

signal resolved(state: String)    # first time the state leaves "unknown" (or at once when the flow is off)
signal changed(state: String)     # every change of the stored choice

const POLICY_VERSION := 1
const OLD_NAMES := {"granted": "accepted", "limited": "declined"}

var provider: ConsentProvider
var save_service: SaveService
var analytics: AnalyticsService
var flow_enabled: bool
var _resolved_emitted := false

func _init(p_provider: ConsentProvider, p_save: SaveService, p_analytics: AnalyticsService = null,
		p_flow_enabled := true) -> void:
	provider = p_provider
	save_service = p_save
	analytics = p_analytics
	flow_enabled = p_flow_enabled

func _record() -> Dictionary:
	var c = save_service.profile.get("consent")
	if typeof(c) != TYPE_DICTIONARY:
		c = {"state": "unknown"}
		save_service.profile["consent"] = c
	return c

## "unknown" | "accepted" | "declined". A stored policy version older than POLICY_VERSION asks again.
func state() -> String:
	var c := _record()
	var s := str(c.get("state", "unknown"))
	s = str(OLD_NAMES.get(s, s))
	if s != "accepted" and s != "declined":
		return "unknown"
	if c.has("version") and int(c["version"]) < POLICY_VERSION:
		return "unknown"
	return s

func needs_prompt() -> bool:
	return flow_enabled and state() == "unknown"

func is_resolved() -> bool:
	return (not flow_enabled) or state() != "unknown"

func personalized() -> bool:
	return state() == "accepted"

## Call once at app start: lets the platform provider refresh its own status (UMP).
func start() -> void:
	provider.request_info_update()
	if is_resolved():
		provider.apply_choice(personalized())
		_emit_resolved_once()

## The player's choice from the consent screen or from Settings. If the platform requires its own form
## (UMP in some regions) it is shown first and the choice is stored when it closes.
func set_choice(accepted: bool) -> void:
	if provider.is_form_required():
		provider.form_dismissed.connect(func(_s): _store(accepted), CONNECT_ONE_SHOT)
		provider.show_form()
	else:
		_store(accepted)

func _store(accepted: bool) -> void:
	var c := _record()
	c["state"] = "accepted" if accepted else "declined"
	c["version"] = POLICY_VERSION
	c["updated_at"] = Time.get_unix_time_from_system()
	save_service.save()
	provider.apply_choice(accepted)
	if analytics != null:
		analytics.log_event("consent_set", {"state": c["state"]})
	changed.emit(str(c["state"]))
	_emit_resolved_once()

func _emit_resolved_once() -> void:
	if _resolved_emitted:
		return
	_resolved_emitted = true
	resolved.emit(state())

## Settings can also set the raw state (tests, older callers). "unknown" clears the choice.
func set_state(s: String) -> void:
	match s:
		"accepted":
			set_choice(true)
		"declined":
			set_choice(false)
		"unknown":
			var c := _record()
			c["state"] = "unknown"
			c.erase("version")
			save_service.save()
			provider.reset()
			changed.emit("unknown")
