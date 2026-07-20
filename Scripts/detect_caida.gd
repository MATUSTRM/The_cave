extends Area2D

class_name detect_caida

@export var rb: RigidBody2D
@export var player :player_controller
@export var animation : AnimationPlayer
signal cayo

func _ready() -> void:
	body_entered.connect(on_body_entered)
	
	

func on_body_entered(body: Node2D):
	player.soft.gravity_scale =0.6
	if rb.linear_velocity.y > 600:
		cayo.emit()
		play_impact_eyes()
		pass

func play_impact_eyes():
	animation.play("Impact")
	await animation.animation_finished
	animation.play("Idle")
	pass
