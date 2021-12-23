extends TextureRect



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func OnChangePage(next_prev: int):

	var page_count: int = $Pages.get_child_count()
	var current_page: int = 0

	var i: int = 0
	for page in $Pages.get_children():
		if page.visible == true:
			current_page = i
		i += 1
	
	if next_prev == 1:
		if current_page < page_count-1:
			for page in $Pages.get_children():
				page.visible = false
			$Pages.get_child(current_page + 1).visible = true
	if next_prev == -1:
		if current_page > 0:
			for page in $Pages.get_children():
				page.visible = false
			$Pages.get_child(current_page - 1).visible = true
