extends Node

class_name SheepState

export var speed: float = 5.0
export var target_follow_force: float = 0.05
export var cohesion_force: float = 0.05
export var algin_force: float = 0.05
export var separate_force: float = 0.05
export var view_distance: = 50.0
export var avoid_distance: = 20.0
export var jump_shortage: float = 0.5
export var down_force_max = 8
export var obstacle_avoid_force = 3 # higher -> Sheep approach obstacles cloaser

onready var sheep = owner # type declaration "Sheep" leads to cyclic reference error sadly...

var previous_state: SheepState = null
var _velocity: Vector3

var has_override_process: bool = false
func override_process():
	pass
