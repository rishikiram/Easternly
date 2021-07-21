extends KinematicBody2D

export (bool) var is_testing := false
export (bool) var is_sleep = false

export (float) var max_speed:=200
export (float) var v_drag:= 0.75
export (float) var h_drag:= 5
export (float) var min_bounce_speed = 100

export (float) var max_rotational_speed:=2.4
export (float) var rotation_acceleration:=0.2
export (float) var r_drag:=0.2

var rot_velocity:float
var current_torque:float
var velocity :Vector2
var current_force:float

export (bool) var idle:=false

onready var spin_coin = preload("res://scenes/Coin_Spinning.tscn")

func get_input()->void:
	if Input.is_action_pressed('d'): 
		current_torque += rotation_acceleration
	if Input.is_action_pressed('a'): 
		current_torque -= rotation_acceleration
	if Input.is_action_pressed('space'):
		row()

func row():
	pass

func get_forces():
	pass
func get_torque():
	pass
func loose_coin():
	GameData.remove_coins(1)
	#create coin
	var new_coin = spin_coin.instance()
	#make it fly in an arc
	new_coin.position = position
	new_coin.idle = false
	new_coin.monitoring = false
	new_coin.monitorable = false
	new_coin.z_index = 1
	new_coin.direction = Vector2(1,0).rotated(Global.rng.randf_range(0,2*PI))
	get_parent().add_child(new_coin)
	
	#dissapear
	
	
func _physics_process(delta):
	##reset##
	current_torque = 0
	if not idle: 
		get_input()
	
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
	velocity = velocity.rotated(rot_velocity*delta/10) 
	
	#accelerate#
	velocity += get_forces()
	#print("vel befor drag:", velocity)
	
	#add drag#
	#horzontal to ship dir
	var h_normal_vector = Vector2(1,0).rotated(rotation + PI/2)
	#print("h_normal_vector", h_normal_vector)
	var h_speed = velocity.dot(h_normal_vector)
	if abs(h_speed) < h_drag:
		velocity = velocity - h_normal_vector*h_speed
	elif h_speed > 0:
		velocity = velocity - h_normal_vector*h_drag
	elif h_speed < 0:
		velocity = velocity + h_normal_vector*h_drag
	#parallel to ship direction	
	var v_normal_vector = Vector2(1,0).rotated(rotation)
	var v_speed = velocity.dot(v_normal_vector)
	if abs(v_speed) < v_drag:
		velocity = velocity - v_normal_vector*v_speed
	elif v_speed > 0:
		velocity = velocity - v_normal_vector*v_drag
	elif v_speed < 0:
		velocity = velocity + v_normal_vector*v_drag
		
	#print("vel after drag:", velocity)
	#check max speed
	if velocity.length() > max_speed:
		velocity = velocity / velocity.length() * max_speed
	#print("vel after max speed:", velocity, '\n\n')
	#move#
	#velocity = Vector2(velocity.x, velocity.y/2)#isometric
	#velocity = move_and_slide(velocity)
	#velocity = velocity.bounce(collision.normal)
	
#	var velocity = Vector2(speed,0).rotated(rotation)
	var collision = move_and_collide(Vector2(velocity.x, velocity.y/2) * delta)
	if collision:
		loose_coin()
		velocity = velocity.bounce(collision.normal)
		if velocity.dot(collision.normal) < min_bounce_speed:
			velocity = velocity + collision.normal*(min_bounce_speed-velocity.dot(collision.normal))
	
	
