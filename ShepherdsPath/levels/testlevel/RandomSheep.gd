extends Node

export(int) var sheep_number = 20
export(PackedScene) var Boid

onready var sheepspawnPos: Vector3 = get_node("sheepSpawn").global_transform.origin




var _width = 22
var _height = 22


func _ready():
	for _i in range(sheep_number):
		var c_sheep: Sheep = Boid.instance()
		c_sheep.randomize_behaviour()
		randomize()
		c_sheep.translation = Vector3(rand_range(sheepspawnPos.x, sheepspawnPos.x + _width), -30, rand_range(sheepspawnPos.z, sheepspawnPos.z + _height)) # added a sheepspawn node so i can say, where they spawn
		add_child(c_sheep)
		get_node("/root/Apphandler").set_target(Vector3(1291.777,-12.657,-820.72)) # testing purposes. coordinates replaceable with something else
		

