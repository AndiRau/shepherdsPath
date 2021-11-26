extends Node

export(int) var sheep_number = 20
export(PackedScene) var Boid



var _width = 22
var _height = 22


func _ready():
	for _i in range(sheep_number):
		Apphandler.set_target(Vector3(1291.777,-12.657,-820.72)) # testing purposes. coordinates replaceable with something else
		

