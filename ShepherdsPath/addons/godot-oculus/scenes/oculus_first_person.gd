extends ARVROrigin

var oculus_config = null;
var refresh_rate = 0;
var player_pos

#get all the item Objects
onready var noteBookObj = get_node("Right_Hand/notebook")
onready var staffObj = get_node("Right_Hand/staff")
onready var shaverObj = get_node("Right_Hand/shaver")
onready var mapObj = get_node("Right_Hand/map")

export var use_keyboard_movement: bool = false
export var first_person_script: Script

var noteBookActive : bool = false
var itemCursor = 0


func get_config():
	return oculus_config

func _ready():
	if not use_keyboard_movement:
		$ARVRCamera.set_script(null)
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

	
# BEHOLD! The ItemSwap System 
func _physics_process(_delta):
	if Input.is_action_just_pressed("ui_swap_items"): 
		if itemCursor < 4:
			itemCursor+=1
		if itemCursor == 4:
			itemCursor = 0

	if itemCursor == 0:      #stsaff
		shaverObj.visible = false
		noteBookObj.visible = false
		mapObj.visible = false
		noteBookObj.setNotebookActivity(false)
		staffObj.visible = true
	
	if itemCursor == 1:		#sheepshaver
		staffObj.visible = false
		noteBookObj.visible = false
		mapObj.visible = false
		noteBookObj.setNotebookActivity(false)
		shaverObj.visible = true

	if itemCursor == 2:		#notebook
		staffObj.visible = false
		shaverObj.visible = false
		mapObj.visible = false
		noteBookObj.visible = true
		noteBookObj.setNotebookActivity(true)

	if itemCursor == 3:		#map
		staffObj.visible = false
		shaverObj.visible = false
		noteBookObj.visible = false
		noteBookObj.setNotebookActivity(false)
		mapObj.visible = true