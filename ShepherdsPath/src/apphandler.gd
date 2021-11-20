extends Node

class_name apphandler

export(PackedScene) var flagscene: PackedScene



var target: Vector3 = Vector3(5,1,1)

func set_target(_target: Vector3) -> void:
	target = _target
	var f: Spatial = flagscene.instance()
	get_tree().get_root().get_node("testscene").add_child(f)
	f.translation = target
