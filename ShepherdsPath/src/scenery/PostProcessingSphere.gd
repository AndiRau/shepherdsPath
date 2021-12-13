extends MeshInstance


var raining: bool = false
var _rain_strength: float = 0.85
export var max_rain_strength = 0.6 # the lower, the heavier the rain
export var rain_start_speed: float = 0.1
onready var mat: ShaderMaterial = get_active_material(0)


func _process(delta):
	global_transform.origin = Apphandler.player_position

	if raining == true:
		_rain_strength -= delta * rain_start_speed
	else:
		_rain_strength += delta * rain_start_speed

	_rain_strength = clamp(_rain_strength, max_rain_strength, 0.85)
	if _rain_strength != max_rain_strength && _rain_strength != 0.85:
		mat.set_shader_param("strength", _rain_strength)



func _on_hut_norainTrigger_area_entered(_area:Area):
	self.visible = false



func _on_hut_norainTrigger_area_exited(_area:Area):
	self.visible = true



func _on_barn_norainTrigger_area_entered(_area:Area):
	self.visible = false



func _on_barn_norainTrigger_area_exited(_area:Area):
	self.visible = true

