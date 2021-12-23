extends SheepState

var flee_from: Vector3
var flee_to: Vector3
var flee_vec: Vector3
var flee_from_dist2: float
var enemy_avoid_force: Vector3
var initial_speed: float

func override_process():
	sheep.rc_obstacle.rotation = -sheep.rotation

	var vectors = sheep.get_flock_status(sheep._flock)
	var cohesion_vector = vectors[0] * cohesion_force * 0.5
	var align_vector = vectors[1] * algin_force
	var separation_vector = vectors[2] * separate_force
	sheep._c_speed = initial_speed
	sheep._c_speed = sheep._c_speed / (flee_from_dist2 * 0.004 + 0.1)

	if flee_to:
		flee_vec = sheep.global_transform.origin.direction_to(flee_to) / (flee_from_dist2 * 0.15 + 0.1)
	
	var acceleration = cohesion_vector + align_vector + separation_vector + flee_vec

	if sheep.rc_sees_obstacle.is_colliding():
		sheep.colission_avoid_force = sheep.steer_towards(sheep.rc_obstacle.get_distance(), sheep.rc_obstacle.get_unoccluded_direction())
	else:
		sheep.colission_avoid_force *= Vector3(0.95,0.95,0.95)

	sheep._velocity = (sheep._velocity * Vector3(1,0,1) + acceleration).normalized() * sheep._c_speed
	
	if sheep.rc_terrain.is_colliding():
		sheep.global_transform.origin.y = sheep.rc_terrain.get_collision_point().y

	if sheep.is_jumping:
		if sheep.rc_terrain.is_colliding():
			sheep._down_force += 25
		else:
			sheep._down_force -= jump_shortage
			sheep._down_force = clamp(sheep._down_force, -down_force_max*2, down_force_max)
	else:
		sheep._down_force = -5
	
	if sheep._down_force < 0:
		sheep._down_force *= 1.2 #fall faster down than up

	sheep._velocity.y = sheep._down_force
	
	if sheep._velocity != Vector3(0,0,0):
		sheep.look_at(sheep.global_transform.origin + sheep._velocity * Vector3(1,0,1), Vector3(0, 1, 0)) #possibly wrong order to move_and_slide
		sheep._velocity = sheep.move_and_slide(sheep._velocity)


func get_near_enemies() -> PoolVector3Array:
	var near_enemies: PoolVector3Array = []

	for body in sheep.flock_view.get_overlapping_bodies():
		if body.is_in_group("sheep_offenders"):
			near_enemies.append(body.global_transform.origin)
			cohesion_force = 0.1
		if body.is_in_group("dog"):
			near_enemies.append(body.global_transform.origin)
			cohesion_force = 0.3
	return near_enemies


func _on_update_enemy_memory():
	if get_near_enemies().empty():
		if previous_state != self:
			sheep.set_state(previous_state)
		else:
			sheep.set_state(sheep.get_node("States/Idle"))
	else:
		$TimerFindEnemies.start()


func enter_state(_old_state: SheepState):
	_on_find_enemies()
	_on_update_enemy_memory()
	sheep.get_node("PanicVisualizer").show()
	$TimerFindEnemies.start()
	$TimerForgetEnemy.start()
	initial_speed = sheep._c_speed


func exit_state(_next_state: SheepState):
	$TimerFindEnemies.stop()
	$TimerForgetEnemy.stop()
	sheep.get_node("PanicVisualizer").hide()

func _on_find_enemies():
	var enemy_pos: Vector3 = Vector3.ZERO
	var enemies: PoolVector3Array = get_near_enemies()
	if enemies.size() != 0:
		for e in enemies:
			enemy_pos += e
		flee_from = enemy_pos / enemies.size()
		var a: Vector3 = flee_from - sheep.global_transform.origin
		a = -a
		flee_to = a + sheep.global_transform.origin
		flee_from_dist2 = sheep.global_transform.origin.distance_squared_to(flee_from)
		
		$TimerFindEnemies.start()
