extends CharacterBody2D


@export var speed = 300.0
@export var targetPriority = 1


var control_taken = false

var has_target = false

var targetZoom = Vector2(1,1)
var zoomSpeed = 5
var maxZoom = Vector2(3,3)
var minZoom = Vector2(.2,.2)
var camera_2d: Camera2D

func _enter_tree() -> void:
	var peer_id = name.to_int()
	if peer_id != 0:
		set_multiplayer_authority(peer_id)
		# Crucial: Give the synchronizer authority to match the player!
		$MultiplayerSynchronizer.set_multiplayer_authority(peer_id)
	
func _ready() -> void:
	camera_2d = $Camera2D
	if is_multiplayer_authority():
		camera_2d.enabled = true
	else:
		camera_2d.enabled = false
		
func _input(event: InputEvent) -> void:
	if event.is_action("CameraZoomIn"):
		var zoom = $Camera2D.zoom
		zoom = zoom + Vector2(.05,.05)
		if zoom > maxZoom:
			return
		targetZoom = zoom
	if event.is_action("CameraZoomOut"):
		var zoom = $Camera2D.zoom
		zoom = zoom - Vector2(.05,.05)
		if zoom < minZoom:
			return
		targetZoom = zoom
	if event.is_action("CameraReset"):
		targetZoom = Vector2(1,1)
		
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
	# Smoothly glide current zoom toward the target zoom
	camera_2d.zoom = camera_2d.zoom.move_toward(targetZoom, zoomSpeed * camera_2d.zoom.x * _delta)
	set_animation()
	
	
func set_animation() -> void:
	if velocity == Vector2.ZERO:
		$AnimatedSprite2D.play("idle")
	else: 
		$AnimatedSprite2D.play("walking")
	if velocity.x > 0: 
		$AnimatedSprite2D.flip_h = false
	if velocity.x < 0:
		$AnimatedSprite2D.flip_h = true

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
