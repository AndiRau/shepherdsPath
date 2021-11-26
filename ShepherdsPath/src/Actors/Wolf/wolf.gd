extends Spatial

class_name Wolf

export var speed: float = 8
export var visionRadius: float
onready var view: Area = $WolfView
var current_target: Vector3 # maybe convert type later

signal i_see_you


func _ready():
	pass



func _process(delta):
	var sheeps_in_view: Array = view.get_overlapping_bodies()
	if sheeps_in_view.size() > 0:
		var sheep_pos: Vector3 = sheeps_in_view[0].global_transform.origin # very basic - improve later
		look_at(sheep_pos, Vector3(0,1, 0))
		if sheep_pos.distance_squared_to(global_transform.origin) > 2:
			translate(Vector3.FORWARD * delta * speed)

func _on_WolfView_area_entered(area: Area):
	pass#current_target = area.get_parent().
