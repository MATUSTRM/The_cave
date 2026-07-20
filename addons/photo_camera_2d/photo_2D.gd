## PhotoCamera2D


@icon("res://addons/photo_camera_2d/icon.png")
extends Node2D

class_name photo_controller


@export_dir var save_directory := ""
@export var file_prefix := "Photo"
##CAMARA DEL NIVEL 
@export var cam_lev : Camera2D
# =========================
# REFERENCES
# =========================
@onready var cam: Camera2D = $Camera2D
@onready var ui: CanvasLayer = $UI

@onready var zoom_slider: HSlider = $UI/MarginContainer/Control/panel/VBoxContainer/ZoomSlider
@onready var rotation_slider: HSlider = $UI/MarginContainer/Control/panel/VBoxContainer/RotationSlider
@onready var roll_slider: HSlider = $UI/MarginContainer/Control/panel/VBoxContainer/RollSlider
@onready var photo_button: Button = $UI/MarginContainer/Control/panel/VBoxContainer/PhotoButton
@onready var grid_toggle: CheckButton = $UI/MarginContainer/Control/panel/VBoxContainer/GridToggle
@onready var letterboxOption: OptionButton = $UI/MarginContainer/Control/panel/VBoxContainer/Letterbox
@onready var grid: CanvasLayer = $Effect/Grid

@onready var letterbox: CanvasLayer = $Letterbox

@onready var top_bar: ColorRect = $Letterbox/TopBar
@onready var bottom_bar: ColorRect = $Letterbox/BottomBar

var letterbox_mode := 0
# 0 = off
# 1 = cinematic
# 2 = extreme
# =========================
# MOVEMENT SETTINGS
# =========================
@export var move_speed := 400.0
@export var acceleration := 8.0
@export var fast_multiplier := 2.5
@export var slow_multiplier := 0.5

# =========================
# ZOOM / ROTATION
# =========================
@export var min_zoom := 0.2
@export var max_zoom := 3.0
@export var zoom_speed := 0.1
@export var zoom_smooth := 8.0

@export var roll_step := 5.0
@export var roll_max := 45.0
@export var roll_smooth := 8.0


# =========================
# AUDIO
# =========================
##INSERT THE SOUND 
@export var zoom_sound: AudioStream
## SOUND WHILE TAKE PHOT
@export var photo_sound: AudioStream
## SOUND ROTATION :P
@export var rotation_sound: AudioStream

var zoom_player: AudioStreamPlayer
var photo_player: AudioStreamPlayer
var rotation_player: AudioStreamPlayer
var ui_visible := true
var current_rotation := 0.0
# =========================
# STATE
# =========================
var velocity := Vector2.ZERO
var target_zoom := 1.0
var target_rotation := 0.0
var target_roll := 0.0
var current_roll := 0.0

var grid_visible := false
var has_saved_position := false

var saved_position: Vector2
var saved_zoom := 1.0
var saved_rotation := 0.0
var saved_roll := 0.0



func _ready():
	_toggle_ui()
	letterboxOption.clear()
	letterboxOption.add_item("Off")
	letterboxOption.add_item("16:9")
	letterboxOption.add_item("21:9 Cinematic")
	letterboxOption.add_item("2.39:1 Scope")
	letterboxOption.add_item("IMAX")
	letterboxOption.add_item("Documentary")
	letterboxOption.add_item("Classic Film")
	letterboxOption.add_item("Ultra Wide")
	letterboxOption.add_item("Horror")
	letterboxOption.add_item("Minimal")
	_apply_letterbox(0)
	zoom_player = AudioStreamPlayer.new()
	add_child(zoom_player)
	zoom_player.stream = zoom_sound

	photo_player = AudioStreamPlayer.new()
	add_child(photo_player)
	photo_player.stream = photo_sound

	rotation_player = AudioStreamPlayer.new()
	add_child(rotation_player)
	rotation_player.stream = rotation_sound
		
	# =========================
	# UI CONNECTIONS
	# =========================
	if zoom_slider:
		zoom_slider.value_changed.connect(_on_zoom_changed)

	if rotation_slider:
		rotation_slider.value_changed.connect(_on_rotation_changed)

	if roll_slider:
		roll_slider.value_changed.connect(_on_roll_changed)

	if photo_button:
		photo_button.pressed.connect(take_photo)

	if grid_toggle:
		grid_toggle.toggled.connect(_on_grid_toggled)
	
	
	
	if letterboxOption:
		letterboxOption.item_selected.connect(_on_letterbox_selected)
# =========================
# INPUT
# =========================
func _input(event):

	_handle_zoom_and_rotation_input(event)
	_handle_keyboard_input(event)

	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if not ui_visible:
				take_photo()

# =========================
# PROCESS
# =========================
func _process(delta):
	_update_movement(delta)
	_update_camera_transform(delta)

# =========================================================
# MOVEMENT SYSTEM
# =========================================================
func _update_movement(delta):

	var dir := Vector2.ZERO

	if Input.is_action_pressed("ui_up"):
		dir.y -= 1
	if Input.is_action_pressed("ui_down"):
		dir.y += 1
	if Input.is_action_pressed("ui_left"):
		dir.x -= 1
	if Input.is_action_pressed("ui_right"):
		dir.x += 1

	var speed := 1.0

	if Input.is_key_pressed(KEY_SHIFT):
		speed = fast_multiplier
	elif Input.is_key_pressed(KEY_ALT):
		speed = slow_multiplier

	dir = dir.normalized() * move_speed * speed
	velocity = velocity.lerp(dir, acceleration * delta)

	cam.position += velocity * delta

# =========================================================
# CAMERA SYSTEM
# =========================================================
func _update_camera_transform(delta):

	# Zoom
	cam.zoom = cam.zoom.lerp(Vector2(target_zoom, target_zoom), zoom_smooth * delta)

	# Rotación
	current_rotation = lerp(current_rotation, target_rotation, roll_smooth * delta)
	cam.rotation = current_rotation



	grid_toggle.button_pressed = grid_visible
# =========================================================
# INPUT HANDLING
# =========================================================
func _handle_zoom_and_rotation_input(event):

	if event is InputEventMouseButton and event.pressed:

		if Input.is_key_pressed(KEY_SHIFT):

			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				target_rotation -= deg_to_rad(roll_step)
				_play_rotation_sound()

			elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				target_rotation += deg_to_rad(roll_step)
				_play_rotation_sound()

			target_rotation = clamp(
				target_rotation,
				deg_to_rad(-roll_max),
				deg_to_rad(roll_max)
			)

		else:

			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				target_zoom += zoom_speed
			elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				target_zoom -= zoom_speed

			target_zoom = clamp(target_zoom, min_zoom, max_zoom)
		
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			target_zoom += zoom_speed
			_play_zoom_sound()

		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			target_zoom -= zoom_speed
			_play_zoom_sound()
		
		
func _handle_keyboard_input(event):

	if event is InputEventKey and event.pressed:

		match event.keycode:

			KEY_R:
				target_rotation = 0.0

			KEY_T:
				target_roll = 0.0

			KEY_G:
				_toggle_grid()

			KEY_F1:
				_save_camera()

			KEY_F2:
				_restore_camera()

			KEY_Q:
				target_roll -= deg_to_rad(roll_step)

			KEY_E:
				target_roll += deg_to_rad(roll_step)
			
			KEY_F10:
				_toggle_ui()
				toggle_camera()
# =========================================================
# GRID
# =========================================================
func _toggle_grid():
	grid_visible = !grid_visible
	grid.visible = grid_visible
	
	

func toggle_camera():
	if cam_lev:
		cam_lev.enabled = !cam_lev.enabled

	cam.enabled = !cam.enabled
# =========================================================
# BOOKMARK SYSTEM
# =========================================================
func _save_camera():
	saved_position = cam.position
	saved_zoom = target_zoom
	saved_rotation = target_rotation
	saved_roll = target_roll
	has_saved_position = true
	print("📌 Camera guardada")

func _restore_camera():
	if not has_saved_position:
		return

	cam.position = saved_position
	target_zoom = saved_zoom
	target_rotation = saved_rotation
	target_roll = saved_roll

	print("↩️ Camera restaurada")

# =========================================================
# PHOTO SYSTEM
# =========================================================
func take_photo():

	var was_visible := ui.visible
	ui.visible = false

	await get_tree().process_frame
	await get_tree().process_frame

	var img := get_viewport().get_texture().get_image()

	if was_visible:
		ui.visible = true

	var directory := save_directory

	if directory.is_empty():
		directory = OS.get_system_dir(OS.SYSTEM_DIR_DESKTOP)

	DirAccess.make_dir_recursive_absolute(directory)
	var file_name := "%s_%s.png" % [
		file_prefix,
		Time.get_unix_time_from_system()
	]

	var full_path := directory.path_join(file_name)

	img.save_png(full_path)

	_play_photo_sound()
	_flash()

	print("📸 Foto guardada en:", full_path)
# =========================================================
# FLASH EFFECT
# =========================================================
func _flash():

	var canvas := CanvasLayer.new()
	add_child(canvas)

	var rect := ColorRect.new()
	rect.color = Color.WHITE
	rect.size = get_viewport().get_visible_rect().size
	rect.modulate.a = 0.8

	canvas.add_child(rect)

	var tween := create_tween()
	tween.tween_property(rect, "modulate:a", 0.0, 0.25)
	tween.finished.connect(func():
		canvas.queue_free()
	)
	
func _play_zoom_sound():
	if zoom_sound:
		zoom_player.pitch_scale = randf_range(0.95, 1.05)
		zoom_player.play()

func _play_photo_sound():
	if photo_sound:
		photo_player.pitch_scale = randf_range(0.98, 1.02)
		photo_player.play()

func _play_rotation_sound():
	if rotation_sound:
		rotation_player.pitch_scale = randf_range(0.95, 1.05)
		rotation_player.play()


func _toggle_ui():
	ui_visible = !ui_visible
	ui.visible = ui_visible
	cam.enabled = !cam.enabled


func _on_zoom_changed(value: float):
	target_zoom = value
	_play_zoom_sound()
	
func _on_rotation_changed(value: float):
	target_rotation = deg_to_rad(value)
	_play_rotation_sound()
	
func _on_roll_changed(value: float):
	target_roll = deg_to_rad(value)
	_play_rotation_sound()
	
func _on_grid_toggled(value: bool):
	grid_visible = value
	grid.visible = value
	
func _on_letterbox_selected(index: int):
	_apply_letterbox(index)

var letterbox_presets := [
	0.00, # Off
	0.06, # 16:9
	0.09, # 21:9 Cinematic
	0.12, # 2.39:1 Scope
	0.03, # IMAX
	0.08, # Documentary
	0.10, # Classic Film
	0.16, # Ultra Wide
	0.22, # Horror
	0.04  # Minimal
]

func _apply_letterbox(mode: int):
	letterbox_mode = mode

	if mode < 0 or mode >= letterbox_presets.size():
		return

	var ratio = letterbox_presets[mode]

	if ratio <= 0.0:
		_hide_letterbox()
	else:
		_show_letterbox(ratio)

func _show_letterbox(size_ratio: float):

	letterbox.visible = true

	var viewport_size := get_viewport().get_visible_rect().size
	var target_height := viewport_size.y * size_ratio

	var tween := create_tween()

	# TOP BAR (normal: crece hacia abajo)
	top_bar.position.y = 0
	tween.tween_property(top_bar, "size:y", target_height, 0.25)

	# BOTTOM BAR (CORREGIDO: crece hacia arriba)
	var bottom_target_y := viewport_size.y - target_height

	tween.parallel().tween_property(bottom_bar, "size:y", target_height, 0.25)
	tween.parallel().tween_property(bottom_bar, "position:y", bottom_target_y, 0.25)

	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)
	
	
func _hide_letterbox():

	var viewport_size := get_viewport().get_visible_rect().size

	var tween := create_tween()

	tween.tween_property(top_bar, "size:y", 0.0, 0.2)

	tween.parallel().tween_property(bottom_bar, "size:y", 0.0, 0.2)
	tween.parallel().tween_property(bottom_bar, "position:y", viewport_size.y, 0.2)

	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)

	tween.finished.connect(func():
		letterbox.visible = false
	)
	
