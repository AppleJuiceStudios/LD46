extends Node2D

export var spawn_intervall : = 2.0
export var goal_path : NodePath
export var nav_2d_path : NodePath

onready var nav_2d : Navigation2D = get_node(nav_2d_path)

onready var intruder_scene : = preload("res://characters/Intruder.tscn")

var spawn_area_X : = 8
var spawn_area_Y : = 24

var _spawner_cool_down : = 0.0 

func _process(delta: float) -> void:
	nav_2d.add_heat(global_position + Vector2.UP, delta * 10)
	nav_2d.add_heat(global_position + Vector2.DOWN, delta * 10)
	_spawner_cool_down -= delta
	if _spawner_cool_down <= 0.0:
		spawn_intruder()
		_spawner_cool_down += spawn_intervall

func spawn_intruder() -> void:
	print("instance")
	var pos : = Vector2(rand_range(-spawn_area_X, spawn_area_X), rand_range(-spawn_area_Y, spawn_area_Y))
	var intruder : Node = intruder_scene.instance()
	intruder.goal_path = goal_path
	intruder.nav_2d_path = nav_2d_path
	intruder.home_path = get_path()
	intruder.global_position = global_position + pos
	print("Add as child")
	get_parent().add_child(intruder)
