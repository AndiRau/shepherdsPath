extends Spatial

export var sheep_number: int = 20
export var isPanicked: bool = false
export var spawn_radius: float = 20
export(PackedScene) var Sheep


func _ready():
	init_flock()

func init_flock():
	for _i in range(sheep_number):
		var c_sheep: Sheep = Sheep.instance()
		#var lPos: Vector3 = global_transform.origin
		c_sheep.randomize_behaviour()
		c_sheep.translation += Vector3(rand_range(spawn_radius, -spawn_radius), 0, rand_range(spawn_radius, -spawn_radius))
		##c_sheep.global_transform.origin = lPos
		add_child(c_sheep)
