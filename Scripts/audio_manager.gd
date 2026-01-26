extends Node2D


##MI PROPIO AUDIO MANAGER

## VARIABLRES PUBLICAS
@export var ambient : AudioStreamPlayer
@export var sfx_ui : AudioStreamPlayer
@export var sfx: AudioStreamPlayer
@export var cantidad_audios : int = 30
@export var audiosfx : PackedScene
@export var audio : AudioStream
## VARIABLES PRIVADAS

var sfx_oneshot : Array[AudioStreamPlayer]
var index: int

func _ready() -> void:
	cambiar_volumen_audio_bus("Master",1)
	crear_pool()

func play_sfx(sfx_sound :AudioStream):
	sfx.stream = sfx_sound
	sfx.play()
	
func stop_sfx():
	sfx.stop()

func play_sfx_ui(sfx_sound :AudioStream):
	sfx_ui.stream = sfx_sound
	sfx_ui.play()

func stop_sfx_ui():
	sfx_ui.stop()
	
func play_ambient(ambient_sound :AudioStream):
	ambient.stream = ambient_sound
	ambient.play()

func stop_ambient():
	ambient.stop()
	 


func cambiar_volumen_audio_bus(name_bus : String, linear_value: int):
	##VOLUMEN CAMBIALO DE 0 A 1
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(name_bus),linear_to_db(linear_value))
	print("volumen de ",name_bus," cambiado a ",linear_value)
	pass

## MI PROPIO PLAYONESHOT PARA USARLO LAS VECES QUE QUIERA
func play_sfx_oneshot(sfx_audio : AudioStream):
	if index <= cantidad_audios-1:
		if 	!sfx_oneshot[index].playing:
			## SE REPRODUCE EN ESTE audiostream
			sfx_oneshot[index].stream = sfx_audio
			sfx_oneshot[index].play()
			index += 1;
			print(index)
	else:
		index = 0


func stop_all_sfx_oneshot():
	for cada_sfx in sfx_oneshot:
		cada_sfx.stop()
		pass
		
func crear_pool():
	if (cantidad_audios == 0):
		print("No has elegido la cantidad de audios que usaras")
	else:
		if(audiosfx != null):
			for cada_audio in cantidad_audios:
				## HAY QUE INSTANCIARLO
				var sfx_= audiosfx.instantiate()
				add_child(sfx_)
				## DESPUES HACER QUE SE AGREGUEN SOLOS A UNA LISTA
				sfx_oneshot.append(sfx_)
		else:
			push_error("NO HAY UN AUDIO ASIGNADO en audiosfx :", audiosfx)
		
