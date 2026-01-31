extends Sprite2D

@export var pistolaAgarrar: objeto_sprite

func  _ready() -> void:
	pistolaAgarrar.OnStartGrab.connect(EnableVisibility)
	pistolaAgarrar.visible = false;
	
func EnableVisibility() -> void:
	pistolaAgarrar.visible = true;
