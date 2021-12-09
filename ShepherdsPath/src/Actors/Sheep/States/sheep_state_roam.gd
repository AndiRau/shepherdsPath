extends SheepState


func _init():
	speed = 5.0
	target_follow_force = 0.05
	cohesion_force = 0.05
	algin_force = 0.05
	separate_force = 0.05
	view_distance = 50.0
	avoid_distance = 20.0
	jump_shortage = 0.5
	down_force_max = 8
