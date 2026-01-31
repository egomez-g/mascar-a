extends Node2D
class_name cursor

var cursor_texture_pressed = preload("res://espirites/cursorPressed.png")
var cursor_texture_unpressed = preload("res://espirites/cursorNotPressed.png")

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				Input.set_custom_mouse_cursor(cursor_texture_pressed)
			else:
				Input.set_custom_mouse_cursor(cursor_texture_unpressed)