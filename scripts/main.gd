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

@onready var ladron = get_node("./ladron")
@onready var vieja = get_node("./vieja")
@export var mascarMiniGame : MascarMinGame
@export var mascarDataVieja : Pasos
@export var mascarDataLadron : Pasos

@onready var shader = $shader2
@onready var zonaTexto = $zonaTexto

var currentGrab : objeto_sprite

var textoVieja := [
	"Dialogo intro: P-p-perdona joven… Ne-necesito tu ayuda",
	"he escuchado q-q-que partes cosas",
	"y la enfermera me sigue d-d-dando las pastillas de siempre.",
	"¿Podrías ayudarme? t-tengo dinero."
]

var textoLadron := [
	"DAME TODO LO QUE TENGAS JODEEER, ME ESTOY PONIENDO MUY NERVIOSO",
	"E-Eh vale vale, tranquilo colega… N-no hagas ninguna tontería",
	"¡¡¿¿ PERO QUE COJONES HACES ??!! ESTAS TOCADO DE LA CABEZA COLEGA, VAYA PUTA CIUDAD DE COLGADOS, ME PIRO DE AQUÍ",
	"¿Pero…? Mira, déjalo…"
]

var personajes := []
var textos := []
var pasos_personajes := []

func _ready():
	personajes = [
		get_node("./vieja"),
		get_node("./ladron")
	]
	textos = [
		textoVieja,
		textoLadron
	]
	
	pasos_personajes = [
		mascarDataVieja,
		mascarDataLadron
	]
	
	estado = Estados.INICIO
	zonaTexto.text = "DALE A LA PUTA A"

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("tecla_a"):
		avanzar_juego()

func avanzar_juego():
	if estado == Estados.INICIO:
		personajes[personajes_i].get_node("AnimationPlayer").play("appear")
		personajes[personajes_i].get_node("./spriteObjeto/AnimationPlayer").play("appear")
		currentGrab = personajes[personajes_i].find_child("spriteObjeto") as objeto_sprite
		estado = Estados.HABLANDO
	elif estado == Estados.HABLANDO:
		if text_i < textos[personajes_i].size():
			zonaTexto.text = textos[personajes_i][text_i]
			text_i += 1
		else:
			if personajes_i == 0:
				zonaTexto.text = "Arrastra el objeto"
			shader.mouse_filter = Control.MOUSE_FILTER_IGNORE
			currentGrab.OnMouth.connect(OnObjetoArrastradoBoca)
			currentGrab.OnTrash.connect(OnObjetoArrastradoTrash)
			
	elif estado == Estados.SIGUIENTE_PJ:
		print(personajes.size())
		print(personajes_i)
		if personajes_i < personajes.size():
			personajes[personajes_i].get_node("AnimationPlayer").play("appear")
			personajes[personajes_i].get_node("./spriteObjeto/AnimationPlayer").play("appear")
			estado = Estados.HABLANDO
	elif estado == Estados.MASCAR:
		mascarMiniGame.next()

func OnMascarEnded():
	personajes[personajes_i].get_node("AnimationPlayer").play("disappear")
	mascarMiniGame.StepsEnded.disconnect(OnMascarEnded)
	GoNextPersonaje()
	
func  OnObjetoArrastradoTrash():
	currentGrab.OnTrash.disconnect(OnObjetoArrastradoTrash)
	currentGrab.OnMouth.disconnect(OnObjetoArrastradoBoca)
	GoNextPersonaje()

func  OnObjetoArrastradoBoca():
	currentGrab.OnTrash.disconnect(OnObjetoArrastradoTrash)
	currentGrab.OnMouth.disconnect(OnObjetoArrastradoBoca)
	GoEstadoMascar()

func GoEstadoMascar():
	mascarMiniGame.Initialize(pasos_personajes[personajes_i])
	estado = Estados.MASCAR
	mascarMiniGame.StepsEnded.connect(OnMascarEnded)

func GoNextPersonaje():
	estado = Estados.SIGUIENTE_PJ
	personajes_i += 1
	text_i = 0
	currentGrab = personajes[personajes_i].find_child("spriteObjeto") as objeto_sprite
	
