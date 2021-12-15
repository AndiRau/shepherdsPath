extends DirectionalLight

export var daytime_gradient: Gradient
export var daytime_gradient_energy: Curve 
export var world_environment: NodePath
export var fog_color: Color

onready var environment: Environment = get_node(world_environment).environment


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(_delta):
	set_day_time()

func set_day_time():
	var curve_val: float = daytime_gradient_energy.interpolate(Apphandler.day_time_unified)

	light_color = daytime_gradient.interpolate(Apphandler.day_time_unified)
	light_energy = curve_val;
	
	rotation_degrees.x = Apphandler.day_time_unified * 360 - 270 + 20
	rotation_degrees.y = Apphandler.day_time_unified * 360 - 180 + 13
	environment.background_energy = curve_val / 8
	environment.fog_color = fog_color * curve_val / 11
