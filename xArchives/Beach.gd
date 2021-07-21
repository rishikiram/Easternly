extends Node

var scene_path = "res://scenes/Beach.tscn"
const ship_enviroment_parent_path := "/root/Node/CanvasLayer/Ship Enviroment Container"
var ship_id:int
#export(Vector2) var ship_enviroment_position := Vector2(258,540)


export(Vector2) var miniship_position := Vector2(93,73)
export(Dictionary) var spawn_location := {
	"res://scenes/Islands/Home Island.tscn" : Vector2(930,666),
	"res://scenes/Islands/Dock10.tscn" : Vector2(140,100),
	"res://scenes/Islands/DockNE.tscn" : Vector2(992, -256)
}

func _ready():
#	var ship_envo
#
#	if scene_state.has("ship_enviroment"):
#		ship_envo = scene_state.ship_enviroment
#	else:
#		ship_envo = load("res://scenes/Ship Enviroment/Pirate.tscn").instance()
#
#	ship_envo.position = ship_enviroment_position
#	ship_envo.docked = false
#	ship_envo.add_player = true
#	ship_envo.add_camera = false
#	$CanvasLayer.add_child(ship_envo)
	#use ship there if not transfered
	
#	if scene_state.has("ship_enviroment"):
#		var ship_position = $"CanvasLayer/Ship Enviroment".position
#		$"CanvasLayer/Ship Enviroment".free()
#		var ship_envo
#		ship_envo = scene_state.ship_enviroment
#		ship_envo.add_player = false
#		ship_envo.position = ship_position
#		ship_envo.docked = false
#		ship_envo.scale = Vector2(2,2)
#		ship_envo._ready()
#		$CanvasLayer.add_child(ship_envo)
#
##	else:
##		$"CanvasLayer/Ship Enviroment".add_player = true
##		$"CanvasLayer/Ship Enviroment".docked = false
##		$"CanvasLayer/Ship Enviroment"._ready()
#
#	var miniship = $"/root/Node/Beach Scene/YSort/Miniship v2"
#	if scene_state.has("miniship_position"):
#		miniship.position = scene_state.miniship_position
#	else:
#		miniship.position = miniship_position
	if GameData.current_ship_id == -1:
		get_tree().get_nodes_in_group("Ship Enviroment")[0].add_player()
		var miniship = get_tree().get_nodes_in_group("miniship")[0]
		miniship.get_node("Camera2D").make_current()
	else:
		load_scene()
		
	randomize_wind()
func randomize_wind():
	var dir = randi() % 4
	var tilted := false
	if randi() % 2 == 1:
		tilted = true
	
	for child in $"Beach Scene/Wind".get_children():
		child.is_tilted = tilted
		child.rotation = PI/2 * dir
func save_scene():
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
	
	var ship_enviroments := []
	var ships = get_tree().get_nodes_in_group("Ship Enviroment")
	for i in range(ships.size()-1, -1, -1):
		ship_enviroments.append( ships[i].save_ship() )
		ships[i].free()
	var save_dict := {
#		"scene path" : scene_path, global should save this as:
# "res://scenes/Islands/name.tscn" : {
#		"ship_id" : ship_id #get ships location from GameData, set the 
							#location to -1 (which is ocean) after getting location for spawn
		"ship enviroments": ship_enviroments,
		"player" : player_dict
		
	}
	GameData.island_registery[scene_path] = save_dict
	return true
func load_scene(): 
	#check how to load
	if GameData.current_ship_id == -1:
		return
	
	#delete existing miniship/ship envo
	var miniships = get_tree().get_nodes_in_group("miniship")
	for node in miniships:
		node.free()
	var ship_envos = get_tree().get_nodes_in_group("Ship Enviroment")
	for node in ship_envos:
		node.free()
	
	#create miniship
	var current_ship = GameData.get_ship(GameData.current_ship_id)
#	print(GameData.MINISHIP_PATHS[current_ship["type"]])
	var new_miniship = load(GameData.MINISHIP_PATHS[current_ship["type"]]).instance()
	$"Beach Scene/YSort".add_child(new_miniship)
	new_miniship.position = spawn_location[current_ship["location"]]
	new_miniship.scale = Vector2(.5,.5)
	
	#create/load ship_enviroment
	var new_ship = load(GameData.SHIP_PATHS[current_ship["type"]]).instance()
	new_ship.ship_id = current_ship["id"]
	get_node(ship_enviroment_parent_path).add_child(new_ship)
	match current_ship["type"]:
		GameData.SHIP_TYPES.ROWBOAT:
			get_node("CanvasLayer/Ship Enviroment Container").rect_scale = Vector2(3,3)
		GameData.SHIP_TYPES.PIRATE:
			get_node(ship_enviroment_parent_path).rect_scale = Vector2(2,2)
	new_ship.load_ship(current_ship)
	new_ship.add_player()
	get_tree().get_nodes_in_group("Player")[0].get_node("Camera2D").make_current()
	
	new_miniship.get_node("Camera2D").make_current()
	
	
	
	
	
	
	
	
	
#	if !save_dict.has("player"):
#		print("error! no player")
	#check game data to see if any ship are here
	#initialize ship if accesable to player
	#initialize items, IC and player
	
#	var ship_list = GameData.get_ships_at(scene_path)
#	if ship_list == []:
#		GameData.current_ship_id = GameData.add_ship(GameData.SHIP_TYPES.ROWBOAT, scene_path)
#		ship_list = GameData.get_ships_at(scene_path)
#	var ship_parent = get_node(ship_enviroment_parent_path)
#	for ship_data in ship_list:
#		var new_ship = load(ship_data["state"]["scene path"]).instance()
#		new_ship.load_ship(ship_data)
#		ship_parent.add_child(new_ship)
		#create func to move ships into slots on the dock
	
#	var item_res = load("res://scenes/Item.tscn")
#	for item_data in save_dict["items"]:
#		var new_item = item_res.instance()
#		new_item.init(GDInv_ItemDB.get_item_by_id(item_data["identifier"]))
#		new_item.position = Vector2(item_data["position"][0], item_data["position"][1])
#		new_item.set_all_collision_layers(item_data["collision layer"])
#		get_node(item_data["parent path"]).add_child(new_item)
#
#	for container_data in save_dict["item containers"]:
#		var container = get_node(container_data["path"])
#		container.set_items(container_data["items"])
#
#	var new_player = load("res://scenes/Players/Sloth.tscn").instance()
#	var ships = get_tree().get_nodes_in_group("Ship Enviroment")
#	for ship in ships:
#		if ship.ship_id == GameData.current_ship_id:
#			ship.add_player()
#			break
#	new_player.get_node("Camera2D").make_current()
	
