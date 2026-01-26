extends Area2D


func _ready() -> void:
	body_entered.connect(on_body_entered)
	pass
	

func on_body_entered(body : Node2D):
		if body is player_controller:
			body.activar_player()
		pass
