extends Node2D

onready var nav_2d : Navigation2D = $Navigation2D
onready var line_2d : Line2D = $RoombaLine
onready var character : Sprite = $VacuumRobot

func _process(delta: float) -> void:
	if Input.is_action_pressed("ui_cancel"):
		get_tree().change_scene("res://levels/MainMenu.tscn")

func _unhandled_input(event: InputEvent) -> void:
	if not event is InputEventMouseButton:
		return
	if event.button_index != BUTTON_LEFT or not event.pressed:
		return
	if PlayerData.power >= 20:
		var new_path : = nav_2d.get_simple_path(
			character.global_position, 
			get_global_mouse_position());
		line_2d.points = new_path
		character.path = new_path
		if !new_path.empty():
			PlayerData.power -= 20;
