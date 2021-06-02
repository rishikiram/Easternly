extends YSort

const scene_path = "res://scenes/Ship Enviroments/SHIP NAME.tscn"
export(int) var ship_id = -1
export(GameData.SHIP_TYPES) var ship_type

export(bool) var add_player_on_ready:= false
export(bool) var docked:= false
export(Vector2) var dialogue_position := Vector2(0,-80)

export(Vector2) var player_spawn_location := Vector2(125, 50)
export(String) var player_spawn_parent := ""

export(String) var ocean_scene_path := "res://scenes/Beach.tscn"
#export(String) var next_scene_parent_path := "/root/Node/CanvasLayer"
#export(Vector2) var  miniboat_position:=  Vector2(93,73)
#func _enter_tree():
#	if ship_id != null:
#		self.name = str("Ship Enviroment ",ship_id)
func _enter_tree():
	$Dialogue.connect("Dialogue_Event", self, "_on_Dialogue_Event")
func _ready():
#	if ship_id == -1:
#		ship_id = GameData.add_ship(ship_type)
	set_docked(docked)
	if add_player_on_ready:
		add_player()
func add_player():
	var new_player = preload("res://scenes/Players/Sloth.tscn").instance()
	get_node(player_spawn_parent).add_child(new_player)
	new_player.position = player_spawn_location
	new_player.get_node("Camera2D").make_current()
func ask_to_set_sail():
	$Dialogue.DialogueResource = load("res://resources/dialogue/setSail.tres")
	var vstack = DialogueVStacker.new($Dialogue)
	add_child(vstack)
	vstack.position = dialogue_position
	$Dialogue.start_dialogue()
func _on_Dialogue_Event(event:String, _modifiers):
	if event.findn("sail") >= 0:
		call_deferred("set_sail")
func set_sail():
#	var ship_ysort = self
#	var ship_ysort = Global.find_player(get_node(/root/Node/Node2D), "ship ysort")
#	ship_ysort.get_parent().remove_child(ship_ysort)
#	ship_ysort.position = Vector2(0,0)
#	add_child(ship_ysort)
		
#	var miniboat = load("res://scenes/MiniBoat.tscn").instance()
#	var scene_state := {
#		"ship_enviroment": self,
#		"miniship_position": miniboat_position
#	}
#	self.get_parent().remove_child(self)
	GameData.current_ship_id = ship_id
	var cur_loc = get_tree().get_nodes_in_group("Island")[0].scene_path
	
	if cur_loc == "res://scenes/Islands/Home Island.tscn":
		GameData.start_route(ship_id)
	else:
		GameData.update_route(["set sail"])
	GameData.set_ship_location(ship_id, cur_loc)
	Global.goto_scene(ocean_scene_path)

	
func set_docked(b:bool):
	docked = b
	print("make custom set_docked function")
func save_ship():
	#should be called by Island class during idle state to freeing is safe
	#right now plyaer is saved and freed before ship envos
#	var player_dict = null
#	var player_list = get_all_children_in_group(self, "Player")
#	if player_list.size() > 0:
#		player_dict = {
#			"parent path" : get_path_to(player_list[0].get_parent()),
#			"position" : [player_list[0].position.x, player_list[0].position.y],
#			"collision layer" : int(log(player_list[0].collision_layer)/log(2))
#		}
#		if player_list[0].is_holding_item:
#			player_dict["held item"] = player_list[0].get_node("Item").item.identifier
#		player_list[0].free

	var items := []
	for item in get_all_children_in_group(self, "Item"):
		items.append({
			"identifier" : item.item.identifier,
			"parent path" : get_path_to(item.get_parent()),
			"position" : [item.position.x, item.position.y],
			"collision layer" : int(log(item.collision_layer)/log(2))
		})
	var item_containers := []
	for container in get_all_children_in_group(self, "ItemContainer"):
		item_containers.append({
			"path" : get_path_to(container),
			"items" : container.get_item_id_list()
		})
	var save_dict := {
		"scene path" : scene_path,
		"items" : items,
		"item containers" : item_containers
	}
	GameData.ship_registery[ship_id]["state"] = save_dict
	return save_dict
#	if player_dict != null:
#		save_dict["player"] = player_dict
func load_ship(ship_data: Dictionary):
	ship_id = ship_data["id"]
#	var save_dict = ship_data["state"]
	if ship_data["state"].size() == 0:
		return
	var items = get_all_children_in_group(self, "Item")
	for item in items:
		item.free()
	var item_res = load("res://scenes/Item.tscn")
	for item_data in ship_data["state"]["items"]:
		var new_item = item_res.instance()
		new_item.init(GDInv_ItemDB.get_item_by_id(item_data["identifier"]))
		new_item.position = Vector2(item_data["position"][0], item_data["position"][1])
		new_item.set_all_collision_layers(item_data["collision layer"])
		get_node(item_data["parent path"]).add_child(new_item)
	
	for container_data in ship_data["state"]["item containers"]:
		var container = get_node(container_data["path"])
		container.set_items(container_data["items"])
	
#	if save_dict.has("player"):
#		var new_player = load("res://scenes/Players/Sloth.tscn").instance()
#		var player_data = save_dict["player"]
#		new_player.position =  Vector2(player_data["position"][0], player_data["position"][1])
#		new_player.set_all_collision_layers(player_data["collision layer"])
#		get_node(player_data["parent path"]).add_child(new_player)
func get_all_children_in_group(node, group):
	var nodes = []
	for N in node.get_children():
		if N.is_in_group(group):
			nodes.append(N)
		elif N.get_child_count() > 0:
			var more_nodes = get_all_children_in_group(N, group)
			for node in more_nodes:
				nodes.append(node)
	return nodes
	  
