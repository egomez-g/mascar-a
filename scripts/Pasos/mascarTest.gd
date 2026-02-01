extends Sprite2D
class_name  MascarMinGame

@export var _pasos: Pasos
@export var _mascarArea: Area2D
@onready var audio_player = $AudioStreamPlayer2D
var currentIndex: int = 0
var ini_pos: Vector2
var fuerzaDelsake: int = 12
var playSake: bool = false
var canGoNext: bool = true
var lastRandValue = -0.1
signal StepsEnded
@export var bocaNeutra: Texture

@export var _bocaAbierta: Texture

func _ready() -> void:
	StepsEnded.connect(_printStepsEnd)
	_mascarArea.area_entered.connect(OnAreaEntered)
	_mascarArea.area_exited.connect(OnAreaExit)
	ini_pos = position

func _printStepsEnd() -> void:
	print("Steps ENded")	

#func _process(delta: float) -> void:
	#if Input.is_action_just_pressed("click_izq"):
	#	next()

func OnAreaEntered(area: Area2D):
	texture = _bocaAbierta

func OnAreaExit(area: Area2D):
	texture = bocaNeutra

func Initialize(pasos: Pasos) -> void:
	_pasos = pasos
	currentIndex = 0
	canGoNext = true

func next() -> void:
	if	canGoNext:
		if currentIndex != _pasos._pasos.size():
			await  PlayAnimation()
			currentIndex += 1
		else:
			rotation = 0
			currentIndex = 0
			StepsEnded.emit()

func PlayAnimation() -> void:
	playSake = true
	if lastRandValue <= 0:
		rotation = randf_range(0.2, 0.08)
	else:
		rotation = randf_range(-0.2, -0.08)
	lastRandValue = rotation
	canGoNext = false
	audio_player.stream = _pasos._pasos[currentIndex].sonido
	audio_player.play()
	texture = _pasos._pasos[currentIndex].sprite1
	await  get_tree().create_timer(0.5).timeout
	texture = _pasos._pasos[currentIndex].sprite2
	canGoNext = true
	playSake = false

func _process(delta: float) -> void:
	if playSake:
		position = position.lerp(ini_pos + Vector2(randf_range(-fuerzaDelsake, fuerzaDelsake), randf_range(-fuerzaDelsake, fuerzaDelsake)), 0.4)
