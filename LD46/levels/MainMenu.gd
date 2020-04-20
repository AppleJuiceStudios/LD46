extends Node2D

export var level1: PackedScene
export var level2: PackedScene
export var level3: PackedScene
export var level4: PackedScene
export var tutorial: PackedScene

func _on_BtnLvl1_pressed():
	get_tree().change_scene_to(level1)

func _on_BtnLvl2_pressed():
	get_tree().change_scene_to(level2)

func _on_BtnLvl3_pressed():
	get_tree().change_scene_to(level3)

func _on_BtnLvl4_pressed():
	get_tree().change_scene_to(level4)

func _on_BtnTutorial_pressed():
	get_tree().change_scene_to(tutorial)
