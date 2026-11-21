class_name MockConsentProvider
extends ConsentProvider
## Editor/test consent provider. `form_required` simulates a UMP region that needs the platform form.

var form_required := false
var manual_form := false            # show_form() waits; the test calls dismiss_form()
var status_value := "not_required"
var info_calls := 0
var form_calls := 0
var reset_calls := 0
var last_personalized = null        # null until apply_choice is called

func request_info_update() -> void:
	info_calls += 1
	status_value = "required" if form_required else "not_required"
	info_updated.emit(status_value)

func status() -> String:
	return status_value

func is_form_required() -> bool:
	return form_required and status_value != "obtained"

func show_form() -> void:
	form_calls += 1
	if manual_form:
		return
	dismiss_form()

func dismiss_form() -> void:
	status_value = "obtained"
	form_dismissed.emit(status_value)

func privacy_options_required() -> bool:
	return form_required

func apply_choice(personalized: bool) -> void:
	last_personalized = personalized

func reset() -> void:
	reset_calls += 1
	status_value = "required" if form_required else "not_required"
