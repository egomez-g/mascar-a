extends Sprite2D
class_name objeto_sprite

var glow_tween: Tween
var selected:bool = false
var ini_pos:Vector2
var true_pos:Vector2
var pos_raton = Vector2(0, 0)
var original_position: Vector2
var basura_position: Vector2
var boca_position: Vector2
var padreBoca
var padreBasura
var fuerzaDelsake: int = 6
signal OnTrash
signal OnMouth
signal OnStartGrab

@export var boca: Node2D
@export var basura: Node2D
@export var isSakeable: bool

func _ready():
	ini_pos = global_position
	original_position = position
	padreBasura = basura.get_parent()
	padreBoca = boca.get_parent()
	basura_position = padreBasura.position
	boca_position = padreBoca.position

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if Input.is_action_just_pressed("click_izq"):
		OnStartGrab.emit()
		selected = true
		ini_pos = global_position
		isSakeable = false
	if Input.is_action_just_released("click_izq"):
		selected = false
		check_if_boca()
		isSakeable = true

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
		OnMouth.emit()
	elif dist_basura.x < 200 and dist_basura.y < 200:
		OnTrash.emit()
	else:
		global_position = ini_pos

func _process(delta: float):
	if isSakeable:
		position = position.lerp(original_position + Vector2(randf_range(-fuerzaDelsake, fuerzaDelsake), randf_range(-fuerzaDelsake, fuerzaDelsake)), 0.4)
	if selected:
		sakear_lo_demas()

func sakear_lo_demas():
	padreBoca.position = padreBoca.position.lerp(boca_position + Vector2(randf_range(-fuerzaDelsake, fuerzaDelsake), randf_range(-fuerzaDelsake, fuerzaDelsake)), 0.4)
	padreBasura.position = padreBasura.position.lerp(basura_position + Vector2(randf_range(-fuerzaDelsake, fuerzaDelsake), randf_range(-fuerzaDelsake, fuerzaDelsake)), 0.4)
	
