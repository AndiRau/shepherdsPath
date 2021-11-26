extends KinematicBody

class_name Sheep

export var speed: float = 200.0
export var target_follow_force: float = 0.05
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
var enemies_in_memory: PoolVector3Array
onready var flock_view: Area = $FlockView

var _width = 3000
var _height = 3000

var _flock: Array = []
var _velocity: Vector3

func randomize_behaviour():
	randomize()
	speed = rand_range(2, 8)
	avoid_distance = rand_range(2, 20)
	cohesion_force = rand_range(0.02, 0.2)
	target_follow_force = rand_range(0.02, 0.6)
	algin_force = rand_range(0.02, 0.2)
	jump_shortage = pow(rand_range(0, 1), 2) * 3 + 0.15
	enemy_forget_time = rand_range(3, 15)

func _ready():
	randomize()
	_velocity = Vector3(rand_range(-1, 1), 1, rand_range(-1, 1)).normalized() * speed
	$TimerForgetEnemy.wait_time = enemy_forget_time


func _on_FlockView_body_entered(body: PhysicsBody):
	if self != body:
		_flock.append(body)


func _on_FlockView_body_exited(body: PhysicsBody):
	var index =_flock.find(body)
	if index >= 0:
		_flock.remove(index)

func flee(acceleration: Vector3) -> Vector3:
	var enemy_vector = global_transform.origin - current_enemy
	return acceleration + enemy_vector * 100

var down_force = 0

func _process(delta):
	pass

func _physics_process(_delta):
	var flag_vector = Vector3.ZERO
	if get_parent().target_pos != Vector3.INF:
		flag_vector = global_transform.origin.direction_to(get_parent().target_pos) * speed * target_follow_force
	
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

	
	_velocity = (_velocity * Vector3(1,0,1) + acceleration).normalized() * speed
	
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
		down_force *= 1.2 #fall faster down than up

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
			avoid_vector -= (neighbor_pos - global_transform.origin).normalized() * (avoid_distance / d * speed)
	
	var flock_size = flock.size()
	if flock_size:
		align_vector /= flock_size
		flock_center /= flock_size

		var center_dir = global_transform.origin.direction_to(flock_center)
		var center_speed = speed * (global_transform.origin.distance_to(flock_center) / $FlockView/ViewRadius.shape.radius)
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
		$PanicVisualizer.show()
		current_enemy = area.global_transform.origin
		saw_enemy = true
		speed = rand_range(3, 4)
		algin_force = 700
		separate_force = 0.002
		$TimerForgetEnemy.start()


func _on_forget_enemy():
	for body in flock_view.get_overlapping_bodies():
		if body.is_in_group("sheep_offenders"): # ugly magic number for enemy colission layer. Fix.
			$TimerForgetEnemy.start()
			return
	$PanicVisualizer.hide()
	saw_enemy = false
	algin_force = rand_range(0.02, 0.2)
	speed = rand_range(2, 8)
	separate_force = 0.05
