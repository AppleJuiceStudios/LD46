extends Area2D

var breaching_intruder : Node2D = null

func breach() -> bool:
	return self.get_parent().getting_hit()

func is_active() -> bool:
	return not self.get_child(0).disabled
