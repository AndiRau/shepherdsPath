extends Spatial


export(int) var boids = 20
export(PackedScene) var Boid

var _width = ProjectSettings.get_setting("display/window/size/width")
var _height = ProjectSettings.get_setting("display/window/size/height")


func _ready():
	for _i in range(boids):
		randomize()
		var boid = Boid.instance()
		boid.transform.origin = Vector3(rand_range(0, _width), rand_range(0, _height), rand_range(0,1))
		add_child(boid)
		
