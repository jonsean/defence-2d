extends PanelContainer

var port = 8910
var address = "127.0.0.1"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_host_button_pressed() -> void:
	port = int(%PortTextEdit.text) 
	Events.host_button_signal.emit(port)


func _on_join_button_pressed() -> void:
	address = %IPTextEdit.text
	Events.join_button_signal.emit(address)
