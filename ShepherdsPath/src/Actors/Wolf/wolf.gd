extends Spatial

export var speed: float
export var visionRadius: float

signal i_see_you

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_Area_area_entered(area: Area):
	emit_signal("i_see_you", area)

func _process(delta: float):
	translate(Vector3(0,0.6,5) * delta)