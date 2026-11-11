extends Node

# for adding/modifying all enemy behavior 
@export var yorgi_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func spawn_yorgi():
	if multiplayer.is_server():
		var yorgi_instance = yorgi_scene.instantiate()
		yorgi_instance.position= Vector2(500,500)
		add_child(yorgi_instance, true)
		Global.canSpawnYorgi = false


func _on_spawn_timer_timeout() -> void:
	if Global.isHost and Global.canSpawnYorgi:
		spawn_yorgi()
