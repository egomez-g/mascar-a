extends Sprite2D

@export var Pepepe: Pasos
@onready var audio_player = $AudioStreamPlayer2D
var currentIndex: int = 0
var canGoNext: bool = true
var StepsEnded: Signal

func _ready() -> void:
	StepsEnded.connect(_printStepsEnd)

func _printStepsEnd() -> void:
	print("Steps ENded")	

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("click_izq"):
		next()

func Initialize(pasos: Pasos) -> void:
	Pepepe = pasos
	currentIndex = 0
	canGoNext = true

func next() -> void:
	if	canGoNext:
		if currentIndex != Pepepe.ahah.size():
			await  PlayAnimation()
			currentIndex += 1
		else:
			currentIndex = 0
			StepsEnded.emit()

func PlayAnimation() -> void:
	canGoNext = false
	audio_player.stream = Pepepe.ahah[currentIndex].sonido
	audio_player.play()
	texture = Pepepe.ahah[currentIndex].sprite1
	await  get_tree().create_timer(0.5).timeout
	texture = Pepepe.ahah[currentIndex].sprite2
	canGoNext = true
