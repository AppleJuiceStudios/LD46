extends Sprite

var _tex_bar_0    = preload("res://assets/door/bar_0.png");
var _tex_bar_1    = preload("res://assets/door/bar_1.png");
var _tex_bar_2    = preload("res://assets/door/bar_2.png");
var _tex_bar_3    = preload("res://assets/door/bar_3.png");
var _tex_bar_4    = preload("res://assets/door/bar_4.png");

export var generation_rate = 2.0
export var breachPointsLeft = 5;

export var isBreached = false;

func _process(delta: float) -> void:
	if not isBreached:
		PlayerData.power += delta * generation_rate

func getting_hit() -> bool:
	breachPointsLeft -= 1;
	if breachPointsLeft <= 0:
		isBreached = true;
		get_node("BreachBox1/CollisionShape2D").disabled = true
		get_node("AnimationPlayer").play("broken")
	_updateBreachBarTexture()
	return isBreached;

func _updateBreachBarTexture() -> void:
	if breachPointsLeft >= 5:
		get_node("Status Bar").texture = _tex_bar_4;
	elif breachPointsLeft == 4:
		get_node("Status Bar").texture = _tex_bar_3;
	elif breachPointsLeft == 3:
		get_node("Status Bar").texture = _tex_bar_2;
	elif breachPointsLeft == 2:
		get_node("Status Bar").texture = _tex_bar_1;
	elif breachPointsLeft == 1:
		get_node("Status Bar").texture = _tex_bar_0;
	elif breachPointsLeft <= 0:
		get_node("Status Bar").visible = false;
