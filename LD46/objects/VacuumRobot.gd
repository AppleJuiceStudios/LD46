extends Sprite

export var speed : = 400.0
var path : = PoolVector2Array() setget set_path

onready var collider : Area2D = $Area2D


func _ready() -> void:
	collider.monitorable = false
	set_process(false)

func _process(delta: float) -> void:
	move_along_path(speed * delta)

func move_along_path(distance: float) -> void:
	var start_point := position
	if path.size() == 0:
		get_parent().get_node("RoombaLine").points = [];
		collider.monitorable = false
		set_process(false)
	for i in range(path.size()):
		var distance_to_next : = start_point.distance_to(path[0])
		if distance <= distance_to_next and distance >= 0.0:
			position = start_point.linear_interpolate(path[0], distance / distance_to_next);
			rotation_degrees = ((position - start_point).angle() * 57.2958) + 90;
			break;
		elif distance <= 0.0:
			position = path[0]
			collider.monitorable = false
			set_process(false)
			break
		distance -= distance_to_next
		start_point = path[0]
		path.remove(0)

func set_path(value : PoolVector2Array) -> void:
	path = value
	if value.size() == 0:
		return
	collider.monitorable = true
	set_process(true)
