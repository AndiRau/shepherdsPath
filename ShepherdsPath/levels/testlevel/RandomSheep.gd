extends Node

# nothing to see.



func _on_Letter_collectLetter(contents):
	get_node("OculusFirstPerson/Right_Hand/notebook").pages.append(contents)
		
