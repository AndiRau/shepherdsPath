extends Node

# nothing to see.



func _on_Letter_collectLetter(contents):
	print("ich bin ein Bielefelder")
	get_node("OculusFirstPerson/Right_Hand/notebook/notebook").pages.append(contents)
		
