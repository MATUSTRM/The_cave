extends Node

@export var sound : AudioStream
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Audiomanager.play_ambient(sound)
	pass # Replace with function body.
