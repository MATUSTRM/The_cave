extends Button

var tween: Tween

func _ready() -> void:
	pivot_offset = size / 2
	button_down.connect(play_animation)
	button_up.connect(stop_animation)

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
