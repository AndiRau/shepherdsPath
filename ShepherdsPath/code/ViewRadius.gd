extends CollisionShape


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	shape.radius = get_parent().get_parent().view_distance


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
