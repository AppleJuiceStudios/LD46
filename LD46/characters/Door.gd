extends Button

var _tex_open   = preload("res://assets/door/open.png")
var _tex_closed = preload("res://assets/door/closed.png")
var isOpen = true;


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_pressed():
	isOpen = !isOpen;
	get_parent().get_node("NavigationPolygonInstance").set_enabled(isOpen);
	if isOpen:
		get_parent().texture = _tex_open;
	else:
		get_parent().texture = _tex_closed;
