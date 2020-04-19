extends "res://characters/Door.gd"

func _ready():
	_tex_open     = preload("res://assets/door/h_open.png");
	_tex_closed   = preload("res://assets/door/h_closed.png");
	_tex_breached = preload("res://assets/door/h_breached.png");
	_updateTexture()
	_setNavigatable(isOpen || isBreached);
