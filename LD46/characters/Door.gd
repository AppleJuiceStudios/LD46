extends Sprite

var _tex_open     = preload("res://assets/door/open.png");
var _tex_closed   = preload("res://assets/door/closed.png");
var _tex_breached = preload("res://assets/door/breached.png");

var _txt_open     = preload("res://assets/door/txt_OpenDoor.png");
var _txt_close    = preload("res://assets/door/txt_CloseDoor.png");

var _tex_bar_0    = preload("res://assets/door/bar_0.png");
var _tex_bar_1    = preload("res://assets/door/bar_1.png");
var _tex_bar_2    = preload("res://assets/door/bar_2.png");
var _tex_bar_3    = preload("res://assets/door/bar_3.png");
var _tex_bar_4    = preload("res://assets/door/bar_4.png");

export var isOpen = false;
export var isBreached = false;
export var breachPointsLeft = 5;
var _bodyCount = 0;
var _powerMoveDoor = 10;
var _powerResetDoor = 30;

export var tileNameFloorOpen : String = "floor_walkable";
export var tileNameFloorClosed : String = "floor_not_walkable";
export var nodeTileMap : NodePath;
onready var tileMap : TileMap = get_node(nodeTileMap);
onready var idFloorOpen: int = tileMap.get_tileset().find_tile_by_name(tileNameFloorOpen);
onready var idFloorClosed: int = tileMap.get_tileset().find_tile_by_name(tileNameFloorClosed);

func _ready():
	_updateTexture()
	_setNavigatable(isOpen || isBreached);


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func getting_hit() -> bool:
	breachPointsLeft -= 1;
	_updateTexture()
	_setNavigatable(isOpen || isBreached);
	return isBreached;

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
	if isOpen:
		get_node("HoverMenu/BtnOpenClose").icon = _txt_close;
	else:
		get_node("HoverMenu/BtnOpenClose").icon = _txt_open;


func _setNavigatable(value:bool) -> void:
	if value:
		tileMap.set_cellv(tileMap.world_to_map(global_position),idFloorOpen);
	else:
		tileMap.set_cellv(tileMap.world_to_map(global_position),idFloorClosed);
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


func _on_BtnReset_pressed():
	if !isBreached && PlayerData.power >= _powerResetDoor:
		PlayerData.power -= _powerResetDoor;
		breachPointsLeft = 5;
		_updateTexture()

func _on_BtnOpenClose_pressed():
	if _bodyCount == 0 && PlayerData.power >= _powerMoveDoor:
		PlayerData.power -= _powerMoveDoor;
		isOpen = !isOpen;
		_updateTexture()
		_setNavigatable(isOpen || isBreached);

func _on_Button_mouse_entered():
	if !isBreached:
		get_node("HoverMenu").popup(
			Rect2(get_global_mouse_position() - Vector2(5,5),
				 Vector2(140,70)));

func _hover_exited():
	if !get_node("HoverMenu").get_rect().has_point(get_global_mouse_position()):
		get_node("HoverMenu").hide();


func _on_DoorClosingCollision_area_entered(area):
	_bodyCount += 1;
	
func _on_DoorClosingCollision_area_exited(area):
	_bodyCount -= 1;
