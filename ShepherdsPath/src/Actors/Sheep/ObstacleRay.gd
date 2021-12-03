extends Spatial

export var radius: float = 20
export var resolution: int = 20
var rays: Array

var is_colliding: bool = true

func _ready():
	# create rays circle
	for i in range(resolution):
		var a = (2 * PI / resolution) * i - deg2rad(90)
		var x = radius * cos(a)
		var z = radius * sin(a)
		var c_rc = RayCast.new()
		c_rc.cast_to = Vector3(x, global_transform.origin.y, z)
		c_rc.set_collision_mask_bit(0, false)
		c_rc.set_collision_mask_bit(18, true)
		c_rc.collide_with_areas = true
		c_rc.collide_with_bodies = false
		rays.append(c_rc)
		add_child(c_rc)
		c_rc.enabled = true
		c_rc.debug_shape_thickness = 5
		
	rays[0].debug_shape_custom_color = Color.white

func _process(delta):
	is_colliding = false
	if rays[0].is_colliding():
		is_colliding = true

func get_unoccluded_direction() -> Vector3:
	for i in range(resolution):
		var c_rc: RayCast
		# get angles closer to forward view (i=0) first -> i=1 and i=resolution-1 are the closest ones
		if i%2 == 0:
			c_rc = rays[i]
		else:
			c_rc = rays[resolution - i]
		if !c_rc.is_colliding():
			c_rc.debug_shape_custom_color = Color.green
			return c_rc.cast_to
	return Vector3(0, 0, 1) # surrounded by obstacles