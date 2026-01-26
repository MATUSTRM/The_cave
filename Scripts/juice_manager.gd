extends Node2D

var is_active: bool
var value: int


func freezeframe(value_time : float, duration : float):
	Engine.time_scale = value_time;
	await get_tree().create_timer(duration,true,false,true).timeout
	Engine.time_scale = 1;
	pass
	
func freezeframe_lerp(target_time_scale: float, freeze_time: float, transition_time: float) -> void:
	##GUARDO EL TIEMPO ACTUALO EN UNA VARIABLE
	var original = Engine.time_scale
	##RALENTIZA QUE YA ME LO SE Y CREA UN TIMER
	Engine.time_scale = target_time_scale
	await get_tree().create_timer(freeze_time, true, false, true).timeout
	
	# Interpolamos de vuelta a 1
	var elapsed = 0.0
	##ESTA PARTE ME LA SABIA UN POCO
	while elapsed < transition_time:
		elapsed += get_process_delta_time()
		##EL LERP SABIA QUE SUAVIZA PERO NO SABIA QUE SE TENIA QUE EJCUTAR MAS 
		##DE UNA VEZ
		var t = clamp(elapsed / transition_time, 0, 1)
		Engine.time_scale = lerp(target_time_scale, original, t)
		await get_tree().process_frame
	Engine.time_scale = 1


	
	
	
func apply_knockback(direction: Vector2, force : float, duration: float):
	## TIENE SENTIDO PORQUE ES UN GOLPE QUE DA EN UNA DIRECCION
	var knockback :Vector2 = direction * force
	## DESPUES HAY QUE HACER UN KNOCKBACKDIRECTION = (BODY.GLOBALPOSITION - GLOBALPOSITION).NORMALIZED()
	## Y APLICARLE AL BODY
	pass
	
