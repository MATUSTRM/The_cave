extends Area2D

class_name detect_caida

@export var rb: RigidBody2D
@export var player :player_controller
signal cayo

func _ready() -> void:
	body_entered.connect(on_body_entered)
	
	

func on_body_entered(body: Node2D):
	player.soft.gravity_scale =0.6
	if rb.linear_velocity.y > 600:
		emit_signal("cayo")
		pass
