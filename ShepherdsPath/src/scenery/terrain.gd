extends Spatial

class_name terrain

var heightmap = Image.new()

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	heightmap.load("res://3d_models/terrain/heightmap1.exr")
	heightmap.convert(Image.FORMAT_RF)
	# Create the shape (if you don't have one already)
	#var shape = HeightMapShape.new()

	#shape.map_width = heightmap.get_width()
	#shape.map_height = heightmap.get_height()

	# Because the format matches, this is straightforward
	#shape.map_data = heightmap.get_data()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
