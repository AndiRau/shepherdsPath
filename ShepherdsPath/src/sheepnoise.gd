extends AudioStreamPlayer3D

onready var timer = get_node("Timer")
var has_played: bool = false
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	var t = rand_range(4, 7)
	timer.set_wait_time(t)
	timer.start()

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _process(_delta):
	if !has_played:
		has_played = true
		#play()

func _on_Timer_timeout():
	has_played = false
	print("hello")
	randomize()
	var t = rand_range(2, 7)
	timer.set_wait_time(t)
	timer.start()

