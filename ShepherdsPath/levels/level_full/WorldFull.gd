extends Spatial

var weathercheck

var watherchange = false

var weatherstat = ["SUNNY","SUNNY", "CLOUDY", "THUNDER", "RAIN" ]

onready var randWeatherTimer = get_node("weather_timer")

func _ready():
	#weather stuff
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
	if weathercheck == "SUNNY":
		pass
	if weathercheck == "CLOUDY":
		pass
	if weathercheck == "THUNDER":
		$PostProcessingSphere.raining = true
		$PostProcessingSphere.max_rain_strength = 0.5
	if weathercheck == "RAIN":
		$PostProcessingSphere.max_rain_strength = 0.6
		$PostProcessingSphere.raining = true
	

	randomize()
	var t = rand_range(1, 10)
	randWeatherTimer.set_wait_time(t)
	randWeatherTimer.start()