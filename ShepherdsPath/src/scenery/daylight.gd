extends DirectionalLight

export var daytime_gradient: Gradient
export var daytime_gradient_energy: Curve 
export var do_daylight_cycle: bool = true
export var cycle_speed: float = 0.1
export var world_environment: NodePath
export var fog_color: Color

onready var environment: Environment = get_node(world_environment).environment

export var day_time = 12 # 0-24
var day_time_unified = 0.5

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_day_time():
	var curve_val: float = daytime_gradient_energy.interpolate(day_time_unified)
	day_time = fmod(day_time, 24)
	day_time_unified = day_time / 24
	light_color = daytime_gradient.interpolate(day_time_unified)
	light_energy = curve_val;
	rotation_degrees.x = day_time_unified * 360 - 270
	rotation_degrees.y = day_time_unified * 360 - 180
	environment.background_energy = curve_val / 8
	environment.fog_color = fog_color * curve_val / 11

func _process(delta):
	if do_daylight_cycle:
		day_time  += delta * cycle_speed 
		set_day_time();
