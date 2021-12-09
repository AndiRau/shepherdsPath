extends Spatial

#class_name Puma

export var speed: float = 14
onready var view: Area = $View
onready var rc: RayCast = $RayCast
var current_target: WeakRef # maybe convert type later
var sheep_in_view: bool = false
onready var anim_player: AnimationPlayer = $puma_export/AnimationPlayer

signal deal_damage(ammount)

func _ready():
	
	anim_player.get_animation("run_export").loop = true
	pass
	

func on_pick_victim():
	randomize()
	var sheeps_in_view: Array = view.get_overlapping_bodies()

	sheep_in_view = sheeps_in_view.size() > 0

	if (sheep_in_view == false and rand_range(0.0,1.0) < 0.5) or !sheep_in_view:
		anim_player.stop()
		disconnect("deal_damage", current_target.get_ref(), "on_take_damage")
		return

	var min_sheep_dist: float = INF
	var min_sheep_dist_index: int
	var i: int = 0
	for c_sheep in sheeps_in_view:
		var c_dist: float = c_sheep.global_transform.origin.distance_squared_to(global_transform.origin)
		if c_dist < min_sheep_dist:
			min_sheep_dist = c_dist
			min_sheep_dist_index = i
			i += 1
	current_target = weakref(sheeps_in_view[min_sheep_dist_index])
	connect("deal_damage", current_target.get_ref(), "on_take_damage")

	anim_player.play("run_export")



func _process(delta):
	if sheep_in_view and current_target.get_ref():
		if current_target.get_ref().global_transform.origin.distance_squared_to(global_transform.origin) > 2:
			look_at(current_target.get_ref().global_transform.origin, Vector3(0,1, 0))
			translate(Vector3.FORWARD * delta * speed)
		else:
			emit_signal("deal_damage", 5)

func _on_view_area_entered():
	pass # Replace with function body.
