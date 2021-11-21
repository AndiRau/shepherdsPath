extends Node

export(int) var boids = 20
export(PackedScene) var Boid

var _width = 22
var _height = 22


func _ready():
	for _i in range(boids):
		randomize()
		var c_sheep: Sheep = Boid.instance()
		c_sheep.avoid_distance = rand_range(2, 20)
		randomize()
		c_sheep.cohesion_force = rand_range(0.02, 0.2)
		randomize()
		c_sheep.algin_force = rand_range(0.02, 0.2)
		#randomize()
		#c_sheep.seperate_force = rand_range(0.02, 0.2)
		randomize()
		c_sheep.translation = Vector3(rand_range(0, _width), 1, rand_range(0, _height))
		add_child(c_sheep)
		get_node("/root/Apphandler").set_target(Vector3(5,1,1))
		
