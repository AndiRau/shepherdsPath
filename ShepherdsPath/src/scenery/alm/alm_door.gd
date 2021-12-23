extends Area

export var AlmExport: NodePath

onready var anim_player: AnimationPlayer = get_node(AlmExport).get_node("AnimationPlayer")

func _on_player_entered(area: Area):
	if area.is_in_group("player"):
		print("OPEN")
		anim_player.play("door_open")

func _on_player_exited(area: Area):
	if area.is_in_group("player"):
		anim_player.play("door_close")
