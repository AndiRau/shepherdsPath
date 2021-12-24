extends ARVROrigin

var oculus_config = null;
var refresh_rate = 0;
var player_pos

#get all the item Objects
onready var inventory = get_node("Inventory")
onready var noteBookObj = get_node("Inventory/notebook")
onready var staffObj = get_node("Inventory/staff")
onready var shaverObj = get_node("Inventory/shaver")
onready var mapObj = get_node("Inventory/map")
onready var right_hand = get_node("Right_Hand")

export var use_keyboard_movement: bool = false

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
	if not use_keyboard_movement:
		if refresh_rate == 0:
			refresh_rate = round(oculus_config.get_refresh_rate())
			
			if refresh_rate != 0:
				print("Setting physics rate to " + str(refresh_rate))
			
				# up our physics to 90fps to get in sync with our rendering
				Engine.iterations_per_second = refresh_rate
	inventory.transform = right_hand.transform
	if use_keyboard_movement:
		inventory.translation += Vector3(0,-1.5,-1.3)
	Apphandler.player_position = $ARVRCamera.global_transform.origin


onready var items: Array = [staffObj, shaverObj, noteBookObj, mapObj]
	
# BEHOLD! The ItemSwap System 
func _input(event: InputEvent):
	if event.is_action_pressed("ui_swap_items"):
		if itemCursor < items.size():
			itemCursor+=1
		if itemCursor == items.size():
			itemCursor = 0

		for c_item in range(items.size()):
			if itemCursor == c_item:
				items[c_item].show()
				print(items[c_item].name)
			else:
				items[c_item].hide()
		if itemCursor == 2:
			noteBookObj.setNotebookActivity(true)
		else:
			noteBookObj.setNotebookActivity(false)
