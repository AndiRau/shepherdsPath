extends DogState

func get_sheep_on_wrong_side():
	turn_left_right = false
	var lr: bool = false

	var flock: Array = dog.view.get_overlapping_bodies()
	for sheep in flock:
		if dog.left_from(dog.global_transform.origin, dog.front_point.global_transform.origin, sheep.global_transform.origin):
			if !dog.left_from(dog.global_transform.origin, dog.right_point.global_transform.origin, sheep.global_transform.origin):
				turn_left_right = true
	if !turn_left_right_around_flock:
		turn_left_right = !turn_left_right

func override_process(delta: float):
	dog.translate(Vector3(0, 0, -delta * speed))


	if turn_left_right:
		dog.rotate_y(delta * 1.5)
	else:
		dog.rotate_y(delta * -1.5)


func enter_state(_previous_state: DogState):
	dog.anim_player.play("run_gamified")
