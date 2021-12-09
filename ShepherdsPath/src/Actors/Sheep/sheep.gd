extends KinematicBody

enum e_state {
	idle,
	fleeing,
	eating,
	following
}

class_name Sheep


onready var rc_terrain: RayCast = $TerrainRay
onready var rc_obstacle: Spatial = $ObstacleRayCaster
onready var rc_sees_obstacle: RayCast = $SeesObstacleRay

var state: SheepState = null setget set_state
var previous_state: SheepState = null

var _c_speed: float
var is_jumping: bool = false
var _down_force: float


var _flock: Array = []
var _velocity: Vector3


func _update(_delta: float):
	pass

func _get_transition(delta):
	return null


func _enter_state(new_state, old_state) -> void:
	pass


func _exit_state(old_state, new_state) -> void:
	pass

func set_state(new_state) -> void:
	previous_state = state
	state = new_state

	if previous_state != null:
		_exit_state(previous_state, new_state)
	if new_state != null:
		_enter_state(new_state, previous_state)

func _ready():
	state = $States/Idle
	_c_speed = state.speed
	randomize()
	_velocity = Vector3(rand_range(-1, 1), 1, rand_range(-1, 1)).normalized() * state.speed
	#enemy_timer.wait_time = enemy_forget_time

var colission_avoid_force: Vector3
func _physics_process(_delta):
	
	if state.has_override_process:
		state.override_process()
		return

	rc_obstacle.rotation = -rotation
	var flag_vector = Vector3.ZERO
	if get_parent().target_pos != Vector3.INF:
		flag_vector = global_transform.origin.direction_to(get_parent().target_pos) * _c_speed * state.target_follow_force
	
	# get cohesion, alginment, and separation vectors
	var vectors = get_flock_status(_flock)
	
	# steer towards vectors
	var cohesion_vector = vectors[0] * state.cohesion_force * 0.5
	var align_vector = vectors[1] * state.algin_force
	var separation_vector = vectors[2] * state.separate_force

	var acceleration = cohesion_vector + align_vector + separation_vector + flag_vector

	if rc_sees_obstacle.is_colliding():
		colission_avoid_force = steer_towards( rc_obstacle.get_unoccluded_direction())
	else:
		colission_avoid_force *= Vector3(0.95,0.95,0.95)
	acceleration += colission_avoid_force

	_velocity = (_velocity * Vector3(1,0,1) + acceleration).normalized() * _c_speed
	
	if rc_terrain.is_colliding():
		global_transform.origin = rc_terrain.get_collision_point()

	if is_jumping:
		if rc_terrain.is_colliding():
			_down_force += 25
		else:
			_down_force -= state.jump_shortage
			_down_force = clamp(_down_force, -state.down_force_max*2, state.down_force_max)
	else:
		_down_force = -5
	
	if _down_force < 0:
		_down_force *= 1.2 #fall faster down than up

	_velocity.y = _down_force
	

	
	look_at(global_transform.origin + _velocity * Vector3(1,0,1), Vector3(0, 1, 0)) #possibly wrong order to move_and_slide
	_velocity = move_and_slide(_velocity)


func _on_FlockView_body_entered(body: PhysicsBody):
	if self != body:
		_flock.append(body)
	#if body.is_in_group("sheep_offenders"):
	#	enemies_in_memory.append(body.global_transform.origin)
	#	$PanicVisualizer.show()
	#	saw_enemy = true
	#	c_speed = speed * flee_speed_multiplier
	#	algin_force = 1
	#	separate_force = 0.002
	#	enemy_timer.start()
	#	target_follow_force = 0


func _on_FlockView_body_exited(body: PhysicsBody):
	var index =_flock.find(body)
	if index >= 0:
		_flock.remove(index)
	

func get_flock_status(flock: Array) -> Array:
	var center_vector: = Vector3()
	var flock_center: = Vector3()
	var align_vector: = Vector3()
	var avoid_vector: = Vector3()
	
	for f in flock:
		var neighbor_pos: Vector3 = f.global_transform.origin
		#align_vector += f._velocity			functioniert aus irgendwelchen gründen nicht
		align_vector += Vector3(1,1,1)
		flock_center += neighbor_pos

		var d = global_transform.origin.distance_to(neighbor_pos)
		if d > 0 and d < state.avoid_distance:
			avoid_vector -= (neighbor_pos - global_transform.origin).normalized() * (state.avoid_distance / d * state.speed)
	
	var flock_size = flock.size()
	if flock_size:
		align_vector /= flock_size
		flock_center /= flock_size

		var center_dir = global_transform.origin.direction_to(flock_center)
		var center_speed = _c_speed * (global_transform.origin.distance_to(flock_center) / $FlockView/ViewRadius.shape.radius)
		center_vector = center_dir * center_speed

	return [center_vector, align_vector, avoid_vector]

func steer_towards(vec: Vector3):
	var dist: float = $ObstacleRayCaster.get_distance()
	var v: Vector3 = vec.normalized() * _c_speed - _velocity
	return (v * 2) / (clamp(dist-0.2, 0.001, dist-0.2) * state.obstacle_avoid_force)

func on_random_time():
	is_jumping = !is_jumping
	#state.jump_shortage = pow(rand_range(0, 1), 2) * 1.1 + 0.15
