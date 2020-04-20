extends Node2D

export var lifePoints = 5;
export var boost_cost = 50;

var isBreached = false;
var _is_boosted = false

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


func _boost() -> void:
	if _is_boosted:
		return
	if PlayerData.power >= boost_cost:
		PlayerData.power -= boost_cost
		_is_boosted = true
		$TimerScore.wait_time = 0.5
		$TimerBoost.start()
		$AnimationPlayer.play("boosted")


func _end_boost() -> void:
	_is_boosted = false
	$TimerScore.wait_time = 1
	$TimerBoost.start()
	$AnimationPlayer.play("blink")
