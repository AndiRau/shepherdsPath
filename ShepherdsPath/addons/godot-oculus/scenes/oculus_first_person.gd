extends ARVROrigin

var oculus_config = null;
var refresh_rate = 0;
var player_pos

onready var noteBookObj = get_node("Right_Hand/notebook")

var noteBookActive : bool = false

func get_config():
	return oculus_config

func _ready():
	# get our config object
	var config = preload("res://addons/godot-oculus/oculus_config.gdns")
	if config:
		oculus_config = config.new()
	
	# Find the interface and initialise
	var arvr_interface = ARVRServer.find_interface("Oculus")
	if arvr_interface and arvr_interface.initialize():
		get_viewport().arvr = true
		
		# make sure vsync is disabled or we'll be limited to 60fps
		OS.vsync_enabled = false

func _process(delta):
	# We want to set our physics to the same refresh rate as our HMD.
	# This info isn't available immediately so..
	if refresh_rate == 0:
		refresh_rate = round(oculus_config.get_refresh_rate())
		
		if refresh_rate != 0:
			print("Setting physics rate to " + str(refresh_rate))
		
			# up our physics to 90fps to get in sync with our rendering
			Engine.iterations_per_second = refresh_rate
	Apphandler.player_position = global_transform.origin

	

func _physics_process(delta):
		# Item	switch stuff more functionality comes later
	if Input.is_action_pressed("ui_accept"):
		if get_node("Right_Hand/shaver").visible == true || noteBookObj.visible == true:
			get_node("Right_Hand/shaver").visible = false
			noteBookObj.visible = false
			noteBookObj.setNotebookActivity(false)
			get_node("Right_Hand/staff").visible = true
			
	if Input.is_action_just_pressed("ui_swap_razor"):
		if get_node("Right_Hand/staff").visible == true || noteBookObj.visible == true:
			get_node("Right_Hand/staff").visible = false
			noteBookObj.visible = false
			noteBookObj.setNotebookActivity(false)
			get_node("Right_Hand/shaver").visible = true
	if Input.is_action_pressed("ui_swap_notebook"):
		if get_node("Right_Hand/staff").visible == true || get_node("Right_Hand/shaver").visible == true:
			get_node("Right_Hand/staff").visible = false
			get_node("Right_Hand/shaver").visible = false
			noteBookObj.visible = true
			noteBookObj.setNotebookActivity(true)

