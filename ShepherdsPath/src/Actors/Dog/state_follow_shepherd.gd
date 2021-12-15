extends DogState

export var keep_dist_to_player_squared: float = 100
export var keep_sheep_at_distance = 30
export var turn_duration: float = .1
var current_speed: float = speed

onready var _follow_pos: Vector3 = Apphandler.player_position

func update_target():
	Apphandler.sheep_target = dog.global_transform.origin + dog.global_transform.origin.direction_to(dog.flock_middle) * keep_sheep_at_distance

func override_process(delta: float):

	dog.get_node("T").look_at(Apphandler.player_position, Vector3.UP)
	var a = Quat(dog.transform.basis)
	var b = Quat(dog.get_node("T").transform.basis)

	var c = a.slerp(b, delta * 3)
	#dog.transform.basis = Basis(c)
	dog.look_at(Apphandler.player_position, Vector3.UP)


	#dog.rotation = _follow_pos
	if dog.global_transform.origin.distance_squared_to(Apphandler.player_position) > keep_dist_to_player_squared:
		dog.translate(Vector3(0, 0, -delta * current_speed))

func update():
	update_target()
	var dist: float = clamp(dog.global_transform.origin.distance_to(Apphandler.player_position) - 4, 1, INF)
	current_speed = clamp(dist * 0.5, 0.1, speed)
	dog.anim_player.playback_speed = current_speed * 1
	current_speed = 30


func enter_state(_previous_state: DogState):
	dog.anim_player.play("walk_gamified")
	$TimerGetMiddle.connect("timeout", dog, "get_flock_middle")
	$TimerGetMiddle.connect("timeout", self, "update")
	dog.anim_player.play("walk_gamified")
	update()
	
func exit_state(_next_state: DogState):
	$TimerGetMiddle.disconnect("timeout", dog, "get_flock_middle")
	$TimerGetMiddle.disconnect("timeout", self, "update")
