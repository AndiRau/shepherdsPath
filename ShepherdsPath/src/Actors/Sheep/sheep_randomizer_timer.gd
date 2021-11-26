extends Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	init_random()
	connect("timeout", self, "init_random")


func init_random():
	wait_time = rand_range(2, 10)