extends RigidBody2D
class_name player_controller
@export var velocidad: float = 300
@export var fuerza_salto: float = 1500
@export var  player: bool
@export var soft : SoftBody2D
@export var shakers: Array[ShakerComponent2D]
@export var detect_salto_izq :jump_detect_component
@export var detect_salto_der :jump_detect_component
@export var detect_caida_Ref : detect_caida
@export_group("Sounds")
@export var jump: Array[AudioStream]
@export var sfx_golpes : Array[AudioStream]

func activar_player():
	player = true

func desactivar_player():
	player = false

func _ready() -> void:
	detect_caida_Ref.cayo.connect(shake_camara)

	
func _physics_process(delta: float) -> void:
	if player:
		movimiento()
		salto()
	

func rotacion(value :bool):
	lock_rotation = !value
func movimiento():
	if Input.is_action_pressed("ui_right"):
		angular_velocity = velocidad
		#rotacion(true)
		angular_damp = 0
	elif Input.is_action_just_released("ui_right"):
		pass
		#rotacion(false)
	if Input.is_action_pressed("ui_left"):
		angular_velocity = -velocidad
		angular_damp = 0
		#rotacion(true)
	if Input.is_action_pressed("ui_left") and Input.is_action_pressed("ui_right"):
		angular_velocity = 0
		
		#rotacion(false)

func salto():
	if detect_salto_izq.puede_saltar or detect_salto_der.puede_saltar:
		soft.gravity_scale =0.6
		if Input.is_action_pressed("ui_up") and fuerza_salto < 9600:
			print("PREPARANDO SALTO:", fuerza_salto)
			aumentar_fuerza()
		if  Input.is_action_just_released("ui_up"):
			print("SALTO!!")
			Audiomanager.play_sfx_oneshot(jump.pick_random())
			var direccion = -transform.y * fuerza_salto
			linear_velocity = direccion
			reset_fuerza()
			
			
func aumentar_fuerza():
	fuerza_salto += 300;
	
func reset_fuerza():
	fuerza_salto = 1500
	
func shake_camara():
	Audiomanager.play_sfx_oneshot(sfx_golpes.pick_random())
	for cada_shaker in shakers:
		cada_shaker.play_shake()
