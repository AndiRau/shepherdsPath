extends Spatial

class_name Terrain

var heightmap = Image.new()

export(Vector2) var rect_size: Vector2


func _ready():

	if $"/root/Apphandler".current_terrain != null:
		print("Only one instance of type Terrain is allowed per scene")
	$"/root/Apphandler".current_terrain = self
	pass

