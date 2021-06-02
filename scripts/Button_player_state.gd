extends StaticBody2D
export (int) var player_state_ID:= 1

#signal on_button(id)

var player_in_range := false setget set_player_in_range
signal set_sail
func _ready():
	$Sprite.visible = false
#	set_process(false)
#	connect("body_entered", self, "_on_Button_body_entered") 
#	connect("body_exited", self, "_on_Button_body_exited")
#	connect('input_event', self, "_on_Button_input_event")


#func _on_Button_body_entered(body):
#	if body != null && body.is_in_group("Player"):
#		player_in_range = true
#		$Sprite.visible = true
#func _on_Button_body_exited(body):
#	if body != null && body.is_in_group("Player"):
#		player_in_range = false
#		$Sprite.visible = false

func set_player_in_range(b):
	player_in_range = b
	if player_in_range:
		$Sprite.visible = true
	else:
		$Sprite.visible = false
#func _process(delta):
#	if player_in_range:
#		if PlayerVariables.player_state != player_state_ID:
#			$Sprite.visible = true
#		if Input.is_action_just_pressed('e'):
#			match PlayerVariables.player_state:
#				player_state_ID:
#					PlayerVariables.player_state = 0
#					$Sprite.visible = true
#				0:
#					PlayerVariables.player_state = player_state_ID
#					$Sprite.visible = false
#				_:
#					print("look at button_player_state match cases")
#					PlayerVariables.player_state = 1
#					$Sprite.visible = false
#	else:
#		set_process(false)
#		$Sprite.visible = false
func _unhandled_key_input(event):
	if player_in_range:
		if event.is_action_pressed('e'):
			match PlayerVariables.player_state:
				player_state_ID:
					PlayerVariables.player_state = 0
					$Sprite.visible = true
				0:
					PlayerVariables.player_state = player_state_ID
					$Sprite.visible = false
					emit_signal("set_sail")
				_:
					print("look at button_player_state match cases")
					PlayerVariables.player_state = 1
					$Sprite.visible = false
func _on_Button_input_event(_viewport, event, _shape_idx):
	if (event is InputEventMouseButton && event.pressed):
		if player_in_range:
#			print(self," clicked")
			match PlayerVariables.player_state:
				player_state_ID:
					PlayerVariables.player_state = 0
					$Sprite.visible = true
				0:
					PlayerVariables.player_state = player_state_ID
					$Sprite.visible = false
					emit_signal("set_sail")
				_:
					print("look at button_player_state match cases")
					PlayerVariables.player_state = 1
					$Sprite.visible = false
func _on_Button_mouse_entered():
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
func _on_Button_mouse_exited():
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
