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

func _ready():
	estado = Estados.INICIO
	zonaTexto.text = "DALE A LA PUTA A"

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("tecla_a"):
		avanzar_juego()

func avanzar_juego():
	if estado == Estados.INICIO:
		nodosPersonaje[personajes_i].get_node("AnimationPlayer").play("appear")
		nodosPersonaje[personajes_i].get_node("./spriteObjeto/AnimationPlayer").play("appear")
		currentGrab = nodosPersonaje[personajes_i].find_child("spriteObjeto") as objeto_sprite
		estado = Estados.HABLANDO
	elif estado == Estados.HABLANDO:
		if text_i < personajes[personajes_i].textoIntro.size():
			zonaTexto.text = personajes[personajes_i].textoIntro[text_i]
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
			nodosPersonaje[personajes_i].get_node("AnimationPlayer").play("appear")
			nodosPersonaje[personajes_i].get_node("./spriteObjeto/AnimationPlayer").play("appear")
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
	mascarMiniGame.Initialize(personajes[personajes_i].mascarData)
	estado = Estados.MASCAR
	mascarMiniGame.StepsEnded.connect(OnMascarEnded)

func GoNextPersonaje():
	nodosPersonaje[personajes_i].get_node("AnimationPlayer").play("disappear")
	if personajes_i < personajes.size():
		personajes_i += 1
		text_i = 0
		currentGrab = personajes[personajes_i].find_child("spriteObjeto") as objeto_sprite
		estado = Estados.SIGUIENTE_PJ
	
