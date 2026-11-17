extends RigidBody2D

@export var speed = 100

@export var final_target:  Vector2 = Vector2(500,500)
@export var final_target_node: Node2D
@export var current_target: Vector2 = Vector2(500,500)
@export var current_target_node: Node2D
@export var max_health: float = 100
@export var current_health: float = max_health

var targetable = true

var targets: Array[Node2D]

func _enter_tree() -> void:
	# Enemies are controlled by the server (Peer ID 1)
	set_multiplayer_authority(1)
	
func _ready() ->void: 
	
	set_final_target()
	
func set_final_target() -> void:
	var charList = Global.charList
	if charList.size() > 0:
		final_target = charList[0].global_position
	else:
		final_target = Vector2(0,0)
		
func take_damage(dmg:int = 1) -> void:
	current_health -= dmg
	if current_health <= 0:
		death()

func death() -> void: 
	Global.yorgiCount -= 1
	queue_free()
	
func _physics_process(_delta: float) -> void:
	# Only the server runs enemy AI and movement logic
	if not is_multiplayer_authority():
		return

	# Server-side movement code here...
	
	# update target posisition
	if current_target_node != null:
			current_target = current_target_node.global_position
	# 1. Get the vector pointing to the target
	var to_target = current_target - global_position
	# 2. Normalize the vector to get a clean direction (length of 1)
	var direction = to_target.normalized()
	# 3. Apply foce
	linear_velocity = direction * speed 

func update_target() -> void:
	if targets.size() == 0:
		current_target = position
		current_target_node = null 
		return
	current_target_node = targets[0]
	
func _on_agro_range_area_2d_body_entered(body: Node2D) -> void:
	if "targetPriority" in body: 
		targets.append(body)

func _on_agro_range_area_2d_body_exited(body: Node2D) -> void:
	targets.erase(body)

func _on_target_timer_timeout() -> void:
	update_target()
