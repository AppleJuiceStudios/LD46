extends Node

onready var nav_2d : Navigation2D = $Navigation2D
onready var line_2d : Line2D = $Line2D
onready var character : Sprite = $VacuumRobot

func _unhandled_input(event: InputEvent) -> void:
	if not event is InputEventMouseButton:
		return
	if event.button_index != BUTTON_LEFT or not event.pressed:
		return
	event
	var new_path : = nav_2d.get_simple_path(character.global_position, event.global_position)
	line_2d.points = new_path
	character.path = new_path
