extends Node

class_name DogState


var previous_state: DogState = null
onready var dog: Dog = owner
export var speed: float = 5
export var turn_left_right_around_flock: bool=true
var turn_left_right = false

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
	pass

func enter_state(previous_state: DogState):
	pass

func exit_state(next_state: DogState):
	pass