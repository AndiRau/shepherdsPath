extends Node

var weathercheck: String

var watherchange = false


var weatherstat = ["CLOUDY","THUNDER", "SUNNY", "SUNNY", "RAIN" ]

onready var randWeatherTimer = get_node("weather_timer")
onready var lightningTimer = get_node("lightning_timer")

func _ready():
	randomize()
	var t = rand_range(1, 30)
	randWeatherTimer.set_wait_time(t)
	randWeatherTimer.start()

func _on_weather_timer_timeout():
	$PostProcessingSphere.raining = false
	var rng: RandomNumberGenerator = RandomNumberGenerator.new()
	rng.randomize()
	weathercheck = weatherstat[rng.randi_range(0,weatherstat.size()-1)]
	print(weathercheck)
	$Clouds.set_weather(weathercheck)
	if weathercheck == "SUNNY":
		pass
	if weathercheck == "CLOUDY":
		pass
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
	var t = rand_range(5, 20)
	randWeatherTimer.set_wait_time(t)
	randWeatherTimer.start()
	

func _on_lightning_timer_timeout():
	if weathercheck == "THUNDER":
		$lightning/AnimationPlayer.play("thunder")
		var t = rand_range(3,7)
		lightningTimer.set_wait_time(t)
		lightningTimer.start()

		randomize()
	var pos: Vector3 =  Vector3(rand_range(-1, 1), rand_range(-1, 1), 0).normalized()
	pos *= 2000

	pos += Apphandler.player_position
	pos.y = 0
	$lightning.global_transform.origin = pos
