extends Sprite2D

@export var pistolaAgarrar: objeto_sprite

func  _ready() -> void:
	pistolaAgarrar.OnStartGrab.connect(EnableVisibility)
	pistolaAgarrar.modulate.a = 0.0
	print("QUELOQUE")
	
func EnableVisibility() -> void:
	pistolaAgarrar.modulate.a = 1.0
	print("pero")
