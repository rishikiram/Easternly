extends RigidBody2D

func _ready():
	pass


func _on_coin_absorbant_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		coin


func _on_coin_absorbant_mouse_entered():
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)


func _on_coin_absorbant_mouse_exited():
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
