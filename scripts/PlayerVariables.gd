extends Node
# acts both to contain the data needed globally of the player, 
# and to manage the data by signalling player node and HUD etc..
var player_scene_path := "res://scenes/Players/Sloth.tscn"
#var wind_vector = Vector2()
var player_state = 0
#state:
#-1 - in animation(no control)
#0 - normal
#1 - at the wheel
#func set_player_state(x):
#	player_state = x
#func get_player_state():
#	return player_state 

enum SAIL_ACTION {nothing, up_down, right, left}
var sail_action = SAIL_ACTION.nothing
#var sail_state

signal item_clicked
var clicked_item = null setget set_clicked_item
#var clicked_item : Item = null setget set_clicked_item
func set_clicked_item(item):
	clicked_item = item
	if clicked_item != null:
		emit_signal("item_clicked", item)

signal update_backpack
signal update_HUD
signal backpack_item_removed
#var player 
var player_inventory:=[]#array of item Definitions
var inventory_size := 6
var coins:= 0 
func store_item(item:GDInv_ItemDefinition)->bool:#store in backpack
	for i in range (0,inventory_size):
		if i > player_inventory.size()-1:
			player_inventory.append(item)  
			emit_signal("update_backpack")
			return true
		elif player_inventory[i] == null:
			player_inventory[i] = item
			emit_signal("update_HUD")#update_backpack")
			return true
	print("Cant store item, no space in backpack!")
	return false
func take_out_item(i:int):#take out of backpack
	var r = remove_item_at_slot(i)
	if r != null:
		emit_signal("backpack_item_removed", r)
func remove_item_at_slot(i:int):#just removes item from inv
	if i>=player_inventory.size() or i<0:
		print("out of index when removeing item")
		return
	else:
		var return_item = player_inventory[i]
		if return_item == null:
			return
		player_inventory[i] = null
		return return_item
func remove_item(id:String)->bool:
	for i in range (0,player_inventory.size()):
		if player_inventory[i]!=null && player_inventory[i].identifier == id:
			remove_item_at_slot(i)
			return true
	return false
func buy_item(item:GDInv_ItemDefinition, price)->bool:
	if coins < price:
		return false
	var added = store_item(item)
	if !added:#no space
		return false
	coins -= price
	emit_signal("update_HUD")
	GameData.update_route(["bought", item.identifier, price])
	return true
func sell_item(item:GDInv_ItemDefinition, price)->bool:
	var i = player_inventory.find(item)
	if i >= 0:#and coins >= cost:#cost is a parameter
		player_inventory[i] = null
		coins += price
		emit_signal("update_HUD")
		GameData.update_route(["sold", item.identifier, price])
		return true
	return false
		
#func complete_quest(quest_id)->bool:
#	var q = QuestDB.get_quest_by_id(quest_id)
#	#check if have enough items
#	for key in q.items.keys():
#		if get_item_count_in(key, player_inventory)<q.items[key]:
#			return false
#	#give reward and remove items
#	coins += q.reward
#	for key in q.items.keys():
#		for _i in range (0,q.items[key]):
#			var r = remove_item(key)
#			if !r:
#				print("!!error in completing quest!")
#	emit_signal("update_HUD")
#	return true
func get_item_count_in(id: String, inv:Array)->int:
	var count:= 0
	for item in inv:
		if item!=null && item.identifier==id:
			count += 1
	return count

func save_game():
	var inv := []
	for i in range (0,player_inventory.size()):
		if player_inventory[i] == null:
			inv.append(null)
		else:
			inv.append(player_inventory[i].identifier)
	var player = Global.find_player(Global.current_scene)
	var save_dict := {
		"coins" : coins,
		"inventory" : inv,
		"inventory size" : inventory_size
#		"parent path" : player.get_parent().get_path(),
#		"position" : [player.position.x, player.position.y],
#		"collision layer" : int(log(player.collision_layer)/log(2)),
#		"held item" : player.get_node_or_null("Item").identifier
	}
	return save_dict
func load_game(save_dict):
	coins = save_dict["coins"]
	inventory_size = save_dict["inventory size"]
	var inv = save_dict["inventory"]
	player_inventory = []#reset player inventory
	for i in range (0,inv.size()):
		if inv[i] == null:
			player_inventory.append(null)
		else:
			store_item(GDInv_ItemDB.get_item_by_id(inv[i]) )

#	var new_player = load(player_scene_path).instance()
#	get_node(save_dict["parent path"]).add_child(new_player)
#	new_player.position = Vector2(save_dict["position"][0], save_dict["position"][1])
#	new_player.set_all_collision_layers(save_dict["collision layer"])
#	if save_dict["held item"] != null:
#		pass#func in player class? should create and add held item
		#or! jsut spawn item at same position 
		#as player and player will hit and pick it up!
	
