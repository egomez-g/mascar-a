extends Sprite2D
class_name objeto_sprite

var selected:bool = false
var ini_pos:Vector2
var true_pos:Vector2
var polla = 0
var pos_raton = Vector2(0, 0)
@onready var boca = get_node("../../boca/pos_boca")
@onready var basura = get_node("../../basura/pos_basura")


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
