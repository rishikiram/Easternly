extends Area2D


#export(int) var exit_to_layer_bit:int
#export(String) var exit_to_new_parent:String

#func _ready():
	#should be child of new sprite layer
	#with ysort child
	#should convert layer value to bit
#	exit_to_layer_bit = log($'../StaticBody2D'.collision_layer)/log(2)
	

#func _on_RoomEntrance_body_exited(body):
#	if body.is_in_group("Carriable"):
#		var gp :Vector2 = body.global_position#i think sometimes unecessary 
#		body.get_parent().remove_child(body)
#		body.set_all_collision_layers(exit_to_layer_bit)
#		print(body, 'Collision Layer', body.collision_layer)
#		$"../YSort".add_child(body)
#		print("parent changed to ", body.get_parent())
#		body.global_position = gp





#const player_mask = 1
#const inactive_mask = 4
#const neutral_bit = 2
#onready var collisionbody = get_parent()
#var bodies,entered,this,frame
#var moved:=false
#var x=1
#var bodyy
#var list_of_bodies: Array
#func _ready():
#	connect("body_entered", self, "_on_RoomArea_body_entered")
#	connect("body_exited", self, "_on_RoomArea_body_exited")
#func _process(delta):
#	if Input.is_action_just_pressed('e'):
#		get_parent().move_body_into_room(bodyy)
#	if Input.is_action_just_pressed("shift"):
#		get_parent().move_body_outof_room(bodyy)
#	if Input.is_action_just_pressed('lmb'):
#		for body in get_overlapping_bodies():
#			print(body,body.name,body.position,body.global_position)
#		x+=1
#func _physics_process(delta):
#	var new_list = get_overlapping_bodies()
#	for body in list_of_bodies:
#		if !(body in new_list):
#			#body_exited(body)
#			get_parent().move_body_outof_room(body)
##			pass
#	for body in new_list:
#		if !(body in list_of_bodies):
#			#body_entered(body)
#			get_parent().move_body_into_room(body)
##			pass
#
#
#func _on_RoomArea_body_entered(body):
#	print("enter signaled")
#	if body.is_in_group("Carriable"):
#		body.z_index = $"../..".z_index
#		print(body," entered ",get_parent().name)
#		return
#		delayed_move_body_in(body)
#		get_parent().move_body_into_room(body)
#		bodyy = body
##would create infinite loop by moveing player into room, 
##thereby signalling this func agian
##should only run this if not in correct layer
##		print(body.collision_layer," ",pow(2,get_parent().layer_bit))
##		print(body.collision_layer != pow(2,get_parent().layer_bit))
#		if body.collision_layer != pow(2,get_parent().layer_bit):
#			pass
#		if !moved:
#			moved = true
#			get_parent().move_body_into_room(body)#
#			if body.is_in_group("Player"):
#				get_parent().make_others_transparent()

#func _on_RoomArea_body_exited(body):
#	print('exit signaled')
#	if body.is_in_group("Carriable"):
#		body.z_index = $"../..".z_index
#		print(body," exited ",get_parent().name)
#		delayed_move_body_out(body)
#		bodyy = body
		
#func delayed_move_body_out(body):
#	yield(get_tree(),"idle_frame")
#	if !(body in get_overlapping_bodies()):
#		get_parent().move_body_outof_room(body)
#		if body.is_in_group("Player"):
#			get_parent().make_others_not_transparent()
#func delayed_move_body_in(body):
#	yield(get_tree(),"idle_frame")
#	if body in get_overlapping_bodies():
#		get_parent().move_body_into_room(body)
#		if body.is_in_group("Player"):
#			get_parent().make_others_transparent()
#func move_body_into_room(body):
#	body.set_all_collision_layers(get_parent().layer_bit)
#	#if body is not being carried
#	body.get_parent().remove_child(body)
#func move_body_outof_room(body):
#	body.set_all_collision_layers(neutral_bit)
