extends DogState

func override_process(delta: float):
	dog.translate(Vector3(0, 0, delta * speed))
	if dog.rc_terrain.is_colliding():
		dog.global_transform.origin.y = dog.rc_terrain.get_collision_point().y


	if turn_left_right:
		dog.rotate_y(delta * 1.5)
	else:
		dog.rotate_y(delta * -1.5)
