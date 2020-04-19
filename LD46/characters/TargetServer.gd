extends Node2D

export var lifePoints = 50;
var isBreached = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func getting_hit() -> bool:
	lifePoints -= 1;
	if lifePoints <= 0:
		isBreached = true;
	return isBreached;
