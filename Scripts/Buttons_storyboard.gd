extends CanvasLayer

@export var btn_prev : Button
@export var btn_next : Button
@export var storyboard: Story_Manager

func _ready() -> void:
	btn_prev.button_down.connect(on_button_prev_down)
	btn_next.button_down.connect(on_button_next_down)


func on_button_prev_down():
	storyboard.prev_page()
	pass

func on_button_next_down():
	storyboard.next_page()
	pass
	
	
