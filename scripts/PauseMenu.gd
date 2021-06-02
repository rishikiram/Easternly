extends MarginContainer

func _input(event):
	if event.is_action_pressed("escape"):
		visible = !visible
		get_tree().paused = visible
