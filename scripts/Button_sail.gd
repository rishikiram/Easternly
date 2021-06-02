extends StaticBody2D

export (int) var turn_direction = 0
#1 is right, -1 is left, 0 is up/down

var player_in_range = false


func _ready():
	$Sprite.visible = false
	set_process(false)

func _process(_delta):
	if player_in_range:
		$Sprite.visible = true
		if Input.is_action_just_pressed('e'):
			match turn_direction:
				0:
					PlayerVariables.sail_action = 1 #up/down
					get_tree().call_group("Sail", "sail_updown")
				1:
					PlayerVariables.sail_action = 2 #turn right
					get_tree().call_group("Sail", "turn_sail", 1)
				-1:
					PlayerVariables.sail_action = 3 #turn left
					get_tree().call_group("Sail", "turn_sail", -1)
	else:
		set_process(false)
		$Sprite.visible = false
func _on_Button_input_event(_viewport, event, _shape_idx):
	if (event is InputEventMouseButton && event.pressed):
#		if player_in_range or PlayerVariables.player_state == 1:
		match turn_direction:
			0:
				PlayerVariables.sail_action = 1 #up/down
				get_tree().call_group("Sail", "sail_updown")
			1:
				PlayerVariables.sail_action = 2 #turn right
				get_tree().call_group("Sail", "turn_sail", 1)
			-1:
				PlayerVariables.sail_action = 3 #turn left
				get_tree().call_group("Sail", "turn_sail", -1)


func _on_Button_mouse_entered():
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)


func _on_Button_mouse_exited():
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
