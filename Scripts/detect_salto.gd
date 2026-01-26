extends RayCast2D

class_name jump_detect_component

var puede_saltar: bool

func _process(delta: float) -> void:
	if is_colliding():
		puede_saltar = true
	else:
		puede_saltar = false
