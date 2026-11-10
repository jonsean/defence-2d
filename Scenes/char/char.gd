extends CharacterBody2D


@export var speed = 9000.0
@export var targetPriority = 1


func _ready() -> void:
	set_multiplayer_authority(name.to_int())

func _physics_process(_delta: float) -> void:
	if not is_multiplayer_authority():
		return
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var directionx := Input.get_axis("MoveLeft", "MoveRight")
	var directiony := Input.get_axis("MoveUP", "MoveDown")
	
	var rel_speed = speed * _delta
	if directiony:
		velocity.y = directiony * rel_speed 
	else:
		velocity.y = move_toward(velocity.y, 0, rel_speed)
	if directionx:
		velocity.x = directionx * rel_speed
	else:
		velocity.x = move_toward(velocity.x, 0, rel_speed)

	move_and_slide()
