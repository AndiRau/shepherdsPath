extends Spatial

class_name Puma

export var speed: float = 14
export var speed_walk: float = 4
export var attack_damage: int = 5
export var home: NodePath
onready var view: Area = $View
onready var rc_terrain: RayCast = $RayCastTerrain
var current_target: Spatial
var sheep_in_view: bool = false
onready var anim_player: AnimationPlayer = $puma_export/AnimationPlayer
var has_eaten: bool = false
var prey_visual: Spatial

signal deal_damage(ammount, sender)


func set_has_eaten(_has_eaten: bool, _prey_visual: Spatial):
	if has_eaten:
		anim_player.play("walk_export")
		prey_visual = _prey_visual.duplicate()
		prey_visual.translation.y = 1
		prey_visual.rotation_degrees = Vector3(0, -90, -180)
		$MouthPos.add_child(prey_visual)
	has_eaten = _has_eaten


func get_has_eaten():
	return has_eaten

	
func _ready():
	anim_player.get_animation("run_export").loop = true
	anim_player.get_animation("walk_export").loop = true


func on_pick_victim():
	randomize()
	var sheeps_in_view: Array = view.get_overlapping_bodies()

	sheep_in_view = sheeps_in_view.size() > 0

	if (sheep_in_view == false and rand_range(0.0,1.0) < 0.5) or !sheep_in_view or has_eaten:
		
		if is_instance_valid(current_target) and is_connected("deal_damage", current_target, "on_take_damage"):
			disconnect("deal_damage", current_target, "on_take_damage")
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
	current_target = sheeps_in_view[min_sheep_dist_index]
	if not is_connected("deal_damage", current_target, "on_take_damage"):
		connect("deal_damage", current_target, "on_take_damage")

	anim_player.play("run_export")


func dist_to_target() -> float:
	return current_target.global_transform.origin.distance_squared_to(global_transform.origin)


func _process(delta):
	if rc_terrain.is_colliding():
		global_transform.origin.y = rc_terrain.get_collision_point().y
	if has_eaten:
		look_at(get_node(home).global_transform.origin, Vector3(0,1, 0))
		translate(Vector3.FORWARD * delta * speed_walk)
		return
	if sheep_in_view and is_instance_valid(current_target): # means: in view and not dead
		if dist_to_target() > 2:
			look_at(current_target.global_transform.origin, Vector3(0,1, 0))
			translate(Vector3.FORWARD * delta * speed)


func _on_view_area_entered():
	pass # Replace with function body.


func on_try_attack():
	if sheep_in_view and is_instance_valid(current_target) and not has_eaten:
		if dist_to_target() < 2.3:
			emit_signal("deal_damage", attack_damage, self)
