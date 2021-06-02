extends Node

export(String) var scene_path := "write the scene path!"
const item_scene_path = "res://scenes/Item.tscn"
export(String) var ship_enviroment_parent_path := "/root/Node/Node2D/World YSort"
export(PoolVector2Array) var dock_slots := []
#export(int) var unique_id := -1 

#var scene_state:Dictionary
#export(Vector2) var miniship_position = Vector2(93,73)
func _enter_tree():
	add_to_group("Island")
func _ready():
	load_scene()
	var ships = get_tree().get_nodes_in_group("Ship Enviroment")
	for ship in ships:
		if ship.ship_id == -1:#ships will have ids if added in load scene
			ship.ship_id = GameData.add_ship(ship.ship_type, scene_path)
#func create_island_save():
#	Global.create_island_save(save_game(), name)
func initialize(scene_state_dict:Dictionary):
	#every ship has unique ID
	#if ship node exists, just add it in
	#if loading from save, create ship node and call its load func
	
	pass
	
#	if scene_state.has("ship_enviroment"):
#		#store position and free generic instance
#		var ship_position = $"Node2D/Ship Enviroment".position
#		$"Node2D/Ship Enviroment".free()
#		#add transferred instance
#		var ship_envo
#		ship_envo = scene_state.ship_enviroment
#		ship_envo.add_player = false
#		ship_envo.position = ship_position
#		ship_envo.docked = true
#		ship_envo.miniboat_position = miniship_position
#		ship_envo._ready()#initializes everything
#		$Node2D.add_child(ship_envo)
#		$Node2D.move_child(ship_envo, 1)
#		Global.find_player(ship_envo).get_node("Camera2D").make_current()
#		PlayerVariables.player_state = 0
#	else:
#		$"Node2D/Ship Enviroment".add_player = true
#		$"Node2D/Ship Enviroment".docked = true
#		$"Node2D/Ship Enviroment"._ready()
#		Global.find_player($Node2D).get_node("Camera2D").make_current()
#
#	### move ship ysort ###
##	ship_envo.scale = Vector2(1,1)
##	ship_envo.set_docked(true)
#	var ship_ysort = $"Node2D/Ship Enviroment".get_node("Ship YSort")
#	var gp = ship_ysort.global_position
#	$"Node2D/Ship Enviroment".remove_child(ship_ysort)
#	$"Node2D/World YSort".add_child(ship_ysort)
#	ship_ysort.global_position = gp
#	Global.find_player(ship_ysort)._ready()
func save_scene():
	#yield(get_tree(), "idle frame") #-same as called deffered?
	var player_dict = null
	var player_list = get_tree().get_nodes_in_group("Player")
	if player_list.size() > 0:
		player_dict = {
			"parent path" : player_list[0].get_parent().get_path(),
			"position" : [player_list[0].position.x, player_list[0].position.y],
			"collision layer" : int(log(player_list[0].collision_layer)/log(2))
		}
		if player_list[0].is_holding_item:
			player_dict["held item"] = player_list[0].get_node("Item").item.identifier
		player_list[0].free()
	
#	var ship_enviroments := []
	var ships = get_tree().get_nodes_in_group("Ship Enviroment")
	for i in range(ships.size()-1, -1, -1):
#		ship_enviroments.append( ships[i].save_game() )
		ships[i].save_ship()
		ships[i].free() #-will this cause an error? not loop properly through all ships
	

	var items := []
	var items_to_save = get_tree().get_nodes_in_group("Item")
	for item in items_to_save:
		items.append({
			"identifier" : item.item.identifier,
			"parent path" : item.get_parent().get_path(),
			"position" : [item.position.x, item.position.y],
			"collision layer" : int(log(item.collision_layer)/log(2))
		})
	var item_containers := []
	for container in get_tree().get_nodes_in_group("ItemContainer"):
		item_containers.append({
			"path" : container.get_path(),
			"items" : container.get_item_id_list()
		})
	var save_dict := {
#		"id" : unique_id,
#		"scene path" : scene_path, global should save this as:
# "res://scenes/Islands/name.tscn" : {
#		"ship enviroments": ship_enviroments,
		"items" : items,
		"item containers" : item_containers
#		"player" : player_dict
	}
#	if player_dict != null:
#		save_dict["player"] = player_dict
	GameData.island_registery[scene_path] = save_dict
	return true
func load_scene():
	#initialize items, IC and player
	
	if GameData.island_registery.has(scene_path):
		#get save data
		var save_dict = GameData.island_registery[scene_path]
		#free existing items
		var items = get_tree().get_nodes_in_group("Item")
		for item in items:
			item.free()
		#add saved items
		var item_res = load("res://scenes/Item.tscn")
		for item_data in save_dict["items"]:
			var new_item = item_res.instance()
			new_item.init(GDInv_ItemDB.get_item_by_id(item_data["identifier"]))
			new_item.position = Vector2(item_data["position"][0], item_data["position"][1])
			new_item.set_all_collision_layers(item_data["collision layer"])
			get_node(item_data["parent path"]).add_child(new_item)
		#set container contents
		for container_data in save_dict["item containers"]:
			var container = get_node(container_data["path"])
			container.set_items(container_data["items"])
			
	#check to see if ships are here (one has to be if not loaded to start)
	var ship_list = GameData.get_ships_at(scene_path)
	var ships = get_tree().get_nodes_in_group("Ship Enviroment")
	if ship_list == []:
		if ships.size() == 0:
			GameData.current_ship_id = GameData.add_ship(GameData.SHIP_TYPES.ROWBOAT, scene_path)
			ship_list = GameData.get_ships_at(scene_path)
		else:
			return
	#remove starting ships
	for ship in ships:
		ship.free()
	#create and initialize ships from save
	var ship_parent = get_node(ship_enviroment_parent_path)
	var num_ships := 0
	for ship_data in ship_list:
		var new_ship = load(GameData.SHIP_PATHS[ship_data["type"]]).instance()
		new_ship.load_ship(ship_data)
		ship_parent.add_child(new_ship)
#		new_ship.position = dock_slots[num_ships]
		new_ship.position = dock_slots[ship_data["type"]]
		new_ship.set_docked(true)
		num_ships+=1
	#add new player and remove old one
	ships = get_tree().get_nodes_in_group("Ship Enviroment")
	for ship in ships:
		if ship.ship_id == GameData.current_ship_id:
			var players = get_tree().get_nodes_in_group("Player")
			if players.size() > 0:
				players[0].free()
			ship.add_player()
			break
	
	GameData.update_route(["docked", scene_path])
	
