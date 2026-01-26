@tool
extends Sprite2D

enum Lado {IZQUIERDA,DERECHA}
@export var lado : Lado
@export var sprite_def : Texture
@export var sprite_press : Texture

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	detect()
	pass
func detect():
	match lado:
		Lado.IZQUIERDA:
			if Input.is_action_just_pressed("ui_left"):
				texture = sprite_press
			if Input.is_action_just_released("ui_left"):
				texture = sprite_def
			flip_h = true
			pass
	
		Lado.DERECHA:
			if Input.is_action_just_pressed("ui_right"):
				texture = sprite_press
				
			if Input.is_action_just_released("ui_right"):
				texture = sprite_def
			flip_h = false
			pass
