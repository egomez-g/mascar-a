extends Node2D
class_name main

enum Estados {
	INICIO,
	HABLANDO,
	SIGUIENTE_PJ,
	MASCAR,
	HABLANDOPOST,
}

# var enableInput: bool = false
var text_i: int = 0
var personajes_i: int = 0

var estado: int

@export var mascarMiniGame : MascarMinGame

@onready var shader = $shader2
@onready var zonaTexto = $zonaTexto

var mascado : bool
var currentGrab : objeto_sprite
var currentPersonajeSprite : Sprite2D

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
		currentPersonajeSprite = get_current_personaje_node().get_node("AnimationPlayer") as Sprite2D
		get_current_personaje_node().get_node("AnimationPlayer").play("appear")
		get_current_personaje_node().get_node("./spriteObjeto/AnimationPlayer").play("appear")
		currentGrab = get_current_personaje_node().find_child("spriteObjeto") as objeto_sprite
		estado = Estados.HABLANDO
	elif estado == Estados.HABLANDO:
		if text_i < get_current_personaje_data().textoIntro.size():
			zonaTexto.text = get_current_personaje_data().textoIntro[text_i]
			text_i += 1
		else:
			zonaTexto.text = ""
			shader.mouse_filter = Control.MOUSE_FILTER_IGNORE
			currentGrab.OnMouth.connect(OnObjetoArrastradoBoca)
			currentGrab.OnTrash.connect(OnObjetoArrastradoTrash)
	elif estado == Estados.SIGUIENTE_PJ:
		if personajes_i < personajes.size():
			get_current_personaje_node().get_node("AnimationPlayer").play("appear")
			get_current_personaje_node().get_node("./spriteObjeto/AnimationPlayer").play("appear")
			estado = Estados.HABLANDO
	elif estado == Estados.MASCAR:
		mascarMiniGame.next()
	elif estado == Estados.HABLANDOPOST:
		if mascado:
			if text_i < get_current_personaje_data().textoPostMascar.size():
				zonaTexto.text = get_current_personaje_data().textoPostMascar[text_i]
				text_i += 1
			else:
				GoNextPersonaje()
		else:
			if text_i < get_current_personaje_data().textoPostThrash.size():
				zonaTexto.text = get_current_personaje_data().textoPostThrash[text_i]
				text_i += 1
			else:
				GoNextPersonaje()

func OnMascarEnded():
	mascarMiniGame.StepsEnded.disconnect(OnMascarEnded)
	estado = Estados.HABLANDOPOST
	mascado = true
	text_i = 0
	
func  OnObjetoArrastradoTrash():
	OnObjetoArrastrado()
	mascado = false
	estado = Estados.HABLANDOPOST
	text_i = 0

func  OnObjetoArrastradoBoca():
	OnObjetoArrastrado()
	GoEstadoMascar()

func OnObjetoArrastrado():
	currentGrab.visible = false
	currentGrab.OnTrash.disconnect(OnObjetoArrastradoTrash)
	currentGrab.OnMouth.disconnect(OnObjetoArrastradoBoca)

func GoEstadoMascar():
	mascarMiniGame.Initialize(get_current_personaje_data().mascarData)
	estado = Estados.MASCAR
	mascarMiniGame.StepsEnded.connect(OnMascarEnded)

func GoNextPersonaje():
	get_current_personaje_node().get_node("AnimationPlayer").play("disappear")
	if personajes_i < personajes.size():
		zonaTexto.text = ""
		personajes_i += 1
		text_i = 0
		currentGrab = get_current_personaje_node().find_child("spriteObjeto") as objeto_sprite
		currentPersonajeSprite = get_current_personaje_node().get_node("AnimationPlayer") as Sprite2D
		shader.mouse_filter = Control.MOUSE_FILTER_IGNORE
		estado = Estados.SIGUIENTE_PJ
	
