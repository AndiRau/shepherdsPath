extends KinematicBody

class_name Sheep

export var max_hitpoints: int = 20
onready var hitpoints: int = max_hitpoints

onready var rc_terrain: RayCast = $TerrainRay
onready var rc_obstacle: Spatial = $ObstacleRayCaster
onready var rc_sees_obstacle: RayCast = $SeesObstacleRay
onready var flock_view: Area = $FlockView

var state = null setget set_state
var saw_enemy: bool = false

var _c_speed: float
var is_jumping: bool = false
var _down_force: float


var _flock: Array = []
var _velocity: Vector3 = Vector3()


func set_state(new_state) -> void:
	var previous_state = state
	state = new_state

	if previous_state != null:
		previous_state.exit_state(new_state)
	if new_state != null:
		new_state.enter_state(previous_state)
		_c_speed = state.speed
		$FlockView/ViewRadius.shape.radius = state.view_distance
	if new_state != null and previous_state != null:
		new_state.previous_state = previous_state


func _ready():
	set_state($States/Roam)
	
	_c_speed = state.speed
	randomize()
	_velocity = Vector3(rand_range(-1, 1), 1, rand_range(-1, 1)).normalized() * state.speed


var colission_avoid_force: Vector3
func _physics_process(_delta):
	state.override_process()
	

# kinda dirty, string reliant method...
func _on_FlockView_body_entered(body: PhysicsBody):
	if body.is_in_group("sheep_offenders"):
		set_state($States/Flee)
		return
	if body.is_in_group("dog"):
		if !body.state.name:
			print("Entering Dog has no state")
		if body.state.name == "Drive" or body.state.name == "FollowShepherd":
			set_state($States/Driven)
			return
		if body.state.name == "Around":
			set_state($States/Flee)
			return
	if body.is_in_group("sheep") and self != body and body:
		_flock.append(body)
		return


func _on_FlockView_body_exited(body: PhysicsBody):
	var index =_flock.find(body)
	if index >= 0:
		_flock.remove(index)
	

func get_flock_status(flock: Array) -> Array:
	var center_vector: = Vector3()
	var flock_center: = Vector3()
	var align_vector: = Vector3()
	var avoid_vector: = Vector3()
	
	for f in flock:
		var neighbor_pos: Vector3 = f.global_transform.origin
		
		align_vector += f._velocity
		flock_center += neighbor_pos

		var d = global_transform.origin.distance_to(neighbor_pos)
		if d > 0 and d < state.avoid_distance:
			avoid_vector -= (neighbor_pos - global_transform.origin).normalized() * (state.avoid_distance / d * state.speed)
	
	var flock_size = flock.size()
	if flock_size:
		align_vector /= flock_size
		flock_center /= flock_size

		var center_dir = global_transform.origin.direction_to(flock_center)
		var center_speed = _c_speed * (global_transform.origin.distance_to(flock_center) / $FlockView/ViewRadius.shape.radius)
		center_vector = center_dir * center_speed

	return [center_vector, align_vector, avoid_vector]


func steer_towards(distance: float, vec: Vector3):
	var v: Vector3 = vec.normalized() * _c_speed - _velocity
	return (v * 2) / (clamp(distance-0.2, 0.001, distance-0.2) * state.obstacle_avoid_force)


func on_random_time():
	is_jumping = !is_jumping
	#state.jump_shortage = pow(rand_range(0, 1), 2) * 1.1 + 0.15


func on_take_damage(ammount: int, attacker: Puma): # refactor to Enemy
	hitpoints -= ammount
	if hitpoints <= 0:
		attacker.prey_visual = $sheep.duplicate()
		attacker.set_has_eaten(true, $sheep)
		die()


func die():
	queue_free()
	#_on_FlockView_body_exited(self) --- TODO andere Schafe müssens mitkriegen wenn einer stirbt...
