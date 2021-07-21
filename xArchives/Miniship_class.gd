extends KinematicBody2D

export (bool) var is_testing := false

export (float) var max_speed:=200
export (float) var drag:=.75

export (float) var max_rotational_speed:=2.0
export (float) var rotation_acceleration:=0.2
export (float) var r_drag:=0.2


var rot_velocity:float
var current_torque:float
var speed:float
var current_force:float


func get_turn_input()->void:
	current_torque = 0
	#check for max rotational speed  
	if Input.is_action_pressed('d'): 
		current_torque += rotation_acceleration
	if Input.is_action_pressed('a'): 
		current_torque -= rotation_acceleration
	if Input.is_action_pressed('space'):
		row()
func get_input():
	if Input.is_action_just_pressed('w'):
		turn_sail(-1)#counter clockwise
	if Input.is_action_just_pressed('s'):
		turn_sail(1)#clockwise
	if Input.is_action_just_pressed('shift'):
		turn_sail(0)#up/down
func row():
	pass
func turn_sail(x=0):
	pass
func get_forces():
	pass

func _physics_process(delta):
	##reset##
	current_torque = 0 
	
	#####check states####
	#state 1 -> at wheel
	if PlayerVariables.player_state == 1 || is_testing:
		get_turn_input()
	if is_testing:
		get_input()
	
	###check sail_action###
#	print(PlayerVariables.sail_action)
#	if PlayerVariables.sail_action != PlayerVariables.SAIL_ACTION.nothing:
#		turn_sail()	
#		PlayerVariables.sail_action = PlayerVariables.SAIL_ACTION.nothing
		
	
	#####turn ship#####
		#ship would contunuosly rotate for some reason without this
		#rdrag cannot be greater the r acceleration
	if abs(rot_velocity) < r_drag:
		rot_velocity = 0
		#add r-drag
	if current_torque == 0:
		if abs(rot_velocity) > r_drag:
			rot_velocity = 0
		elif rot_velocity > 0:
			rot_velocity -= r_drag
		elif rot_velocity < 0:
			rot_velocity += r_drag
		#torque
	else:
		rot_velocity += current_torque
		#check max rotation speed
	if rot_velocity < -max_rotational_speed:
		rot_velocity = -max_rotational_speed
	elif rot_velocity > max_rotational_speed:
		rot_velocity = max_rotational_speed
	#rotate	
	rotation += rot_velocity*delta
	
	#accelerate#
	speed += get_forces()
	#add drag#
	if abs(speed) < drag:
		speed = 0 
	elif speed > 0:
		speed -= drag
	elif speed < 0:
		speed += drag
		#check max speed
	if speed < -max_speed:
		speed = -max_speed
	elif speed > max_speed:
		speed = max_speed
		#move#
	var velocity = Vector2(speed,0).rotated(rotation)
	velocity = Vector2(velocity.x, velocity.y/2)#isometric
	velocity = move_and_slide(velocity)
	#velocity = velocity.bounce(collision.normal)
	
#	var velocity = Vector2(speed,0).rotated(rotation)
#	var collision = move_and_collide(velocity * delta)
#	if collision:
#		velocity = velocity.bounce(collision.normal)
#		rotation = velocity.angle()
	
	if is_testing:
		get_tree().call_group("Force Label", "set_force", str(get_forces()))
		get_tree().call_group("Speed Label", "set_speed", str(speed))
