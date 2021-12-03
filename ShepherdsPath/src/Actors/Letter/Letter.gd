extends Spatial

var contents

signal collectLetter(contents)
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	contents = "SCHMERZ"


#the pain!
func _on_Area_body_entered(_body:Node):
	emit_signal("collectLetter", contents)


