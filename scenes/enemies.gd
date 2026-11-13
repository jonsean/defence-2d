extends Node

# for adding/modifying all enemy behavior 
@export var yorgi_scene: PackedScene
@export var yorgi_spawn_skip = 2
@export var yorgi_spawn_rate = 6

var spawnTimoutCount = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	

func spawn_freq_logic():
	if Global.isHost and Global.canSpawnYorgi:
		if spawnTimoutCount%yorgi_spawn_skip == 0:
			for i in range(yorgi_spawn_rate):
				spawn_yorgi()

func spawn_yorgi():
	if multiplayer.is_server():
		var random_x = randi_range(0,1500)
		var random_y = randi_range(0,1)
		
		var yorgi_instance = yorgi_scene.instantiate()
		yorgi_instance.position= Vector2(random_x,random_y)
		
		add_child(yorgi_instance, true)
		update_yorgis()

func update_yorgis():
	Global.yorgiCount += 1
	if Global.maxYorgi <= Global.yorgiCount:
		Global.canSpawnYorgi = false

func _on_spawn_timer_timeout() -> void:
	spawnTimoutCount += 1
	if multiplayer.is_server():
		spawn_freq_logic()
