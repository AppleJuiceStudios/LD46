extends Sprite

export var speed : = 60.0
export var speed_idle := 20.0
export var goal_path : NodePath
export var nav_2d_path : NodePath

onready var goal : Node2D = get_node(goal_path)
onready var nav_2d : Navigation2D = get_node(nav_2d_path)

const IDLE_STEP_LENGTH : = 32
const IDLE_ANGLE_DEVISIONS : = 16

const STATE_WALK_TO_GOAL : = 0
const STATE_IDLE : = 1
const STATE_WALK_TO_DOOR : = 2
const STATE_BREACH_DOOR : = 3

var _current_state : = STATE_WALK_TO_GOAL
var _path : = PoolVector2Array()
var _idle_target : = Vector2.ZERO

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	
	if _current_state == STATE_WALK_TO_GOAL:
		_path = nav_2d.get_simple_path(global_position, goal.global_position)
		if _path.empty():
			_current_state = STATE_IDLE
		else:
			start_move_along_path(speed * delta)
	
	elif _current_state == STATE_IDLE:
		if _idle_target != Vector2.ZERO:
			_path = nav_2d.get_simple_path(global_position, _idle_target)
			if _path.empty():
				_idle_target = Vector2.ZERO
		
		# generate new target
		if _idle_target == Vector2.ZERO:
			# check if goal is reachable
			_path = nav_2d.get_simple_path(global_position, goal.global_position)
			if not _path.empty():
				_current_state = STATE_WALK_TO_GOAL
				_idle_target = Vector2.ZERO
				return
			
			var direction : = polar2cartesian(IDLE_STEP_LENGTH, rand_range(0, 2 * PI))
			var i : = 0
			while (_path.empty() or get_path_length(_path) > 2 * IDLE_STEP_LENGTH) and i < IDLE_ANGLE_DEVISIONS :
				_idle_target = global_position + direction
				_path = nav_2d.get_simple_path(global_position, _idle_target)
				direction = direction.rotated(PI / (IDLE_ANGLE_DEVISIONS * 2))
				i += 1
			if i == IDLE_ANGLE_DEVISIONS:
				_idle_target = Vector2.ZERO
		
		if _idle_target != Vector2.ZERO:
			if start_move_along_path(speed_idle * delta):
				_idle_target = Vector2.ZERO

# returns if it finished path
func start_move_along_path(distance: float) -> bool:
	_path.remove(0)
	var start_point := position
	for i in range(_path.size()):
		var distance_to_next : = start_point.distance_to(_path[0])
		if distance <= distance_to_next:
			position = start_point.linear_interpolate(_path[0], distance / distance_to_next)
			return false
		distance -= distance_to_next
		start_point = _path[0]
		_path.remove(0)
	return true


func _on_door_area_entered(area: Area2D) -> void:
	var path : = nav_2d.get_simple_path(global_position, area.global_position)
	if get_path_length(path) < 2* 60:
		_current_state = STATE_WALK_TO_DOOR


func get_path_length(path: PoolVector2Array) -> float:
	var length : = 0.0
	for i in range(path.size()):
		length += path[i].distance_to(path[i+1])
	return length
