extends Node2D

export var next_scene: PackedScene

func _unhandled_input(event: InputEvent) -> void:
	if not event is InputEventMouseButton:
		return
	if event.button_index != BUTTON_LEFT or not event.pressed:
		return
	if next_scene:
		get_tree().change_scene_to(next_scene)
	else:
		get_tree().change_scene("res://levels/MainMenu.tscn")
