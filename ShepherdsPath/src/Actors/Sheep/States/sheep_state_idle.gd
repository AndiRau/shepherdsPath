extends SheepState

func override_process():

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
	
	sheep._velocity =  Vector3(0,sheep._down_force,0)
	sheep._velocity = sheep.move_and_slide(sheep._velocity)

