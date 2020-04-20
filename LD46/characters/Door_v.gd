extends "res://characters/Door.gd"

export var tileNameFloorOpen : String
export var tileNameFloorClosed : String

func _ready():
	_tex_open     = preload("res://assets/door/v_open.png");
	_tex_closed   = preload("res://assets/door/v_closed.png");
	_tex_breached = preload("res://assets/door/v_breached.png");
	idFloorOpen = tileMap.get_tileset().find_tile_by_name(tileNameFloorOpen);
	idFloorClosed = tileMap.get_tileset().find_tile_by_name(tileNameFloorClosed);
	_updateTexture()
	_setNavigatable(isOpen || isBreached);
