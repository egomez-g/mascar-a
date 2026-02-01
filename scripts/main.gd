extends Node2D
class_name main

enum Estados {
	INTRO,
	INICIO,
	HABLANDO,
	SIGUIENTE_PJ,
	MASCAR,
	HABLANDOPOST,
	OUTRO
}

@export var introTexts : Array[String]
@export var outroTexts : Array[String]

@export var blackScreenOverlay: Control
@export var MascarTitulo : Label
@export var MascarTituloA : Label
@export var TextoIntro : Label


@export var sonidoPasarTexto: AudioStreamPlayer2D
@export var sonidoMordisco: AudioStreamPlayer2D
@export var background: AudioStreamPlayer2D
@export var sonidoBasura: AudioStreamPlayer2D
@export var sonidoGrab: AudioStreamPlayer2D

var text_i: int = 0
var personajes_i: int = 0

var estado: int

@export var mascarMiniGame : MascarMinGame

@onready var shader = $shader2
@onready var zonaTexto = $zonaTexto

var mascado : bool
var currentGrab : objeto_sprite

@export var personajes : Array[Personaje]
@export var nodosPersonaje : Array[Sprite2D]

func  get_current_personaje_data() -> Personaje:
	return personajes[personajes_i]

func  get_current_personaje_node() -> Sprite2D:
	return nodosPersonaje[personajes_i]

func _ready():
	blackScreenOverlay.visible = true
	estado = Estados.INTRO
	zonaTexto.text = ""
	for nodoPersonaje in nodosPersonaje:
		(nodoPersonaje.find_child("CollisionShape2D") as CollisionShape2D).disabled = true

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("tecla_a"):
		avanzar_juego()

func avanzar_juego():
	if  estado == Estados.INTRO:
		if MascarTitulo.visible == false:
			if text_i < introTexts.size():
				TextoIntro.text = introTexts[text_i]
				sonidoPasarTexto.play()
				text_i += 1
			else: 
				estado = Estados.INICIO
				blackScreenOverlay.visible = false
				text_i = 0
		else:
			TextoIntro.visible = true
			MascarTitulo.visible = false
			MascarTituloA.visible = false
			TextoIntro.text = ""
			sonidoMordisco.play()
			
	elif estado == Estados.INICIO:
		UpdateCurrentPersonaje()
		get_current_personaje_node().get_node("AnimationPlayer").play("appear")
		get_current_personaje_node().get_node("./spriteObjeto/AnimationPlayer").play("appear")
		currentGrab = get_current_personaje_node().find_child("spriteObjeto") as objeto_sprite
		estado = Estados.HABLANDO
	elif estado == Estados.HABLANDO:
		if text_i < get_current_personaje_data().textoIntro.size():
			zonaTexto.text = get_current_personaje_data().textoIntro[text_i]
			text_i += 1
			sonidoPasarTexto.play()
		else:
			if personajes_i == 0:
				mascarMiniGame.visible = true
			get_current_personaje_node().get_node("spriteObjeto").isSakeable = true
			zonaTexto.text = ""
			currentGrab.OnStartGrab.connect(OnStartGrab)
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
				sonidoPasarTexto.play()
			else:
				NextPersonajeOrEnd()
		else:
			if text_i < get_current_personaje_data().textoPostThrash.size():
				zonaTexto.text = get_current_personaje_data().textoPostThrash[text_i]
				text_i += 1
				sonidoPasarTexto.play()
			else:
				NextPersonajeOrEnd()
	elif  estado == Estados.OUTRO:
		if text_i < outroTexts.size():
			TextoIntro.text = outroTexts[text_i]
			text_i += 1
			sonidoPasarTexto.play()

func NextPersonajeOrEnd():
	if personajes_i == personajes.size() - 1:
		blackScreenOverlay.visible = true
		TextoIntro.visible = true
		TextoIntro.text = ""
		text_i = 0
		estado = Estados.OUTRO
	else:
		GoNextPersonaje()


func OnStartGrab():
	currentGrab.OnStartGrab.disconnect(OnStartGrab)
	if get_current_personaje_data().onObjetoCogidoTexture != null:
		(get_current_personaje_node() as Sprite2D).texture = get_current_personaje_data().onObjetoCogidoTexture

func OnMascarEnded():
	mascarMiniGame.StepsEnded.disconnect(OnMascarEnded)
	if get_current_personaje_data().mascarData.onMascarEnd:
		get_current_personaje_node().texture = get_current_personaje_data().mascarData.onMascarEnd
	estado = Estados.HABLANDOPOST
	mascado = true
	text_i = 0
	
func  OnObjetoArrastradoTrash():
	sonidoBasura.play()
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
		UpdateCurrentPersonaje()
		shader.mouse_filter = Control.MOUSE_FILTER_STOP
		estado = Estados.SIGUIENTE_PJ

func  UpdateCurrentPersonaje():
	(get_current_personaje_node().find_child("CollisionShape2D") as CollisionShape2D).disabled = false
	currentGrab = get_current_personaje_node().find_child("spriteObjeto") as objeto_sprite
