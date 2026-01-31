extends Node2D
class_name main

var enableInput: bool = false
var text_i: int = 0

@onready var animacionDealer = get_node("./dealer/AnimationPlayer")
@onready var animacionObjeto = get_node("./spriteObjeto/AnimationPlayer")
@onready var shader = $shader2
@onready var zonaTexto = $zonaTexto

var textos := [
	"DAME TODO LO QUE TENGAS JODEEER, ME ESTOY PONIENDO MUY NERVIOSO",
	"E-Eh vale vale, tranquilo colega… N-no hagas ninguna tontería",
	"¡¡¿¿ PERO QUE COJONES HACES ??!! ESTAS TOCADO DE LA CABEZA COLEGA, VAYA PUTA CIUDAD DE COLGADOS, ME PIRO DE AQUÍ",
	"¿Pero…? Mira, déjalo…"
]

func _ready():
	animacionDealer.play("appear")
	animacionObjeto.play("appear")
	_on_dealer_animation_finished("appear")

func _on_dealer_animation_finished(anim_name: StringName) -> void:
	enableInput = true

func _input(event: InputEvent) -> void:
	if enableInput:
		if Input.is_action_just_pressed("tecla_a"):
			if text_i < textos.size():
				zonaTexto.text = textos[text_i]
				text_i += 1
			else:
				shader.mouse_filter = Control.MOUSE_FILTER_IGNORE
