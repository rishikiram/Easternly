extends "res://ShipEnviroment_class.gd"
func _ready():
	pass
func add_player():
	var new_player = load("res://scenes/Players/Sloth.tscn").instance()
	add_child(new_player)
	new_player.position = player_spawn_location
	new_player.set_all_collision_layers(0)
func set_docked(b:bool):
	docked = b
	$"EnterExit Area".monitoring = b
	$"EnterExit Area".monitorable = b
	
func _on_EnterExit_Area_body_entered(body):
	if !body.is_in_group("Player"):
		return
	#draw vector from center to player
	var rowboat_center :Vector2= $"Oar Area/CollisionShape2D".global_position
	var player = get_tree().get_nodes_in_group("Player")[0]
	var player_position :Vector2= player.global_position
	var player_to_rowboat := (rowboat_center - player_position).normalized()
	var tween :Tween = $Tween
	#move in direction aproximatley 3 units
	#add hop animation with tweens
	player.add_collision_exception_with($"Deck Boundary")
#	print(player_to_rowboat.dot(player.velocity_last_frame)
	if player_to_rowboat.dot(player.velocity) > 0:
		
#	if player.get_parent() != self:
		#jump into ship
		PlayerVariables.player_state = -1
		tween.interpolate_property(body, "position", body.position, (body.position + player_to_rowboat*15), 1)
		tween.start()
		#change parent(way to know if player is on ship)
		#yield() until safe to move child
#		var gp :Vector2 = body.global_position
#		body.get_parent().remove_child(body)
#		add_child(body)
#		print("parent changed to ", body.get_parent())
#		body.global_position = gp
	else:
		#jump out of ship
		PlayerVariables.player_state = -1
		tween.interpolate_property(body, "position", body.position, (body.position - player_to_rowboat*15), 1)
		tween.start()
		#change parent(way to know if player is on ship)
#		var gp :Vector2 = body.global_position
#		var island = get_tree().get_nodes_in_group("Island")[0]
#		body.get_parent().remove_child(body)
#		get_node(island.ship_enviroment_parent_path).add_child(body)
#		print("parent changed to ", body.get_parent())
#		body.global_position = gp
	
	
	#change parent(way to know if player is on ship)

func _on_Tween_tween_completed(object, key):
	PlayerVariables.player_state = 0
	get_tree().get_nodes_in_group("Player")[0].remove_collision_exception_with($"Deck Boundary")


func _on_Oar_Area_body_entered(body):
	if docked:
		ask_to_set_sail()


func _on_Oar_Area_body_exited(body):
	pass
