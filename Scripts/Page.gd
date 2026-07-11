extends Resource

class_name Page
##TITULO DE LA PAGINA
##POR MIENTRAS ES PARA NO PERDERESE
@export var title : String
##IMAGEN DEL STORYBOARD
##tienes que asignar la imagen que quieras
##implementar
@export var Imgs : Array[Texture]
@export_range(0.15,4) var time_frame := 0.15
@export var loop := true

@export_group("Sound effects")
##Solo tiene que asignar los sonidos que quieras
## y se reproduciran en la pagina en la que agregaste
##ADVERTENCIA: SOLO PARA SONIDOS NO LOOPEABLES
@export var SFX_s: Array[AudioStream]
@export_subgroup("Sound_loop")
##lo mismo pero este esta diseñado para sonidos loopeados
@export var sfx_loop : AudioStream



func play_all_SFXs():
	if SFX_s != null:
		for cada_sfx in SFX_s:
			Audiomanager.play_sfx_oneshot(cada_sfx)
	else:
		print("NO HAY AUDIO")

func play_Sfx():
	Audiomanager.play_sfx(sfx_loop)
	pass
func stop_all_sfx():
	if SFX_s != null:
		for cada_sfx in SFX_s:
			Audiomanager.stop(cada_sfx)
	else:
		print("NO HAY AUDIO")
