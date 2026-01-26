extends Button

@export var go_to : String
var tween : Tween
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pivot_offset = size/2
	button_down.connect(on_button_down)
	button_up.connect(on_button_up)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_button_down():
	SceneManager.change_scene(go_to)
	play_animation()
	pass

func on_button_up():
	stop_animation()
	pass

func play_animation():
	if tween:
		tween.kill()
	
	tween = create_tween()
	tween.tween_property(self, "scale", Vector2(0.8, 0.8), 0.1)

func stop_animation():
	if tween:
		tween.kill()
	
	tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1, 1), 0.1)
