extends Node

onready var nav_2d : Navigation2D = $Navigation2D
onready var line_2d : Line2D = $RoombaLine
onready var character : Sprite = $VacuumRobot

func _unhandled_input(event: InputEvent) -> void:
	if not event is InputEventMouseButton:
		return
	if event.button_index != BUTTON_LEFT or not event.pressed:
		return
	event
	if PlayerData.power >= 20:
		var new_path : = nav_2d.get_simple_path(
			character.global_position, 
			event.global_position / 2);
		line_2d.points = new_path
		character.path = new_path
		if !new_path.empty():
			PlayerData.power -= 20;
