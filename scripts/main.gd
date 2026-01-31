extends Node2D
class_name main

enum Estados {
	INICIO,
	HABLANDO,
	SIGUIENTE_PJ,
	MASCAR
}

# var enableInput: bool = false
var text_i: int = 0
var personajes_i: int = 0

var estado: int

@export var mascarMiniGame : MascarMinGame

@onready var shader = $shader2
@onready var zonaTexto = $zonaTexto

var currentGrab : objeto_sprite

@export var personajes : Array[Personaje]
@export var nodosPersonaje : Array[Node2D]

func  get_current_personaje_data() -> Personaje:
	return personajes[personajes_i]

func  get_current_personaje_node() -> Node2D:
	return nodosPersonaje[personajes_i]

func _ready():
	estado = Estados.INICIO
	zonaTexto.text = "DALE A LA PUTA A"

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("tecla_a"):
		avanzar_juego()

func avanzar_juego():
	if estado == Estados.INICIO:
		get_current_personaje_node().get_node("AnimationPlayer").play("appear")
		get_current_personaje_node().get_node("./spriteObjeto/AnimationPlayer").play("appear")
		currentGrab = get_current_personaje_node().find_child("spriteObjeto") as objeto_sprite
		estado = Estados.HABLANDO
	elif estado == Estados.HABLANDO:
		if text_i < get_current_personaje_data().textoIntro.size():
			zonaTexto.text = get_current_personaje_data().textoIntro[text_i]
			text_i += 1
		else:
			shader.mouse_filter = Control.MOUSE_FILTER_IGNORE
			currentGrab.OnMouth.connect(OnObjetoArrastradoBoca)
			currentGrab.OnTrash.connect(OnObjetoArrastradoTrash)
			
	elif estado == Estados.SIGUIENTE_PJ:
		print(personajes.size())
		print(personajes_i)
		if personajes_i < personajes.size():
			get_current_personaje_node().get_node("AnimationPlayer").play("appear")
			get_current_personaje_node().get_node("./spriteObjeto/AnimationPlayer").play("appear")
			estado = Estados.HABLANDO
	elif estado == Estados.MASCAR:
		mascarMiniGame.next()

func OnMascarEnded():
	mascarMiniGame.StepsEnded.disconnect(OnMascarEnded)
	GoNextPersonaje()
	
func  OnObjetoArrastradoTrash():
	currentGrab.visible = false
	currentGrab.OnTrash.disconnect(OnObjetoArrastradoTrash)
	currentGrab.OnMouth.disconnect(OnObjetoArrastradoBoca)
	GoNextPersonaje()

func  OnObjetoArrastradoBoca():
	currentGrab.visible = false
	currentGrab.OnTrash.disconnect(OnObjetoArrastradoTrash)
	currentGrab.OnMouth.disconnect(OnObjetoArrastradoBoca)
	GoEstadoMascar()

func GoEstadoMascar():
	mascarMiniGame.Initialize(get_current_personaje_data().mascarData)
	estado = Estados.MASCAR
	mascarMiniGame.StepsEnded.connect(OnMascarEnded)

func GoNextPersonaje():
	get_current_personaje_node().get_node("AnimationPlayer").play("disappear")
	if personajes_i < personajes.size():
		personajes_i += 1
		text_i = 0
		currentGrab = get_current_personaje_node().find_child("spriteObjeto") as objeto_sprite
		estado = Estados.SIGUIENTE_PJ
	
