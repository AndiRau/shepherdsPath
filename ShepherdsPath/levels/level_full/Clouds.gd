extends MeshInstance

onready var mat: ShaderMaterial = get_active_material(0)

func _process(_delta):
	mat.set_shader_param("daytime", Apphandler.day_time_unified)