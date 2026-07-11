@tool
extends Control

class_name Story_Manager
@export_group("Story")
##ASIGNA EL TEXTURERECT QUE USARAS PARA MOSTRAR LAS IMAGENES DEL STORY
@export var panel_story : TextureRect
## Creas paginas y asigna el storyboard que necesitas en esa pagina
## tambien puedes agregar efectos de sonido para cada pagina 
@export var Pages : Array[Page]
var page_ref : Page
var index : int 
var elapsed := 0.0
@export_group("Scene")
@export_range(0,5) var time_frame : float
@export var frame : int
@export var animation : bool = true
@export var to_scene : String
## HAY QUE HACER QUE MIENTRAS ESTE EN LA PAGINA,
##SE VAYA ACTUALIZANDO LAS IMAGENES POR FRAME
func _ready() -> void:
	SceneManager.change_position(Vector2(0.5,0.5))
	start_page()
	pass

func _process(delta):

	if !animation:
		reset_frame()
		return

	elapsed += delta

	if elapsed >= page_ref.time_frame:
		elapsed = 0.0
		next_frame()

func update_page():

	if Pages.is_empty():
		return
	page_ref = Pages[index]
	if page_ref.Imgs.is_empty():
		return
	frame = clamp(frame,0,page_ref.Imgs.size()-1)
	panel_story.texture = page_ref.Imgs[frame]
		
func start_page():
	update_page()
	page_ref.play_Sfx()
	pass


func next_page():

	if index + 1 >= Pages.size():
		SceneManager.change_scene(to_scene)
		Audiomanager.stop_ambient()
		Audiomanager.stop_sfx()
		return

	index += 1

	frame = 0
	elapsed = 0.0

	update_page()

	page_ref.play_all_SFXs()
	page_ref.play_Sfx()
		
func prev_page():
	index -= 1
	if index > -1:
		print(index)
		update_page()
		page_ref.play_all_SFXs()
		page_ref.play_Sfx()
	else:
		index = 0
		print("NO PUEDES BAJAR MAS PAGINA AL STORYBOARD")
func next_frame():
	frame += 1
	if frame >= page_ref.Imgs.size():
		if page_ref.loop:
			frame = 0
		else:
			frame = page_ref.Imgs.size() - 1
	update_page()

func previous_frame():
	await get_tree().create_timer(time_frame)
	frame -= 1
	
func reset_frame():
	frame = 0
