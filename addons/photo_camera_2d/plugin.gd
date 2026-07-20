@tool
extends EditorPlugin
const CAMERA_SCENE = preload("res://addons/photo_camera_2d/Photocamera2D.tscn")


var instance

func _enter_tree():
	instance = CAMERA_SCENE.instantiate()
	get_editor_interface().get_editor_viewport_2d().add_child(instance)
	instance.owner = get_tree().edited_scene_root

func _exit_tree():
	if instance:
		instance.queue_free()
