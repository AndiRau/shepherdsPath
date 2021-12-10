extends SheepState

func override_process():
	var flag_vector = Vector3.ZERO
	sheep.rc_obstacle.rotation = -sheep.rotation
	if sheep.get_parent().target_pos != Vector3.INF:
		flag_vector = sheep.global_transform.origin.direction_to(sheep.get_parent().target_pos) * sheep._c_speed * target_follow_force
	
	# get cohesion, alginment, and separation vectors
	var vectors = sheep.get_flock_status(sheep._flock)

	var cohesion_vector = vectors[0] * cohesion_force * 0.5
	var align_vector = vectors[1] * algin_force
	var separation_vector = vectors[2] * separate_force

	var acceleration = cohesion_vector + align_vector + separation_vector + flag_vector

	if sheep.rc_sees_obstacle.is_colliding():
		sheep.colission_avoid_force = sheep.steer_towards( sheep.rc_obstacle.get_unoccluded_direction())
	else:
		sheep.colission_avoid_force *= Vector3(0.95,0.95,0.95)
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
