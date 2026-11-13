extends Area2D

signal hit(damageDealt: float)
@export var dmg = 8
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_entered(area: Area2D) -> void:
	print(area, "entered")


func _on_body_entered(body: Node2D) -> void:
	print(dmg, " dmg")
	if body.has_method("take_damage"):
		body.take_damage(dmg)
		hit.emit(dmg)
