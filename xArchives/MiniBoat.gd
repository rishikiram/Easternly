extends KinematicBody2D

export (float) var max_speed = 200
#export (float) var sail_rspeed = .05
export (float) var drag = .5 #used for constant drag, old value was .5
#var drag = null

export (float) var max_rotational_speed = 1
export (float) var rotation_acceleration = .1
export (float) var r_drag = .05

export(float) var oar_force = 1.5
export(float) var wind_force_coefficient = .75

var sail_rotation_dir = int() 
var rot_velocity = float()
var current_torque = float()
var speed = float()
var current_force = float()

onready var sail_path = $Sail
onready var oar_path = $Oar

func get_turn_input()->void:
	current_torque = 0
	#check for max rotational speed  
	if Input.is_action_pressed('d'): 
		if rot_velocity < max_rotational_speed:
			current_torque += rotation_acceleration
	if Input.is_action_pressed('a'): 
		if rot_velocity > -max_rotational_speed: 
			current_torque -= rotation_acceleration
	if Input.is_action_pressed('space'):
		get_tree().call_group("oars", "row") 

func get_input():
	
	if Input.is_action_just_pressed('w'):
		get_tree().call_group("Sail", "turn_sail", -1)
	if Input.is_action_just_pressed('s'):
		get_tree().call_group("Sail", "turn_sail", 1)
	if Input.is_action_just_pressed('shift'):
		get_tree().call_group("Sail", "sail_updown")

func turn_sail():
	match PlayerVariables.sail_action:
		PlayerVariables.SAIL_ACTION.up_down:
			get_tree().call_group("Sail", "sail_updown")
		
		PlayerVariables.SAIL_ACTION.right:
			get_tree().call_group("Sail", "turn_sail", 1)
		
		PlayerVariables.SAIL_ACTION.left:
			get_tree().call_group("Sail", "turn_sail", -1)
	
	PlayerVariables.sail_action = PlayerVariables.SAIL_ACTION.nothing
func get_wind_force():
	var areas = $Area2D.get_overlapping_areas()
	var wind_vector := Vector2(0,0)
	for area in areas:
		if area.is_in_group("wind"):
			wind_vector = area.get_parent().wind_vector
			break
#	if Input.is_action_just_pressed("e"):
#		print(wind_vector)
		
	var ship_dir = Vector2(1,0).rotated(rotation)
	
	var sail_dir = sail_path.get_sail_direction().rotated(rotation)
	
	#Modulate Color - squared verison
	$Sail.modulate = Color.from_hsv(0.33*sail_dir.dot(wind_vector)*abs(sail_dir.dot(wind_vector)), 1, 1)
	var force = sail_dir.dot(wind_vector)*abs(sail_dir.dot(wind_vector))*sail_dir
	#non_squared verison
#	$Sail.modulate = Color.from_hsv(0.33*sail_dir.dot(wind_vector), 1, 1)
#	var force = sail_dir.dot(wind_vector)*sail_dir
	force = force.dot(ship_dir)*wind_force_coefficient
	
	return force

func _physics_process(delta):
	##reset##
	current_torque = 0 
	
	#####check states####
	#state 1 -> at wheel
	if PlayerVariables.player_state == 1:
		get_turn_input()
	
	###check sail_action###
#	print(PlayerVariables.sail_action)
	if PlayerVariables.sail_action != PlayerVariables.SAIL_ACTION.nothing:
		turn_sail()	
		
		
	#get_input()#sets current_torque and sail_rotation_dir
				#and rows oars
	#####turn ship#####
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
	######add drag######
	#quadratic drag
	#drag = speed*speed/1000000 +.5
	#print("drag = ", drag)
	if speed > 0:
		speed -= drag
	elif speed < 0:
		speed += drag
	#check max speed
	elif speed < -max_speed:
		speed = -max_speed
	elif speed > max_speed:
		speed = max_speed
	
	###accelerate###
	current_force = 0
	####oar-force###
	var t = oar_path.t
	if t > PI:
		current_force += oar_force
	current_force += get_wind_force()
	speed += current_force
	#####move######
	var velocity = Vector2(speed,0).rotated(rotation)
	velocity = move_and_slide(velocity)
#	velocity = move_and_collide(velocity/100)
	
	###for debugging, tells me what it collides with######
#	for i in range(get_slide_count() - 1):
#		var collision = get_slide_collision(i)
#		print(collision.collider.name)
#		print(self.collision_mask)
	
