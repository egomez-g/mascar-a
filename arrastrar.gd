extends Sprite2D
class_name objeto_sprite

var selected:bool = false
var ini_pos:Vector2

func _process(delta):
	if (selected):
		position = get_global_mouse_position()

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if Input.is_action_just_pressed("click_izq"):
		print("pinfga")
		selected = true
		ini_pos = global_position
	if Input.is_action_just_released("click_izq"):
		selected = false
		global_position = ini_pos

# func _physics_process(delta: float) -> void:
# 	if selected:
# 		global_position = lerp(global_position, get_global_mouse_position(), 25 * delta)
# 		look_at(get_global_mouse_position())
# 	else:
# 		global_position = lerp(global_position, ini_pos, 25 * delta)
# 		rotation  = lerp_angle(rotation, 0, 5 * delta)