extends Node

class_name apphandler
onready var current_terrain: Terrain


var player_position: Vector3 = Vector3()
var player_unified_position: Vector2 = Vector2()
	

func get_unified_player_position():
	return Vector2(player_position.x, player_position.z) / current_terrain.rect_size
	# returns player position on the current terrain on a scale of 0-1


func get_terrain():
	# nutzt die noch irgendwer?
	return get_tree().get_root().get_node("testscene/Main/terrain")

func get_debug_sphere() -> MeshInstance:
	return get_tree().get_root().get_node("testscene/DebugSphere") as MeshInstance
