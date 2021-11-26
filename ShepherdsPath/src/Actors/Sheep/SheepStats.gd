extends Resource

class_name SheepStats

export var max_speed: float = 200.0
export var target_follow_force: float = 0.05
export var cohesion_force: float = 0.05
export var algin_force: float = 0.05
export var separate_force: float = 0.05
export var view_distance: = 50.0
export var avoid_distance: = 20.0
export var jump_shortage: float = 0.5
export var enemy_forget_time: float = 5

# un-magic-numberify later
func randomize_behaviour():
	randomize()
	max_speed = rand_range(2, 8)
	avoid_distance = rand_range(2, 20)
	cohesion_force = rand_range(0.02, 0.2)
	target_follow_force = rand_range(0.02, 0.6)
	algin_force = rand_range(0.02, 0.2)
	jump_shortage = pow(rand_range(0, 1), 2) * 3 + 0.15
	enemy_forget_time = rand_range(3, 15)