extends Sprite

var _tex_open     = preload("res://assets/door/open.png");
var _tex_closed   = preload("res://assets/door/closed.png");
var _tex_breached = preload("res://assets/door/breached.png");

var _tex_bar_0    = preload("res://assets/door/bar_0.png");
var _tex_bar_1    = preload("res://assets/door/bar_1.png");
var _tex_bar_2    = preload("res://assets/door/bar_2.png");
var _tex_bar_3    = preload("res://assets/door/bar_3.png");
var _tex_bar_4    = preload("res://assets/door/bar_4.png");

export var isOpen = true;
export var isBreached = false;
export var breachPointsLeft = 5;

func _ready():
	_updateTextureAndNavigation();


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func getting_hit() -> void:
	breachPointsLeft -= 1;
	if breachPointsLeft >= 4:
		get_node("Status Bar").texture = _tex_bar_4;
	elif breachPointsLeft == 3:
		get_node("Status Bar").texture = _tex_bar_3;
	elif breachPointsLeft == 2:
		get_node("Status Bar").texture = _tex_bar_2;
	elif breachPointsLeft == 1:
		get_node("Status Bar").texture = _tex_bar_1;
	elif breachPointsLeft <= 0:
		get_node("Status Bar").texture = _tex_bar_0;

func _updateTextureAndNavigation() -> void:
	if breachPointsLeft <= 0:
		isBreached = true;
	get_node("NavigationPolygonInstance").set_enabled(isOpen || isBreached);
	if isBreached:
		texture = _tex_breached;
	elif isOpen:
		texture = _tex_open;
	else:
		texture = _tex_closed;

func _on_Button_pressed():
	isOpen = !isOpen;
	_updateTextureAndNavigation();
