extends Node2D

var main_menue: PackedScene = load("res://levels/MainMenu.tscn")

func _unhandled_input(event: InputEvent) -> void:
	if not event is InputEventMouseButton:
		return
	if event.button_index != BUTTON_LEFT or not event.pressed:
		return
	get_tree().change_scene_to(main_menue)
