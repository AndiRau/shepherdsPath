tool
extends Spatial

export var Update: bool setget update_color

enum COLOR {CYAN, YELLOW, BROWN, MAGENTA, LILA, PINK, GREEN, DARK_GREEN, BLUE, ORANGE, RED}
export var color1_slot: int
export(COLOR) var color1 = COLOR.RED
export var color2_slot: int
export(COLOR) var color2 = COLOR.BLUE

onready var mesh: MeshInstance = get_child(0)

var colordict: Dictionary = {
	COLOR.CYAN: Color(1,1,1),
	COLOR.YELLOW: Color(1,1,1),
	COLOR.BROWN: Color(1,1,1),
	COLOR.MAGENTA: Color(1,1,1),
	COLOR.LILA: Color(1,1,1),
	COLOR.PINK: Color(1,1,1),
	COLOR.GREEN: Color(1,1,1),
	COLOR.DARK_GREEN: Color(1,1,1),
	COLOR.BLUE: Color(1,1,1),
	COLOR.ORANGE: Color(1,1,1),
	COLOR.RED: Color(1,1,1),
}

# Called when the node enters the scene tree for the first time.
func _ready():
	update_color(true)

func update_color(_v):
	mesh.get_active_material(color1_slot).albedo_color = colordict[color1]
	mesh.get_active_material(color2_slot).albedo_color = colordict[color2]
	