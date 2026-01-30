extends Node2D
class_name main

var enableMouse:bool = false


func _ready():
	_on_dealer_animation_finished("appear")

func _on_dealer_animation_finished(anim_name: StringName) -> void:
	enableMouse = true