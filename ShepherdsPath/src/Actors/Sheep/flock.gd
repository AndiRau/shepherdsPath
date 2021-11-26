extends Spatial

class_name Flock

export var sheep_number: int = 20
export var isPanicked: bool = false
export var spawn_radius: float = 20
export(PackedScene) var Sheep

export var target_flag_path: NodePath
onready var target_flag: Spatial = get_node(target_flag_path)
var target_pos: Vector3

func _ready():
	init_flock()
	
func init_flock():
	target_pos = target_flag.global_transform.origin
	for _i in range(sheep_number):
		var c_sheep: Sheep = Sheep.instance()
		#var lPos: Vector3 = global_transform.origin
		c_sheep.randomize_behaviour()
		c_sheep.translation += Vector3(rand_range(spawn_radius, -spawn_radius), 0, rand_range(spawn_radius, -spawn_radius))
		##c_sheep.global_transform.origin = lPos
		add_child(c_sheep)

func OnUpdateTarget(_delta):
	target_pos = target_flag.global_transform.origin
