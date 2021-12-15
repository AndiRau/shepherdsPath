tool
extends Spatial

export var Update: bool setget update_color

enum COLOR {CYAN, YELLOW, BROWN, MAGENTA, LILA, PINK, GREEN, DARK_GREEN, BLUE, ORANGE, RED, BLACK}
export var color1_slot: int
export(COLOR) var color1 = COLOR.RED
export var color2_slot: int
export(COLOR) var color2 = COLOR.BLUE

onready var mesh: MeshInstance = get_child(0)

var colordict: Dictionary = {
	COLOR.CYAN: Color("20A796"),
	COLOR.YELLOW: Color("A79E20"),
	COLOR.BROWN: Color("815F39"),
	COLOR.MAGENTA: Color("980B92"),
	COLOR.LILA: Color("682C83"),
	COLOR.PINK: Color("C05B92"),
	COLOR.GREEN: Color("35C03B"),
	COLOR.DARK_GREEN: Color("106244"),
	COLOR.BLUE: Color("1C08AB"),
	COLOR.ORANGE: Color("C66F17"),
	COLOR.RED: Color("9F1115"),
	COLOR.BLACK: Color(0,0,0),
}

# Called when the node enters the scene tree for the first time.
func _ready():
	update_color(true)

func update_color(_v):
	var m1: SpatialMaterial = SpatialMaterial.new()
	var m2: SpatialMaterial = SpatialMaterial.new()
	m1.albedo_color = colordict[color1]
	m2.albedo_color = colordict[color2]
	mesh.set_surface_material(color1_slot, m1)
	mesh.set_surface_material(color2_slot, m2)
	