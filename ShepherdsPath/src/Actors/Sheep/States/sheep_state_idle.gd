extends SheepState

func override_process():

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
	
	owner._velocity =  Vector3(0,owner._down_force,0)
	owner._velocity = owner.move_and_slide(owner._velocity)

