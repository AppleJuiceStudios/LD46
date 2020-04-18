extends Sprite

var _tex_open   = preload("res://assets/door/open.png")
var _tex_closed = preload("res://assets/door/closed.png")
export var isOpen = true;


func _ready():
	_updateTextureAndNavigation();


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _updateTextureAndNavigation() -> void:
	get_node("NavigationPolygonInstance").set_enabled(isOpen);
	if isOpen:
		texture = _tex_open;
	else:
		texture = _tex_closed;

func _on_Button_pressed():
	isOpen = !isOpen;
	_updateTextureAndNavigation();
