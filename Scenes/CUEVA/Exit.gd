extends Area2D

@export var Final_scene: String
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(on_body_entered)
	pass # Replace with function body.


func on_body_entered(body : Node2D):
	SceneManager.change_position(Vector2(0.1,0.5))
	body.call_deferred("desactivar_player")
	SceneManager.change_scene(Final_scene)
	pass
