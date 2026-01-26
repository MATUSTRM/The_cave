extends Control

class_name Scene_manager

@export var position_circle : Vector2
@export var position_exit : Vector2
@export var animation: AnimationPlayer
@export var mat_trans : ShaderMaterial
func _ready() -> void:
	animation.play("Fade_out")
	
	pass

func change_scene(scene : String):
	animation.play("Fade_in")
	await animation.animation_finished
	get_tree().change_scene_to_file(scene)
	animation.play("Fade_out")
	
func restart_scene():
	animation.play("Fade_in")
	await animation.animation_finished
	get_tree().reload_current_scene()
	animation.play("Fade_out")

func change_color(color: Color):
	#mat_trans.set_shader_parameter()
	pass

func change_position(value : Vector2):
	mat_trans.set_shader_parameter("position",value)
	pass
