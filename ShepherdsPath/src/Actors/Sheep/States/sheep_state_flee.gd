extends SheepState

var flee_from: Vector3
var flee_to: Vector3

var enemy_avoid_force: Vector3

func override_process():
	sheep.rc_obstacle.rotation = -sheep.rotation
	# get cohesion, alginment, and separation vectors
	var vectors = sheep.get_flock_status(sheep._flock)

	var cohesion_vector = vectors[0] * cohesion_force * 0.5
	var align_vector = vectors[1] * algin_force
	var separation_vector = vectors[2] * separate_force

	var acceleration = cohesion_vector + align_vector + separation_vector

	if sheep.rc_sees_obstacle.is_colliding():
		sheep.colission_avoid_force = sheep.steer_towards(sheep.rc_obstacle.get_unoccluded_direction())
	else:
		sheep.colission_avoid_force *= Vector3(0.95,0.95,0.95)

	if flee_to:
		sheep.colission_avoid_force = sheep.steer_towards(flee_to) * 2000
		acceleration += sheep.colission_avoid_force



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
	
	sheep.look_at(sheep.global_transform.origin + sheep._velocity * Vector3(1,0,1), Vector3(0, 1, 0)) #possibly wrong order to move_and_slide
	sheep._velocity = sheep.move_and_slide(sheep._velocity)


func get_near_enemies() -> PoolVector3Array:
	var near_enemies: PoolVector3Array = []

	for body in sheep.flock_view.get_overlapping_bodies():
		if body.is_in_group("sheep_offenders"):
			near_enemies.append(body.global_transform.origin)
			cohesion_force = 0.1
		if body.is_in_group("dog"):
			cohesion_force = 0.8
			sheep._c_speed = 7
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
	sheep.get_node("PanicVisualizer").show()
	$TimerFindEnemies.start()
	$TimerForgetEnemy.start()


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
		
		$TimerFindEnemies.start()
