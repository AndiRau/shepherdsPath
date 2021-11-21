extends Node

export(int) var sheep_number = 20
export(PackedScene) var Boid

var _width = 22
var _height = 22


func _ready():
	for _i in range(sheep_number):
		var c_sheep: Sheep = Boid.instance()
		c_sheep.randomize_behaviour()
		randomize()
		c_sheep.translation = Vector3(rand_range(0, _width), 1, rand_range(0, _height))
		add_child(c_sheep)
		get_node("/root/Apphandler").set_target(Vector3(5,1,1))
		
