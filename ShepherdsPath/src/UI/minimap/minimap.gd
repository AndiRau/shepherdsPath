extends Node

var mat: ShaderMaterial

func _ready():
	mat = $map.get_active_material(0)

func _process(_delta):
	mat.set_shader_param("player_position", Apphandler.get_unified_player_position())
