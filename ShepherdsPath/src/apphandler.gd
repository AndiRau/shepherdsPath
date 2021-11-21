extends Node

class_name apphandler

export(PackedScene) var flagscene: PackedScene
onready var terrain: Terrain

var target: Vector3 = Vector3(500,1,1)

func set_target(_target: Vector3) -> void:
	target = _target
	var f: Spatial = flagscene.instance()
	get_tree().get_root().get_node("testscene").add_child(f)
	f.translation = target
	print(target)

func get_terrain():
	return get_tree().get_root().get_node("testscene/Main/terrain")
