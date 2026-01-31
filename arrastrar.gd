extends Sprite2D
class_name objeto_sprite

var glow_tween: Tween
var selected:bool = false
var ini_pos:Vector2
var true_pos:Vector2
var polla = 0
var pos_raton = Vector2(0, 0)
@onready var boca = get_node("../../boca/pos_boca")
@onready var basura = get_node("../../basura/pos_basura")

@export var isSakeable: bool

func _ready():
	ini_pos = global_position

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if Input.is_action_just_pressed("click_izq"):
		selected = true
		ini_pos = global_position
	if Input.is_action_just_released("click_izq"):
		selected = false
		check_if_boca()

func _physics_process(delta: float) -> void:
	if selected:
		global_position = lerp(global_position, get_global_mouse_position(), 25 * delta)
		look_at(get_global_mouse_position())
	else:
		global_position = lerp(global_position, ini_pos, 25 * delta)
		rotation  = lerp_angle(rotation, 0, 5 * delta)

func check_if_boca():
	var dist_boca = get_global_mouse_position() - boca.global_position
	var dist_basura = get_global_mouse_position() - basura.global_position
	if dist_boca.x < 200 and dist_boca.y < 200:
		print("boca")
	elif dist_basura.x < 200 and dist_basura.y < 200:
		print ("basura")
	else:
		global_position = ini_pos

func _process(delta: float):
	if isSakeable:
		sakear()
	else:
		desSakear()

func sakear():
	brillo()

func desSakear():
	desbrillo()

func brillo():
	glow_tween = create_tween()
	glow_tween.set_loops()
	glow_tween.tween_property(
		$Sprite2D,
		"modulate",
		Color(1.3, 1.3, 1.3),
		0.15
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	glow_tween.tween_property(
		$Sprite2D,
		"modulate",
		Color(1.0, 1.0, 1.0),
		0.15
	)

func desbrillo():
	if glow_tween:
		glow_tween.kill()
	$Sprite2D.modulate = Color(1, 1, 1)