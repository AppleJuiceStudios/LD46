extends Sprite

export var speed : = 60.0
export var speed_idle : = 20.0
export var breaching_speed : = 1.5
export var max_motivation : = 100.0
export var goal_path : NodePath
export var nav_2d_path : NodePath
export var home_path : NodePath

onready var server : Node2D = get_node(goal_path)
onready var nav_2d : Navigation2D = get_node(nav_2d_path)
onready var home : Node2D = get_node(home_path)
onready var motivation_bar : ProgressBar = $MotivationBar
onready var anim_player : AnimationPlayer = $AnimationPlayer

onready var detector_breach_point : Area2D = $BreachPointDetector
onready var detector_vacuum_robot : Area2D = $VacuumRobotDetector
onready var detector_speaker : Area2D = $SpeakerDetector
onready var detector_dance : Area2D = $DanceDetector
onready var detector_screen : Area2D = $ScreenDetector

const IDLE_STEP_LENGTH : = 32
const IDLE_ANGLE_DEVISIONS : = 16

const STATE_WALK_TO_GOAL : = 0
const STATE_IDLE : = 1
const STATE_WALK_TO_BREACH_POINT : = 2
const STATE_BREACHING : = 3
const STATE_FALLING : = 4
const STATE_DANCE : = 5
const STATE_WATCH_SCREEN : = 6

var _current_state : = STATE_WALK_TO_GOAL
var _motivation : = max_motivation
var _goal : Node2D
var _returning_home : = false
var _is_scared : = false
var _path : = PoolVector2Array()
var _idle_target : = Vector2.ZERO
var _breaching_target : Area2D = null
var _breaching_cooldow : = 0.0

func _ready() -> void:
	motivation_bar.max_value = max_motivation
	motivation_bar.value = _motivation
	pass

func _process(delta: float) -> void:
	if _returning_home or _is_scared:
		if global_position.distance_to(home.global_position) < 4:
			queue_free()
			return
	if _motivation <= 0.0 :
		_motivation = 0.0
		_returning_home = true
	elif _motivation > max_motivation:
		_motivation = max_motivation
	motivation_bar.value = _motivation
	
	var last_goal = _goal
	if _returning_home or _is_scared:
		_goal = home
	elif not detector_speaker.get_overlapping_areas().empty():
		_goal = detector_speaker.get_overlapping_areas()[0]
	else:
		_goal = server
	if last_goal != _goal and _current_state == STATE_IDLE:
		change_state(STATE_WALK_TO_GOAL)
	
	check_interruptions()
	
	if _current_state == STATE_WALK_TO_GOAL:
		_path = nav_2d.get_simple_path(global_position, _goal.global_position)
		if _path.empty():
			change_state(STATE_IDLE)
		else:
			start_move_along_path(speed * delta * motivation_spee_factor())
	
	elif _current_state == STATE_IDLE:
		_motivation -= delta * 0.5
		
		if _idle_target != Vector2.ZERO:
			_path = nav_2d.get_simple_path(global_position, _idle_target)
			if _path.empty():
				_idle_target = Vector2.ZERO
		
		# generate new target
		if _idle_target == Vector2.ZERO:
			# check if goal is reachable
			_path = nav_2d.get_simple_path(global_position, _goal.global_position)
			if not _path.empty():
				change_state(STATE_WALK_TO_GOAL)
				return
			
			var nav_poly : PoolVector2Array = nav_2d.get_nav_pol_with_lowest_heat(global_position, 1.5)
			_idle_target = get_random_point_in_polygon(nav_poly)
			_path = nav_2d.get_simple_path(global_position, _idle_target)
		
		if _idle_target != Vector2.ZERO:
			if start_move_along_path(speed_idle * delta * motivation_spee_factor()):
				_idle_target = Vector2.ZERO
	
	elif _current_state == STATE_WALK_TO_BREACH_POINT:
		if not _breaching_target.is_active():
			change_state(STATE_WALK_TO_GOAL)
			return
		_path = nav_2d.get_simple_path(global_position, _breaching_target.global_position)
		if _path.empty():
			change_state(STATE_WALK_TO_GOAL)
		else:
			if start_move_along_path(speed * delta * motivation_spee_factor()):
				change_state(STATE_BREACHING)
	
	elif _current_state == STATE_BREACHING:
		if _motivation <= 0.0:
			change_state(STATE_WALK_TO_GOAL)
		if not _breaching_target.is_active():
			change_state(STATE_WALK_TO_GOAL)
			return
		_breaching_cooldow -= delta
		if _breaching_cooldow <= 0.0:
			_breaching_target.breach()
			_breaching_cooldow += breaching_speed / motivation_spee_factor()
	
	elif _current_state == STATE_FALLING:
		if anim_player.current_animation_position >= anim_player.current_animation_length:
			change_state(STATE_WALK_TO_GOAL)
	
	elif _current_state == STATE_DANCE:
		annoy(delta * 5)
		if detector_dance.get_overlapping_areas().empty():
			change_state(STATE_WALK_TO_GOAL)
		elif randf() < delta * 0.4:
			update_animation()
	
	elif _current_state == STATE_WATCH_SCREEN:
		annoy(delta * 5)
		if detector_screen.get_overlapping_areas().empty():
			change_state(STATE_WALK_TO_GOAL)
			_is_scared = true

func change_state(state) -> void:
	if state == _current_state:
		return
	if _current_state == STATE_BREACHING:
		_breaching_target.breaching_intruder = null
	if _current_state == STATE_WALK_TO_BREACH_POINT and (not state == STATE_BREACHING):
		_breaching_target.breaching_intruder = null
	
	if state == STATE_IDLE:
		_idle_target = Vector2.ZERO
	elif state == STATE_BREACHING:
		_breaching_cooldow = breaching_speed / motivation_spee_factor()
	elif state == STATE_FALLING:
		annoy(20)
	
	_current_state = state
	update_animation()

func update_animation() -> void:
	if _current_state == STATE_IDLE:
		if _is_scared:
			anim_player.play("run_scared")
		else:
			anim_player.play("walk", -1, 0.5)
	elif _current_state == STATE_WALK_TO_GOAL:
		if _is_scared:
			anim_player.play("run_scared")
		else:
			anim_player.play("run")
	elif _current_state == STATE_WALK_TO_BREACH_POINT:
		anim_player.play("walk")
	elif _current_state == STATE_BREACHING:
		var i = randi() % 4;
		if i == 0:
			anim_player.play("jump_kick")
		elif i == 1:
			anim_player.play("kick")
		elif i == 2:
			anim_player.play("punch")
		elif i == 3:
			anim_player.play("shoot")
	elif _current_state == STATE_FALLING:
		anim_player.play("fall")
	elif _current_state == STATE_DANCE:
		var i = randi() % 4;
		if i == 0:
			anim_player.play("dance1")
		elif i == 1:
			anim_player.play("dance2")
		elif i == 2:
			anim_player.play("dance3")
		elif i == 3:
			anim_player.play("dance4")
	elif _current_state == STATE_WATCH_SCREEN:
		anim_player.play("idle")

func check_interruptions() -> void:
	if _current_state == STATE_FALLING:
		return
	if _current_state == STATE_WATCH_SCREEN:
		if detector_screen.get_overlapping_areas().empty():
			_is_scared = true
	if not detector_vacuum_robot.get_overlapping_areas().empty():
		change_state(STATE_FALLING)
	elif not detector_dance.get_overlapping_areas().empty() and not _is_scared:
		change_state(STATE_DANCE)
	elif not detector_screen.get_overlapping_areas().empty() and not _is_scared:
		change_state(STATE_WATCH_SCREEN)
	elif not detector_breach_point.get_overlapping_areas().empty() and not _is_scared and _motivation > 0.0:
		if _current_state != STATE_BREACHING and _current_state != STATE_WALK_TO_BREACH_POINT:
			for area in detector_breach_point.get_overlapping_areas():
				if area.breaching_intruder == null and area.is_active():
					var path : = nav_2d.get_simple_path(global_position, area.global_position)
					if (not path.empty()) and get_path_length(path) < 2* 60:
						_breaching_target = area
						_breaching_target.breaching_intruder = self
						change_state(STATE_WALK_TO_BREACH_POINT)
						break

# returns if it finished path
func start_move_along_path(distance: float) -> bool:
	nav_2d.add_heat(global_position, get_physics_process_delta_time())
	_path.remove(0)
	if not _path.empty():
		if _path[0].x < global_position.x:
			flip_h = true
		elif _path[0].x > global_position.x:
			flip_h = false
		
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
	for i in range(points.size()):
		if points[i].x < minX:
			minX = points[i].x
		if points[i].y < minY:
			minY = points[i].y
		if points[i].x > maxX:
			maxX = points[i].x
		if points[i].y > maxY:
			maxY = points[i].y
	return Vector2(rand_range(minX, maxX), rand_range(minY, maxY))

func motivation_spee_factor() -> float:
	return 0.5 + _motivation / max_motivation / 2

func annoy(amount : float) -> void:
	_motivation -= amount
