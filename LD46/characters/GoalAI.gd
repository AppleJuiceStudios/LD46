extends Sprite

export var speed : = 400.0
export var goal : NodePath
export var nav_2d : NodePath

const STATE_WALK_TO_GOAL : = 0
const STATE_WALK_RANDOM : = 1
const STATE_REACHED_GOAL : = 2

var _current_state : = STATE_WALK_TO_GOAL
var _path : = PoolVector2Array()

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if _current_state == STATE_WALK_TO_GOAL:
		_path = get_node(nav_2d).get_simple_path(global_position, get_node(goal).global_position)
		if _path.empty():
			_current_state == STATE_WALK_RANDOM
		else:
			move_along_path(_path, speed * delta)
	elif _current_state == STATE_WALK_RANDOM:
		if _path.empty():
			_path = get_node(nav_2d).get_simple_path(global_position, get_node(goal).global_position)
			if _path.empty():
				_current_state = STATE_WALK_TO_GOAL
			var direction : = polar2cartesian(32, rand_range(0, 2 * PI))
			while _path.empty():
				_path = get_node(nav_2d).get_simple_path(global_position, global_position + direction)
				direction = direction.rotated(PI/8)
		move_along_path(_path, speed * delta)

func move_along_path(path : PoolVector2Array, distance: float) -> void:
	var start_point := position
	for i in range(path.size()):
		var distance_to_next : = start_point.distance_to(path[0])
		if distance <= distance_to_next and distance >= 0.0:
			position = start_point.linear_interpolate(path[0], distance / distance_to_next)
			break
		elif distance <= 0.0:
			position = path[0]
			set_process(false)
			break
		distance -= distance_to_next
		start_point = path[0]
		path.remove(0)
