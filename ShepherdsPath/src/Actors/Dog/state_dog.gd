extends Node

class_name DogState


var previous_state: DogState = null
onready var dog: Dog = owner
export var speed: float = 5
export var turn_left_right_around_flock: bool=true
var turn_left_right = false


func override_process(delta: float):
	pass

func enter_state(previous_state: DogState):
	pass

func exit_state(next_state: DogState):
	pass