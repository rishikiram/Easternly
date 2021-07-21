extends RigidBody2D
var clicked:=false
var item = -1
func _ready():
	set_physics_process(false)

func _physics_process(delta):

	global_position = get_global_mouse_position()
	
	if not Input.is_action_pressed("lmb"):
		mode = MODE_RIGID
		set_physics_process(false)

func _integrate_forces(state):#only runs in mode is rigid
	if not clicked:
		return
	position = get_global_mouse_position()
	state.transform.origin = global_position
	if not Input.is_action_pressed("lmb"):
#		mode = MODE_RIGID
		clicked = false
		set_collision_layer_bit(0,true)
		set_collision_mask_bit(0,true)
		
		
func _on_coin_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		if mode == MODE_RIGID:
#			contact_monitor = true
			mode = MODE_KINEMATIC
			set_physics_process(true)
			clicked = true
#			$Area2D.monitoring = true
			set_collision_layer_bit(0,false)
			set_collision_mask_bit(0,false)
			
		

func _on_coin_mouse_entered():
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
func _on_coin_mouse_exited():
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)



#func _on_Area2D_body_entered(body):
#	if body.is_in_group("coin") and body != self:
#		mode = MODE_RIGID
#		set_physics_process(false)
#		$Area2D.monitoring = false


#func _on_coin_body_entered(body):
#	if body.is_in_group("coin"):
#		mode = MODE_RIGID
#		contact_monitor = false
#		set_physics_process(false)
