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
	_updateTexture()
	_setNavigatable(isOpen || isBreached);


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func getting_hit() -> void:
	breachPointsLeft -= 1;
	_updateTexture()
	_setNavigatable(isOpen || isBreached);

func _updateTexture() -> void:
	if breachPointsLeft <= 0:
		isBreached = true;
	_updateBreachBarTexture()
	if isBreached:
		texture = _tex_breached;
	elif isOpen:
		texture = _tex_open;
	else:
		texture = _tex_closed;

func _setNavigatable(value:bool) -> void:
	get_node("NavigationPolygonInstance").set_enabled(value);
	get_node("BreachBox1/CollisionShape2D").disabled = value;
	get_node("BreachBox2/CollisionShape2D").disabled = value;
	

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
	
func _on_Button_pressed():
	isOpen = !isOpen;
	_updateTexture()
	_setNavigatable(isOpen || isBreached);


func _on_Button_mouse_entered():
	get_node("HoverMenu").popup();


func _on_Button_mouse_exited():
	get_node("HoverMenu").hide();
