extends Node
class_name PhotoCamera2D

const PHOTO_NODE_2D = preload("res://addons/photo_camera_2d/Photocamera2D.tscn")

@export var sfx_photo: AudioStream
@export var sfx_zoom: AudioStream
@export var cam_level :Camera2D
@export var file_prefix := "Photo"
@export_dir var save_directory := ""

var camera_phot: photo_controller = null

func _ready() -> void:
	camera_phot = PHOTO_NODE_2D.instantiate()
	add_child(camera_phot)
	camera_phot.cam_lev = cam_level
	camera_phot.zoom_sound = sfx_zoom
	camera_phot.photo_sound = sfx_photo
	camera_phot.save_directory = save_directory


func _process(delta: float) -> void:
	if camera_phot == null:
		return

	# 🔥 sincronización en tiempo real
	camera_phot.zoom_sound = sfx_zoom
	camera_phot.photo_sound = sfx_photo
	camera_phot.file_prefix = file_prefix
