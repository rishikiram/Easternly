extends KinematicBody2D

export (float) var acceleration = 1
export (float) var rotation_acceleration = .25
export (float) var drag = .5

var rot_velocity = float()
var current_torque = float()
var velocity = Vector2(0,0)
var current_force = float()

func get_input():
	current_force = 0
	current_torque = 0
	
	if Input.is_action_pressed('d'): 
		current_torque += rotation_acceleration
	if Input.is_action_pressed('a'): 
		current_torque -= rotation_acceleration
		
	if Input.is_action_pressed('w'): 
		current_force += acceleration	
	if Input.is_action_pressed('s'): 
		current_torque -= acceleration
func _physics_process(delta):
	get_input()
	
	rot_velocity += current_torque
	rotation += rot_velocity*delta
	
	#create accel vector in rotated dir
	var accel_vector = Vector2(current_force,0).rotated(rotation)
	#create drag vector 
	var dragg =( Vector2(velocity.x, velocity.y).normalized() )* -drag
	#rotate velocity and drag and the add velocity, drag, and accel(or force)
	velocity = velocity.rotated(rotation) + accel_vector + drag.rotated(rotation)
	#move
	velocity = move_and_slide(velocity)
