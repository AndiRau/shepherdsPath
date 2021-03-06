extends DogState

export var keep_sheep_at_distance = 30

# Update target sheep get driven towards
func update_target():
    Apphandler.sheep_target = dog.global_transform.origin + dog.global_transform.origin.direction_to(dog.flock_middle) * keep_sheep_at_distance
    

func override_process(delta: float):
    pass

func enter_state(_previous_state: DogState):
    $TimerGetMiddle.connect("timeout", dog, "get_flock_middle")
    dog.anim_player.play("walk_gamified")