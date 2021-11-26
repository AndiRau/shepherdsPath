extends KinematicBody

class_name Sheep

export var max_speed: float = 200.0
export var mouse_follow_force: float = 0.05
export var cohesion_force: float = 0.05
export var algin_force: float = 0.05
export var separate_force: float = 0.05
export var view_distance: = 50.0
export var avoid_distance: = 20.0
export var jump_shortage: float = 0.5
export var enemy_forget_time: float = 5
onready var rc: RayCast = $RayCast
var is_jumping: bool = false
var saw_enemy: bool = false
var current_enemy: Vector3 #maybe add enemy type later
onready var flock_view: Area = $FlockView

var _width = 3000
var _height = 3000

var _flock: Array = []
var flag_target: Vector3
var _velocity: Vector3

func randomize_behaviour():
	randomize()
	max_speed = rand_range(2, 8)
	randomize()
	avoid_distance = rand_range(2, 20)
	randomize()
	cohesion_force = rand_range(0.02, 0.2)
	randomize()
	mouse_follow_force = rand_range(0.02, 0.1)
	randomize()
	algin_force = rand_range(0.02, 0.2)
	randomize()
	jump_shortage = pow(rand_range(0, 1), 2) * 3 + 0.15
	randomize()
	enemy_forget_time =rand_range(3, 15)

func _ready():
	randomize()
	_velocity = Vector3(rand_range(-1, 1), 1, rand_range(-1, 1)).normalized() * max_speed
	flag_target = Apphandler.target
	$TimerForgetEnemy.wait_time = enemy_forget_time


func _on_FlockView_body_entered(body: PhysicsBody):
	if self != body:
		_flock.append(body)


func _on_FlockView_body_exited(body: PhysicsBody):
	var index =_flock.find(body)
	if index >= 0:
		_flock.remove(index)


func _input(event):
	if event is InputEventMouseButton:
		if event.get_button_index() == BUTTON_LEFT:
			#flag_target = event.translation
			pass
		elif event.get_button_index() == BUTTON_RIGHT:
			flag_target = get_random_target()

func flee(acceleration: Vector3) -> Vector3:
	var enemy_vector = global_transform.origin - current_enemy
	return acceleration + enemy_vector * 3

var down_force = 0
func _physics_process(_delta):
	flag_target = get_node("/root/Apphandler").target
	var flag_vector = Vector3.ZERO
	if flag_target != Vector3.INF:
		flag_vector = global_transform.origin.direction_to(flag_target) * max_speed * mouse_follow_force
	
	# get cohesion, alginment, and separation vectors
	var vectors = get_flock_status(_flock)
	
	# steer towards vectors
	var cohesion_vector = vectors[0] * cohesion_force * 5
	var align_vector = vectors[1] * algin_force
	var separation_vector = vectors[2] * separate_force

	var acceleration = cohesion_vector + align_vector + separation_vector + flag_vector

	#var food_vector = global_transform.origin - current_food
	#acceleration -= food_vector * 5

	if saw_enemy:
		acceleration = flee(acceleration)

	
	_velocity = (_velocity * Vector3(1,0,1) + acceleration).normalized() * max_speed
	
	if rc.is_colliding():
		global_transform.origin = rc.get_collision_point()

	if is_jumping:
		if rc.is_colliding():
			down_force += 25
		else:
			down_force -= jump_shortage
		var down_force_max = 8
		down_force = clamp(down_force, -down_force_max*2, down_force_max)
	else:
		down_force = -5
	
	if down_force < 0:
		down_force *= 1.2 #fall faster don than up

	_velocity.y = down_force
	_velocity = move_and_slide(_velocity)
			
	look_at(global_transform.origin + _velocity * Vector3(1,0,1), Vector3(0, 1, 0))


func get_flock_status(flock: Array) -> Array:
	var center_vector: = Vector3()
	var flock_center: = Vector3()
	var align_vector: = Vector3()
	var avoid_vector: = Vector3()
	
	for f in flock:
		var neighbor_pos: Vector3 = f.global_transform.origin
		#align_vector += f._velocity			functioniert aus irgendwelchen gründen nicht
		align_vector += Vector3(1,1,1)
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
	return Vector3(rand_range(0, _width), 1, rand_range(0, _height))


func on_random_time():
	is_jumping = !is_jumping
	jump_shortage = pow(rand_range(0, 1), 2) * 1.1 + 0.15

func start_jumping(_jump_shortage):
	is_jumping = true
	jump_shortage = _jump_shortage


func _on_FlockView_area_entered(area: Area):
	if area.name == "WolfArea":
		current_enemy = area.global_transform.origin
		saw_enemy = true
		max_speed = rand_range(9, 16)
		algin_force = 700
		separate_force = 0.002
		$TimerForgetEnemy.start()


func _on_forget_enemy():
	print("I try to forget the big bad Wolf!")
	for body in flock_view.get_overlapping_bodies():
		if body.get_collision_layer() == 17: # ugly magic number for enemy colission layer. Fix.
			$TimerForgetEnemy.start()
			return

	saw_enemy = false
	algin_force = rand_range(0.02, 0.2)
	max_speed = rand_range(2, 8)
	separate_force = 0.05
	print("I finally forgot the big bad Wolf!")
