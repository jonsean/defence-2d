extends CharacterBody2D


@export var speed = 300.0
@export var targetPriority = 1

var control_taken = false

func _enter_tree() -> void:
	var peer_id = name.to_int()
	if peer_id != 0:
		set_multiplayer_authority(peer_id)
		# Crucial: Give the synchronizer authority to match the player!
		$MultiplayerSynchronizer.set_multiplayer_authority(peer_id)
	
func _physics_process(_delta: float) -> void:
	if not is_multiplayer_authority():
		return
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_vector("MoveLeft", "MoveRight", "MoveUp", "MoveDown")
	print("Direction: ", direction)
	
	if direction:
		velocity = direction * speed 
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.y = move_toward(velocity.y, 0, speed)

	if control_taken:
		move_and_slide()
