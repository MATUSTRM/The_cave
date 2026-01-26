extends Sprite2D


@export var sprite_def : Texture
@export var sprite_press : Texture
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("ui_up"):
		texture = sprite_press
	elif Input.is_action_just_released("ui_up"):
		texture = sprite_def
