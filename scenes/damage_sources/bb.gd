extends RigidBody2D

var hp = 3
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass




func _on_damage_area_hit(damageDealt: float) -> void:
	hp -= 1
	$DamageAreaGood.dmg -= damageDealt/2
	if hp <= 0: 
		queue_free()
	if damageDealt <= 0:
		queue_free()
