extends Sprite

export var speed : = 60.0
export var speed_idle : = 20.0
export var breaching_speed : = 1.5
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
var _breaching_target : Area2D = null
var _breaching_cooldow : = 0.0

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
			
			var nav_poly : PoolVector2Array = nav_2d.get_nav_pol_with_lowest_heat(global_position, 2.0)
			_idle_target = get_random_point_in_polygon(nav_poly)
			_path = nav_2d.get_simple_path(global_position, _idle_target)
			if _path.empty():
				print("Path error")
			else:
				print("Path success!")
		
		if _idle_target != Vector2.ZERO:
			if start_move_along_path(speed_idle * delta):
				_idle_target = Vector2.ZERO
	
	elif _current_state == STATE_WALK_TO_DOOR:
		if not _breaching_target.is_active():
			_breaching_target.breaching_intruder = null
			_current_state = STATE_WALK_TO_GOAL
			return
		_path = nav_2d.get_simple_path(global_position, _breaching_target.global_position)
		if _path.empty():
			_current_state = STATE_WALK_TO_GOAL
			print("Path is empty")
		else:
			if start_move_along_path(speed * delta):
				_breaching_cooldow = breaching_speed
				_current_state = STATE_BREACH_DOOR
	
	elif _current_state == STATE_BREACH_DOOR:
		if not _breaching_target.is_active():
			_breaching_target.breaching_intruder = null
			_current_state = STATE_WALK_TO_GOAL
			return
		_breaching_cooldow -= delta
		if _breaching_cooldow <= 0.0:
			_breaching_target.breach()
			_breaching_cooldow += breaching_speed
		
	
# returns if it finished path
func start_move_along_path(distance: float) -> bool:
	nav_2d.add_heat(global_position, get_physics_process_delta_time())
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
	if _current_state == STATE_WALK_TO_DOOR or _current_state == STATE_BREACH_DOOR:
		return
	if area.breaching_intruder != null or not area.is_active():
		return
	var path : = nav_2d.get_simple_path(global_position, area.global_position)
	if get_path_length(path) < 2* 60:
		area.breaching_intruder = self
		_breaching_target = area
		_current_state = STATE_WALK_TO_DOOR


func get_path_length(path: PoolVector2Array) -> float:
	var length : = 0.0
	for i in range(path.size() - 1):
		length += path[i].distance_to(path[i+1])
	return length

func get_random_point_in_polygon(points : PoolVector2Array) -> Vector2:
	var minX : = 10000.0
	var minY : = 10000.0
	var maxX : = -10000.0
	var maxY : = -10000.0
	print("polygon:")
	for i in range(points.size()):
		print(points[i])
		if points[i].x < minX:
			minX = points[i].x
		if points[i].y < minY:
			minY = points[i].y
		if points[i].x > maxX:
			maxX = points[i].x
		if points[i].y > maxY:
			maxY = points[i].y
	return Vector2(rand_range(minX, maxX), rand_range(minY, maxY))
