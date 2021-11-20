extends Node

export(int) var boids = 20
export(PackedScene) var Boid

var _width = 22
var _height = 22


func _ready():
	for _i in range(boids):
		randomize()
		var boid: Spatial = Boid.instance()
		boid.translation = Vector3(rand_range(0, _width), 1, rand_range(0, _height))
		add_child(boid)
		get_node("/root/Apphandler").set_target(Vector3(5,1,1))
		
