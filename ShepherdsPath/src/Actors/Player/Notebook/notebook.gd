extends Spatial

var pages : Array
var cursor = 0
var notebookactiv = false



func _ready():
	pages.append("pain")
	pages.append("Is")
	pages.append("like")
	pages.append("your")
	pages.append("soul")
	pages.append("right?")
	
	pass 

func _physics_process(_delta):
	if notebookactiv:
		if Input.is_action_just_pressed("ui_notebook_nav_left"):
			if cursor > 0:
				cursor-=1
		
		if Input.is_action_just_pressed("ui_notebook_nav_right"):
			if cursor < pages.size():
				cursor+=1

	print(cursor)



func setNotebookActivity(status : bool):
	notebookactiv = status

func pickUpLetter(letter):
	pages.append(letter)