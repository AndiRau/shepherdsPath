extends Spatial

enum e_state {
	idle,
	fleeing,
	eating,
	following
}


class_name StateMachine


var state = null setget set_state
var previous_state = null


var _flock: Array = []
var _velocity: Vector3

func _update(_delta: float):
	pass

func _get_transition(delta):
	return null

func _enter_state(new_state, old_state) -> void:
	pass

func _exit_state(old_state, new_state) -> void:
	pass

func set_state(new_state) -> void:
	previous_state = state
	state = new_state

	if previous_state != null:
		_exit_state(previous_state, new_state)
	if new_state != null:
		_enter_state(new_state, previous_state)

