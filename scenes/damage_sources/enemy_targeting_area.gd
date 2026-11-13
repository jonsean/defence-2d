extends Area2D

var  targeting_range = 100.0
var targets: Array[Node2D]
var has_targets = false

signal target_accuired
signal target_lost
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_targeting_range(400)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_target() -> Node2D:
	if targets.size() > 0:
		return targets[0]
	else:
		return null

func set_targeting_range(range: float = 100) -> void:
	targeting_range = range
	$CollisionShape2D.shape.radius = targeting_range

func _on_body_entered(body: Node2D) -> void:
	if "targetable" in body:
		targets.append(body)
		if !has_targets:
			target_accuired.emit()
			has_targets = true


func _on_body_exited(body: Node2D) -> void:
	targets.erase(body)
	if targets.size() < 1:
		has_targets = false
		target_lost.emit()
