extends DogState

func override_process(delta: float):
	dog.translate(Vector3(0, 0, -delta * speed))


	if turn_left_right:
		dog.rotate_y(delta * 1.5)
	else:
		dog.rotate_y(delta * -1.5)


func enter_state(_previous_state: DogState):
	dog.anim_player.play("run_gamified")
