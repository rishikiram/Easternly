extends GridContainer


#var size := 6 
#var itemList:=[]

#signal removed_item

func _ready():
	for slot in get_children():
		slot.connect("clicked", self, "_on_slot_clicked")
func update():
	if get_child_count() != PlayerVariables.inventory_size:
		resize(PlayerVariables.inventory_size)
	var player_inv = PlayerVariables.player_inventory
	for i in range (0,player_inv.size()):
		if player_inv[i] != null:
			var texture_path = "res://art/item sprites/%s.png" % player_inv[i].identifier
			get_child(i).get_node("Item").texture = load(texture_path)
		else:
			get_child(i).get_node("Item").texture = null
func resize(x:int):
	while get_child_count() > x:
		remove_child(get_child(0))
	while get_child_count() < x:
		var square = load("res://scenes/GUI/ItemGridSquare.tscn")
		var slot = square.instance()
		add_child(slot)
		slot.connect("clicked", self, "_on_slot_clicked")
#func add_item(item:GDInv_ItemDefinition, i=-1):
#	if i<0:
#		for j in range (0, size):
#			if itemList[j] == null:
#				itemList[j] = item
#				var texture_path = "res://art/item sprites/%s.png" % item.identifier
#				get_child(j).get_node("Item").texture = load(texture_path)
#				return true
#		print("no empty slots in grid!")
#		return false
#	elif i>=size:
#		print("out of index, too big")
#		return false
#	else:
#		if itemList[i] != null:
#			#idea! replaces item and return removed item
#			return false
#		itemList[i] = item
#		var texture_path = "res://art/item sprites/%s.png" % item.identifier
#		get_child(i).get_node("Item").texture = load(texture_path)
#		return true
#func remove_item_at_slot(i:int)-> GDInv_ItemDefinition:
#	if i>=size or i<0:
#		print("out of index, too big")
#		return null
#	else:
#		var return_item = itemList[i]
#		itemList[i] = null
#		get_child(i).get_node("Item").texture = null
#		return return_item
#func remove_item_by_id(id:String)-> GDInv_ItemDefinition:
#	for j in range (0, size):
#		if itemList[j] != null && itemList[j].identifier == id:
#			var return_item = itemList[j]
#			itemList[j] = null
#			get_child(j).get_node("Item").texture = null
#			return return_item
#	print("no items with id: ", id)
#	return null
	
func _on_slot_clicked(i:int):
	PlayerVariables.take_out_item(i)
	update()




