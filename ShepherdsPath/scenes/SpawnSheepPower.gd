extends Spatial


export(int) var boids = 20
export(PackedScene) var Boid

export(float) var lawn_width
export(float) var lawn_height


func _ready():
	for _i in range(boids):
		randomize()
		var boid = Boid.instance()
		boid.transform.origin = Vector3(rand_range(0, lawn_width), rand_range(0, lawn_height), rand_range(0,1))
		add_child(boid)
		
