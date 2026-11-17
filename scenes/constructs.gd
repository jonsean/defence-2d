extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Events.construct_placed.connect(place_construct)
	
func place_construct(location: Vector2, constructScene: Node2D):
	if multiplayer.is_server():
		constructScene.global_position = location
		add_child(constructScene, true)
