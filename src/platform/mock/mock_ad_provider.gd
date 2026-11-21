class_name MockAdProvider
extends AdProvider
## Editor/test ad provider. Controllable: force_fail, manual (delay) mode, duplicate callbacks,
## and simulate_kill_after_callback (the app "dies" right after the reward callback, before close).

var initialized := false
var consent_known := false
var personalized = null             # null until set_personalized is called
var ready_placements := {}          # placement -> bool
var preload_calls := {}             # placement -> count
var show_calls := {}                # placement -> count
var auto_ready_on_preload := true   # preload succeeds immediately
var fail_preload := false           # preload emits failed
var force_fail := false             # show() fails
var fail_reason := "no_fill"
var manual := false                 # show() waits; the test calls finish_reward()/close_ad()/fail_now()
var duplicate_rewarded := false     # emit `rewarded` twice
var simulate_kill_after_callback := false  # emit rewarded, then never close
var showing := ""                   # placement currently on screen (manual mode)

func set_personalized(p_personalized: bool) -> void:
	personalized = p_personalized

func initialize(p_consent_known: bool) -> void:
	initialized = true
	consent_known = p_consent_known

func is_ready(placement: String) -> bool:
	return ready_placements.get(placement, false)

func set_ready(placement: String, value: bool) -> void:
	ready_placements[placement] = value
	ready_changed.emit(placement, value)

func preload_ad(placement: String) -> void:
	preload_calls[placement] = preload_calls.get(placement, 0) + 1
	if fail_preload:
		failed.emit(placement, "preload_failed")
	elif auto_ready_on_preload:
		set_ready(placement, true)

func show(placement: String) -> void:
	show_calls[placement] = show_calls.get(placement, 0) + 1
	if force_fail or not is_ready(placement):
		ready_placements[placement] = false
		failed.emit(placement, fail_reason)
		return
	ready_placements[placement] = false   # an ad is consumed when shown
	showing = placement
	if manual:
		return
	finish_reward()
	if not simulate_kill_after_callback:
		close_ad()

## Manual mode: the user earned the reward.
func finish_reward() -> void:
	var p := showing
	rewarded.emit(p)
	if duplicate_rewarded:
		rewarded.emit(p)

func close_ad() -> void:
	var p := showing
	showing = ""
	closed.emit(p)

func fail_now(reason := "show_failed") -> void:
	var p := showing
	showing = ""
	failed.emit(p, reason)
