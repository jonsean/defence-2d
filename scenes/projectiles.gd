extends Node

# should be changed later
var bullet_speed = 400
var origin_buffer = 20 #ensure buttlet doesn't interfere with player
@export var bullet_scene:PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Events.projectile_fired.connect(fire_projectile)
	
func fire_projectile(direction: Vector2, origin: Vector2):
	var bullet = bullet_scene.instantiate()
	bullet.linear_velocity = direction * bullet_speed
	var startPos:Vector2 = origin
	bullet.global_position = startPos
	add_child(bullet)
