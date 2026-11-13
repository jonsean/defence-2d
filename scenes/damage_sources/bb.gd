extends RigidBody2D

var hp = 40
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass




func _on_damage_area_hit(damageDealt: float) -> void:
	hp -= damageDealt
	$DamageAreaGood.dmg -= 5
	if hp <= 0: 
		queue_free()
	if damageDealt <= 0:
		queue_free()
