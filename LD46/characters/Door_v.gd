extends "res://characters/Door.gd"

func _ready():
	_tex_open     = preload("res://assets/door/v_open.png");
	_tex_closed   = preload("res://assets/door/v_closed.png");
	_tex_breached = preload("res://assets/door/v_breached.png");
	_updateTexture()
	_setNavigatable(isOpen || isBreached);
