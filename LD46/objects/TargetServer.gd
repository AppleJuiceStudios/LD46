extends Node2D

export var lifePoints = 30;
var isBreached = false;

var defeatScene: PackedScene = load("res://levels/GameOver.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func getting_hit() -> bool:
	lifePoints -= 1;
	if lifePoints <= 0:
		isBreached = true;
		get_tree().change_scene_to(defeatScene)
	return isBreached;


func _on_Timer_timeout() -> void:
	PlayerData.score += 1
