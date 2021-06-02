extends KinematicBody2D

export (float) var max_speed = 200
export (float) var acceleration = 4
export (float) var drag = 2

export (float) var max_rotational_speed = 2
export (float) var rotation_acceleration = .25
export (float) var r_drag = .1

var rot_velocity = float()
var current_torque = float()
#var velocity = Vector2(0,0)
var speed = float()
var current_force = float()

func get_input():
	current_force = 0
	current_torque = 0
	
	#the check for max rotational speed works here 
	if Input.is_action_pressed('d'): 
		if rot_velocity < max_rotational_speed:
			current_torque += rotation_acceleration
	if Input.is_action_pressed('a'): 
		if rot_velocity > -max_rotational_speed: 
			current_torque -= rotation_acceleration
	
	#the check for max speed does not work here, need speed not velocity 
#	if Input.is_action_pressed('w'):
#		if velocity.length() < max_speed: 
#			current_force += acceleration	
#	if Input.is_action_pressed('s'):
#		if velocity.length() < max_speed: 
#			current_force -= acceleration
	if Input.is_action_pressed('w'):
		if speed < max_speed: 
			current_force += acceleration	
	if Input.is_action_pressed('s'):
		if speed > -max_speed: 
			current_force -= acceleration
func _physics_process(delta):
	get_input()
	
	#ship would contunuosly rotate for some reason without this
	#rdrag cannot be greater the r acceleration
	if abs(rot_velocity) < r_drag:
		rot_velocity = 0
	#add r-drag
	if current_torque == 0:
		if rot_velocity > 0:
			rot_velocity -= r_drag
		elif rot_velocity < 0:
			rot_velocity += r_drag
	#check max rotation speed
	elif rot_velocity < -max_rotational_speed:
		rot_velocity = -max_rotational_speed
	elif rot_velocity > max_rotational_speed:
		rot_velocity = max_rotational_speed
	#accelerate
	else:
		rot_velocity += current_torque
	#rotate	
	rotation += rot_velocity*delta
	
	#add drag
	if current_force == 0:
		if speed > 0:
			speed -= drag
		elif speed < 0:
			speed += drag
	#check max speed
	elif speed < -max_speed:
		speed = -max_speed
	elif speed > max_speed:
		speed = max_speed
	#accelerate
	else:
		speed += current_force
	
	#move
	var velocity = Vector2(speed,0).rotated(rotation)
	velocity = move_and_slide(velocity)

	
