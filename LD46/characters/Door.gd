extends Sprite

var _tex_open     = preload("res://assets/door/open.png");
var _tex_closed   = preload("res://assets/door/closed.png");
var _tex_breached = preload("res://assets/door/breached.png");
export var isOpen = true;
export var isBreached = false;
export var breachPointsLeft = 5;

func _ready():
	_updateTextureAndNavigation();


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

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
