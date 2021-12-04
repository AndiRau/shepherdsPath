extends Node

# nothing to see.

# DayCycle stuff please do touch
func _ready():
	$DirectionalLight/AnimationPlayer.play("SunRotation")
	$WorldEnvironment/AnimationPlayer.play("EnvironmentDayCycle")


func _on_Letter_collectLetter(contents):
	get_node("OculusFirstPerson/Right_Hand/notebook").pages.append(contents)
		
