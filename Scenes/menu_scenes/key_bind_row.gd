extends HBoxContainer

signal rebind_requested(action_name: String, button_instance: Button, alt: bool)

var action_name: String = ""

@onready var action_label: Label = $ActionLabel
@onready var key_button: Button = $KeyButton
@onready var alt_key_button: Button = $AltKeyButton
@onready var unbind_button: Button = $UnbindButton

# Call this right after creating the row to fill it with data
func setup(action: String, current_key: String, alt_current_key) -> void:
	action_name = action
	action_label.text = action.replace("_", " ").capitalize() # "thrust_forward" -> "Thrust Forward"
	key_button.text = current_key
	alt_key_button.text = alt_current_key
	visible=true

func _on_key_button_pressed() -> void:
	# Tell the main menu that THIS specific action wants to rebind
	rebind_requested.emit(action_name, key_button, false)

func _on_alt_key_button_pressed() -> void:
	rebind_requested.emit(action_name, alt_key_button, true)

func _on_unbind_button_pressed() -> void:
	key_button.text = "n/a"
	alt_key_button.text = "n/a"
	rebind_requested.emit(action_name, unbind_button, false)
