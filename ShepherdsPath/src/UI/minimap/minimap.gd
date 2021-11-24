extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var mat: ShaderMaterial

# Called when the node enters the scene tree for the first time.
func _ready():
	mat = $map.get_active_material(0)
	pass # Replace with function body.

func _process(_delta):
	mat.set_shader_param("player_position", Apphandler.get_unified_player_position())
	pass
