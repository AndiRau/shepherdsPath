extends AudioStreamPlayer3D

onready var timer = get_node("Timer")
var has_played: bool = true

export(Array, AudioStream) var audiofiles

var rng: RandomNumberGenerator = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	rng.randomize()
	stream = audiofiles[rng.randi_range(0, audiofiles.size()-1)]
	var t = rand_range(4, 7)
	timer.set_wait_time(t)
	timer.start()

	pass # Replace with function body.


func _process(delta):
	if !has_played:
		has_played = true
		play()

func _on_Timer_timeout():
	print("MÄH")
	has_played = false
	randomize()
	rng.randomize()
	stream = audiofiles[rng.randi_range(0, audiofiles.size()-1)]
	var t = rand_range(3, 12)
	timer.set_wait_time(t)
	timer.start()

