extends "res://characters/Door.gd"

export var tileNameFloorOpen : String
export var tileNameFloorClosed : String

func _ready():
	mouse_area_X = 26
	mouse_area_Y = 16
	_tex_open     = preload("res://assets/door/h_open.png");
	_tex_closed   = preload("res://assets/door/h_closed.png");
	_tex_breached = preload("res://assets/door/h_breached.png");
	idFloorOpen = tileMap.get_tileset().find_tile_by_name(tileNameFloorOpen);
	idFloorClosed = tileMap.get_tileset().find_tile_by_name(tileNameFloorClosed);
	_updateTexture()
	_setNavigatable(isOpen || isBreached);
	
