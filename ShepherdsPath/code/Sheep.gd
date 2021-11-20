extends KinematicBody

export var max_speed: = 200.0
export var mouse_follow_force: = 0.05
export var cohesion_force: = 0.05
export var algin_force: = 0.05
export var separation_force: = 0.05
export(float) var view_distance: = 50.0
export(float) var avoid_distance: = 20.0

var _width = ProjectSettings.get_setting("display/window/size/width")
var _height = ProjectSettings.get_setting("display/window/size/height")

var _flock: Array = []
var _mouse_target: Vector3
var _velocity: Vector3


func _ready():
	randomize()
	_velocity = Vector3(rand_range(-1, 1), rand_range(-1, 1), rand_range(-1,1)).normalized() * max_speed

func _on_FlockView_body_entered(body: PhysicsBody2D):
	if self != body:
		_flock.append(body)


func _on_FlockView_body_exited(body: PhysicsBody2D):
	_flock.remove(_flock.find(body))


func _input(event):
	if event is InputEventMouseButton:
		if event.get_button_index() == BUTTON_LEFT:
			_mouse_target = event.position
		elif event.get_button_index() == BUTTON_RIGHT:
			_mouse_target = get_random_target()


func _physics_process(_delta):
	var mouse_vector = Vector3.ZERO
	if _mouse_target != Vector3.INF:
		mouse_vector = global_transform.origin.direction_to(_mouse_target) * max_speed * mouse_follow_force
	
	# get cohesion, alginment, and separation vectors
	var vectors = get_flock_status(_flock)
	
	# steer towards vectors
	var cohesion_vector = vectors[0] * cohesion_force
	var align_vector = vectors[1] * algin_force
	var separation_vector = vectors[2] * separation_force

	var acceleration = cohesion_vector + align_vector + separation_vector + mouse_vector
	
	var global_direction = Vector3(0,0,1)
	var local_direction = global_direction.rotated(Vector3(0,1,0), rotation.y)
	_velocity = (local_direction + acceleration)
	
	_velocity = move_and_slide(_velocity)


func get_flock_status(flock: Array):
	var center_vector: = Vector3()
	var flock_center: = Vector3()
	var align_vector: = Vector3()
	var avoid_vector: = Vector3()
	
	for f in flock:
		var neighbor_pos: Vector3 = f.global_position

		align_vector += f._velocity
		flock_center += neighbor_pos

		var d = global_transform.origin.distance_to(neighbor_pos)
		if d > 0 and d < avoid_distance:
			avoid_vector -= (neighbor_pos - global_transform.origin).normalized() * (avoid_distance / d * max_speed)
	
	var flock_size = flock.size()
	if flock_size:
		align_vector /= flock_size
		flock_center /= flock_size

		var center_dir = global_transform.origin.direction_to(flock_center)
		var center_speed = max_speed * (global_transform.origin.distance_to(flock_center) / $FlockView/ViewRadius.shape.radius)
		center_vector = center_dir * center_speed

	return [center_vector, align_vector, avoid_vector]
	

func get_random_target():
	randomize()
	return Vector2(rand_range(0, _width), rand_range(0, _height))


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
