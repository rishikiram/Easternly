extends StaticBody2D
#
##signal player_entered
##signal player_exited
#signal make_transparent
#signal make_not_transparent
#
#onready var roomarea = $RoomArea
#onready var sprite = get_parent()
##onready var tween = get_node("RoomArea/Tween")
#
#export(float) var transparent_value = 0.4
export(int) var layer_bit:= -1
#
#const neutral_bit = 2
##const player_mask = 1
##const inactive_mask = 4
#
func _ready():
	#allows collision mask to be set by layer_bit var of the normal way
	if layer_bit >= 0:
		collision_layer = int(pow(2,layer_bit))
		collision_mask = int(pow(2,layer_bit))
	if layer_bit < 0:
		layer_bit = int(log(collision_layer)/log(2))
	
	$RoomEntrance.set_collision_layer_bit(layer_bit, false)
	$RoomEntrance.set_collision_mask_bit(layer_bit, false)
##	roomarea.set_collision_layer_bit(layer_bit, true)
##	roomarea.set_collision_mask_bit(layer_bit, true)
func _on_RoomEntrance_body_exited(body):
	print("exited", self)
	yield(get_tree(), "idle_frame")
	if body != null and (body.is_in_group("Player") or body.is_in_group("Carriable")):
		if not body.get_parent().is_in_group("Player"):
			var gp :Vector2 = body.global_position
			body.get_parent().remove_child(body)
			body.set_all_collision_layers(layer_bit)
			print(body, 'Collision Layer', body.collision_layer)
			$"../YSort".add_child(body)
			print("parent changed to ", body.get_parent())
			body.global_position = gp
func disable():
	set_collision_layer_bit(layer_bit, false)
	set_collision_mask_bit(layer_bit, false)
	$RoomEntrance.monitoring = false
func enable():
	set_collision_layer_bit(layer_bit, true)
	set_collision_mask_bit(layer_bit, true)
	$RoomEntrance.monitoring = true
#func _on_RoomArea_body_entered(body):
#	if body.is_in_group("Carriable"):
#		body.z_index = $"..".z_index
#		body.set_all_collision_layers(layer_bit)
#		print(body," collision layer ", layer_bit, " is true")
##		if body.is_in_group("Player"):
##			emit_signal("make_transparent")
##func _on_RoomArea_body_exited(body):
##	if body.is_in_group("Carriable"):
##		body.z_index = $"..".z_index
##		body.set_all_collision_layers(layer_bit, false)
##		print(body," collision layer ", layer_bit, " is false")
#
#func move_body_into_room(body):
#	if body.is_in_group("Carriable"):
#		body.z_index = $"../..".z_index
#		body.set_all_collision_layers(layer_bit)
#		#because ysorts have same g-position
##		if body.collision_layer != pow(2,layer_bit):
##			var gp :Vector2 = body.global_position#i think sometimes unecessary 
##			body.get_parent().remove_child(body)
##			body.set_all_collision_layers(layer_bit)
##			print(body, 'Collision Layer', body.collision_layer)
##			$"../YSort".add_child(body)
###			$"..".add_child(body)
##			print("parent changed to ", body.get_parent())
##
##
##		#print(body.global_position)
##			body.global_position = gp
#
#
#func move_body_outof_room(body):
#	#neutral area is Lower Deck, move there
#	if !body.get_parent().is_in_group("Player"):
#		if body.collision_layer != pow(2,neutral_bit):
#			var gp = body.global_position
#			body.get_parent().remove_child(body)
##		$"../../Lower Deck/YSort".add_child(body)
#			$"..".add_child(body)
##		body.global_position = gp
#			body.set_all_collision_layers(neutral_bit)
#			print("parent changed to ", body.get_parent())
#			print(body, 'Collision Layer', body.collision_layer)
#func make_others_transparent():
#	emit_signal("make_transparent")
#
#func make_others_not_transparent():
#	emit_signal("make_not_transparent")
#func _on_Room_make_transparent():
##	tween.interpolate_property($Sprite, "modulate",
##        Color(1,1,1,1) , Color(1,1,1,.4), .5,
##        Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
##	tween.start() 
#	sprite.modulate = Color(1,1,1,transparent_value)
#func _on_Room_make_not_transparent():
#	sprite.modulate = Color(1,1,1,1)
#
