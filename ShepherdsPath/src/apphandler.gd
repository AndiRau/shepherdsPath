extends Node

class_name apphandler
onready var current_terrain: Terrain


var player_position: Vector3 = Vector3()
var dog_position: Vector3 = Vector3()
var sheep_target: Vector3 = Vector3()
var player_unified_position: Vector2 = Vector2()
var day_time = 12 # 0-24
var day_time_unified = 0.5
var do_daylight_cycle: bool = false
export var cycle_speed: float = 0.7

func get_unified_player_position():
	return Vector2(player_position.x, player_position.z) / current_terrain.rect_size
	# returns player position on the current terrain on a scale of 0-1

func set_day_time():
	day_time = fmod(day_time, 24)
	day_time_unified = day_time / 24

func _process(delta):
	if do_daylight_cycle:
		day_time  += delta * cycle_speed 
		set_day_time();
	
func get_terrain():
	# nutzt die noch irgendwer?
	return get_tree().get_root().get_node("testscene/Main/terrain")

func get_debug_sphere() -> MeshInstance:
	return get_tree().get_root().get_node("testscene/DebugSphere") as MeshInstance
