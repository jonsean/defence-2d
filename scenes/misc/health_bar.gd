extends ProgressBar

var parent: Node2D

@export var y_offset : float
@export var hide_on_max : bool = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	parent = get_parent()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	rotation = -parent.global_rotation
	var posx = parent.global_position.x - (size.x/2)
	var posy = parent.global_position.y - y_offset
	global_position = Vector2(posx, posy)
	set_health()

func set_health() -> void:
	var max:float = 100.0
	var current:float = 100.0
	if "max_health" in parent: 
		max = parent.max_health
	if "current_health" in parent:
		current = parent.current_health
	value = (current/max)*100
	if hide_on_max:
		if value == max:
			visible = false
		else:
			visible = true
		
		
		
