extends Node2D

@export var area_1 : Area2D
@export var area_2 : Area2D
@export var camara_off : PhantomCamera2D
@export var camara_on : PhantomCamera2D
@export var duracion : float = 1.0
enum transiciones {Linear, Sine, Quint, Quart, Quad, Expo, Elastic, Cubic, Circ, Bounce, Back}
@export var transicion : transiciones = transiciones.Linear


func _ready() -> void:
	area_1.area_entered.connect(_on_area1_entered)
	area_2.area_entered.connect(_on_area2_entered)
# Mapeo de las transiciones a Tween.TransitionType
var transition_map = {
	transiciones.Linear: Tween.TRANS_LINEAR,
	transiciones.Sine: Tween.TRANS_SINE,
	transiciones.Quint: Tween.TRANS_QUINT,
	transiciones.Quart: Tween.TRANS_QUART,
	transiciones.Quad: Tween.TRANS_QUAD,
	transiciones.Expo: Tween.TRANS_EXPO,
	transiciones.Elastic: Tween.TRANS_ELASTIC,
	transiciones.Cubic: Tween.TRANS_CUBIC,
	transiciones.Circ: Tween.TRANS_CIRC,
	transiciones.Bounce: Tween.TRANS_BOUNCE,
	transiciones.Back: Tween.TRANS_BACK,
}

func _on_area1_entered(body: Node2D) -> void:
	if camara_off and camara_off.tween_resource:
		camara_off.tween_resource.duration = duracion
		camara_off.tween_resource.transition = transition_map.get(transicion, Tween.TRANS_LINEAR) # Conversión correcta
		camara_off.priority = 1
		camara_on.priority = 0

func _on_area2_entered(body: Node2D) -> void:
	if camara_on and camara_on.tween_resource:
		camara_on.tween_resource.duration = duracion
		camara_on.tween_resource.transition = transition_map.get(transicion, Tween.TRANS_LINEAR) # Conversión correcta
	camara_off.priority = 0
	camara_on.priority = 1
