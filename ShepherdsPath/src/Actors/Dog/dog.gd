extends KinematicBody

class_name Dog

export var speed: float = 16
export var start_state: NodePath

onready var anim_player: AnimationPlayer = $AnimationPlayer
onready var view: Area = $View
onready var front_point: Spatial = $FrontPoint
onready var left_point: Spatial = $LeftPoint
onready var right_point: Spatial = $RightPoint
onready var debug_cube: Spatial = $DebugCube
onready var rc_terrain: RayCast = $TerrainRay



var flock_middle: Vector3
var flock_furthest_sheep: Vector3

func _ready():
	anim_player.get_animation("run_gamified").loop = true
	anim_player.get_animation("walk_gamified").loop = true
	set_state(get_node(start_state))

var previous_state
var state = null setget set_state

func set_state(new_state) -> void:
	anim_player.playback_speed = 1.0
	previous_state = state
	state = new_state

	if previous_state != null:
		previous_state.exit_state(new_state)
	if new_state != null:
		new_state.enter_state(previous_state)
		speed = state.speed
	if new_state != null and previous_state != null:
		new_state.previous_state = previous_state



var r_normal: Vector3 = Vector3()
func _process(delta):
	Apphandler.dog_position = global_transform.origin
	state.override_process(delta)
	if rc_terrain.is_colliding():
		r_normal = rc_terrain.get_collision_normal()
		global_transform.origin.y = rc_terrain.get_collision_point().y
		rotation.x = r_normal.x
		rotation.z = r_normal.z

func get_flock_shape():
	var flock: Array
	flock = view.get_overlapping_bodies()

	flock_middle = Vector3.ZERO
	for sheep in flock:
		flock_middle += sheep.global_transform.origin
	flock_middle /= flock.size()

	var furthest_dist: float = 0
	for sheep in flock:
		var c_dist: float = sheep.global_transform.origin.distance_to(flock_middle)
		if c_dist > furthest_dist:
			furthest_dist = c_dist
			flock_furthest_sheep = sheep.global_transform.origin

func get_flock_middle():
	var flock: Array
	flock = view.get_overlapping_bodies()
	if flock.size() == 0:
		return

	flock_middle = Vector3.ZERO
	for sheep in flock:
		flock_middle += sheep.global_transform.origin
	flock_middle /= flock.size()


func left_from(a: Vector3, b: Vector3, c: Vector3):
	return ((b.x - a.x)*(c.z - a.z) - (b.z - a.z)*(c.x - a.x)) > 0;
