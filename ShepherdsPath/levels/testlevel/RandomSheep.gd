extends Node

const CLOUDOBJ = preload("res://src/scenery/Cloud.tscn")
var cloud = CLOUDOBJ.instance()
var weathercheck

var watherchange = false

var weatherstat = ["SUNNY","SUNNY", "CLOUDY", "THUNDER", "RAIN" ]

onready var randWeatherTimer = get_node("Weather_Timer")
onready var lightningTimer = get_node("lightning_Timer")



# DayCycle stuff please do touch
func _ready():
	$DirectionalLight/AnimationPlayer.play("SunRotation")
	$WorldEnvironment/AnimationPlayer.play("EnvironmentDayCycle")
	#cloud.global_transform.origin = Vector3(1263, 20, -372)

	#weather stuff
	randomize()
	var t = rand_range(1, 30)
	randWeatherTimer.set_wait_time(t)
	randWeatherTimer.start()
	


func _on_Letter_collectLetter(contents):
	get_node("OculusFirstPerson/Right_Hand/notebook").pages.append(contents)
		

#more weather stuff 
func _on_Weather_Timer_timeout():
	$PostProcessingSphere.raining = false
	weathercheck = weatherstat[rand_range(0,weatherstat.size()-1)]
	print(weathercheck)
	if weathercheck == "SUNNY":
		pass
	if weathercheck == "CLOUDY":
		add_child(cloud)
	if weathercheck == "THUNDER":
		$PostProcessingSphere.raining = true
		$PostProcessingSphere.max_rain_strength = 0.5
		var t = rand_range(3,7)
		lightningTimer.set_wait_time(t)
		lightningTimer.start()
	if weathercheck == "RAIN":
		$PostProcessingSphere.max_rain_strength = 0.6
		$PostProcessingSphere.raining = true
	

	randomize()
	var t = rand_range(1, 10)
	randWeatherTimer.set_wait_time(t)
	randWeatherTimer.start()


# makes the light bling bling for the thunder
func _on_lightning_Timer_timeout():
	if weathercheck == "THUNDER":
		$DirectionalLight/Lightning.play("Lightning")
		var t = rand_range(3,7)
		lightningTimer.set_wait_time(t)
		lightningTimer.start()
	
