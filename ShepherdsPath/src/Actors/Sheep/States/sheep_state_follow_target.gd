extends SheepState

func override_process():
	var flag_vector = Vector3.ZERO
	if owner.get_parent().target_pos != Vector3.INF:
		flag_vector = owner.global_transform.origin.direction_to(owner.get_parent().target_pos) * owner._c_speed * target_follow_force
	
	# get cohesion, alginment, and separation vectors
	var vectors = owner.get_flock_status(owner._flock)

	var cohesion_vector = vectors[0] * cohesion_force * 0.5
	var align_vector = vectors[1] * algin_force
	var separation_vector = vectors[2] * separate_force

	var acceleration = cohesion_vector + align_vector + separation_vector + flag_vector

	if owner.rc_sees_obstacle.is_colliding():
		owner.colission_avoid_force = owner.steer_towards( owner.rc_obstacle.get_unoccluded_direction())
	else:
		owner.colission_avoid_force *= Vector3(0.95,0.95,0.95)
	acceleration += owner.colission_avoid_force

	owner._velocity = (owner._velocity * Vector3(1,0,1) + acceleration).normalized() * owner._c_speed
	
	if owner.rc_terrain.is_colliding():
		owner.global_transform.origin.y = owner.rc_terrain.get_collision_point().y

	if owner.is_jumping:
		if owner.rc_terrain.is_colliding():
			owner._down_force += 25
		else:
			owner._down_force -= jump_shortage
			owner._down_force = clamp(owner._down_force, -down_force_max*2, down_force_max)
	else:
		owner._down_force = -5
	
	if owner._down_force < 0:
		owner._down_force *= 1.2 #fall faster down than up

	owner._velocity.y = owner._down_force
	

	
	owner.look_at(owner.global_transform.origin + owner._velocity * Vector3(1,0,1), Vector3(0, 1, 0)) #possibly wrong order to move_and_slide
	owner._velocity = owner.move_and_slide(owner._velocity)
