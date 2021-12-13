extends MeshInstance

onready var mat: ShaderMaterial = get_active_material(0)

export var change_duration: float = 5
export var cloud_color: Color
export var raincloud_color: Color
export var thundercloud_color: Color

var _time: float

var _ammount_to_set: float
var _ammount_old: float
var _ammount: float

var colort_to_set: Color
var _color_old: Color
var _color: Color


func _process(delta):
	mat.set_shader_param("daytime", Apphandler.day_time_unified)
	if _time < change_duration:
		_time += delta
		_ammount = lerp(_ammount_old, _ammount_to_set, _time / change_duration)
		mat.set_shader_param("ammount", _ammount)

		_color = lerp(_color_old, colort_to_set, _time / change_duration)
		mat.set_shader_param("color", _color)


func set_weather(weathercheck: String):
	_time = 0
	_ammount_old = _ammount
	_color_old = _color
	if weathercheck == "SUNNY":
		_ammount_to_set = rand_range(0, 0.3)
		colort_to_set = cloud_color
	if weathercheck == "CLOUDY":
		_ammount_to_set = rand_range(0.5, 1.5)
		colort_to_set = cloud_color
	if weathercheck == "RAIN":
		_ammount_to_set = rand_range(2.5, 4)
		colort_to_set = raincloud_color
	if weathercheck == "THUNDER":
		colort_to_set = thundercloud_color
		_ammount_to_set = 10