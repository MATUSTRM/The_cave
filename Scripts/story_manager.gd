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
@export_group("Scene")
@export var to_scene : String
func _ready() -> void:
	SceneManager.change_position(Vector2(0.5,0.5))
	start_page()
	pass

	
func start_page():
	page_ref = Pages[index]
	panel_story.texture = page_ref.Img
	page_ref.play_Sfx()
	pass


func next_page():
	index +=1
	if index < Pages.size():
		page_ref = Pages[index]
		panel_story.texture = page_ref.Img
		page_ref.play_all_SFXs()
		page_ref.play_Sfx()
	else:
		index= Pages.size()-1
		SceneManager.change_scene(to_scene)
		Audiomanager.stop_ambient()
		Audiomanager.stop_sfx()
func prev_page():
	index -= 1
	if index > -1:
		print(index)
		page_ref = Pages[index]
		panel_story.texture = page_ref.Img
		page_ref.play_all_SFXs()
		page_ref.play_Sfx()
	else:
		index = 0
		print("NO PUEDES BAJAR MAS PAGINA AL STORYBOARD")
