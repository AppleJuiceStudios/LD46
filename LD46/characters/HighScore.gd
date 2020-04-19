extends Label


var _paperclips = 0;


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	_paperclips += 1;
	text = String(_paperclips) + " paperclips done."
