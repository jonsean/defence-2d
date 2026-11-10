extends PanelContainer

@export var row_template: PackedScene = preload("res://scenes/menu_scenes/key_bind_row.tscn")
@onready var container = %MenuTable

var is_listening: bool = false
var alt_key_bind: bool = false
var action_to_rebind: String = ""
var button_to_update: Button = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_custom_key_bindings()


func get_custom_key_bindings() -> void:
	var all_actions = InputMap.get_actions()
	
	for action in all_actions:
		if action.begins_with("ui_"):
			continue
		print("Action: ", action)
		
		# 3. Get all inputs (keys, mouse buttons, joypad) bound to this action
		var events = InputMap.action_get_events(action)
		var current_key = "Unbound"
		var alt_current_key = "Unbound"
		
		if events.size() > 0:
			# Convert the key code to a human-readable string (e.g., "W", "Space")			
			var first_event = events[0]
			current_key = first_event.as_text()
		if events.size() > 1:
			var second_event = events[1]
			alt_current_key = second_event.as_text()

		var row = row_template.instantiate()
		container.add_child(row)
		row.setup(action, current_key, alt_current_key)
		row.rebind_requested.connect(_on_action_rebind_requested)

func _on_action_rebind_requested(action_to_change: String, target_button: Button, alt: bool) -> void:
	if target_button.name == "UnbindButton":
		rebind_action(action_to_change, null)
		return
	is_listening = true
	alt_key_bind = alt
	action_to_rebind = action_to_change
	button_to_update = target_button
	button_to_update.text = "Press any key..."

func _input(event: InputEvent) -> void:
	
	if not is_listening:
		return
	# Cancel keybind 
	if event is InputEventKey and event.physical_keycode == KEY_ESCAPE:
		is_listening = false
		if alt_key_bind:
			# If it's an alternate bind reset the button text to the second event if it exists
			var actions = InputMap.action_get_events(action_to_rebind)
			if actions.size() > 1:
				button_to_update.text = InputMap.action_get_events(action_to_rebind)[1].as_text()
			else: 
				button_to_update.text = "Unbound"
		else:
			button_to_update.text = InputMap.action_get_events(action_to_rebind)[0].as_text()
		get_viewport().set_input_as_handled()
		return
	# Skip mouse movement events so moving the mouse doesn't bind to the action!
	if event is InputEventMouseMotion:
		return
	# Stop the engine from passing this input event to other UI elements
	get_viewport().set_input_as_handled()	
	# Only register the input when they physically press down (not when they release it)
	if event.is_pressed():
		rebind_action(action_to_rebind, event)
		# Turn off the listening gate
		is_listening = false
		
func rebind_action(action: String, new_event: InputEvent) -> void:
	var current_events = InputMap.action_get_events(action)
	if new_event == null:
		InputMap.action_erase_events(action)
		return
	if alt_key_bind:
		if current_events.size() == 0 :
			InputMap.action_add_event(action, new_event)
			InputMap.action_add_event(action, new_event)
			if is_instance_valid(button_to_update):
				button_to_update.text = new_event.as_text()
			return
		if current_events.size() > 1:
			current_events[1] = new_event
		else:
			current_events.append(new_event)
		InputMap.action_erase_events(action)
		for event in current_events:
			InputMap.action_add_event(action, event)
		
	else:
		if current_events.size() > 1:
			current_events[0] = new_event
			InputMap.action_erase_events(action)
			for event in current_events:
				InputMap.action_add_event(action, event)
			if is_instance_valid(button_to_update):
				button_to_update.text = new_event.as_text()
			return
		InputMap.action_erase_events(action)
		InputMap.action_add_event(action, new_event)
		
	if is_instance_valid(button_to_update):
			button_to_update.text = new_event.as_text()
