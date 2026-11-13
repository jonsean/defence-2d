extends CharacterBody2D


@export var speed = 300.0
@export var targetPriority = 1


var control_taken = false

var has_target = false

func _enter_tree() -> void:
	var peer_id = name.to_int()
	if peer_id != 0:
		set_multiplayer_authority(peer_id)
		# Crucial: Give the synchronizer authority to match the player!
		$MultiplayerSynchronizer.set_multiplayer_authority(peer_id)
	
	

func _physics_process(_delta: float) -> void:
	if not is_multiplayer_authority():
		return
	
	var peers = multiplayer.get_peers().size()
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_vector("MoveLeft", "MoveRight", "MoveUp", "MoveDown")
	
	if direction:
		velocity = direction * speed 
		if peers > 0:
			control_taken = true
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.y = move_toward(velocity.y, 0, speed)
	
	if control_taken or peers == 0:
		move_and_slide()


func _on_enemy_targeting_area_target_accuired() -> void:
	has_target = true


func _on_enemy_targeting_area_target_lost() -> void:
	has_target = false

func _on_gun_timer_timeout() -> void:
	if has_target:
		shoot()

func shoot() -> void:
	var target:Node2D = $EnemyTargetingArea.get_target()
	if target == null:
		return
	var to_target:Vector2 = target.global_position - global_position
	var direction = to_target.normalized()

	Events.projectile_fired.emit(direction, global_position)
