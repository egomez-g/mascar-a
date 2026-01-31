extends RigidBody2D

@export var maxForce: float
@export var minForce: float
@export var maxDistance: float
@export var minDistance: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	var gMousePos = get_global_mouse_position()
	var gPosition = global_position	
	var force = (gMousePos - gPosition).normalized() * maxForce	
	print(force)
	apply_central_force(force)
	pass
