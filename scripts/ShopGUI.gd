extends VBoxContainer

const items_list = "HBoxContainer/Items/VBoxContainer"
func _ready():
	for slot in get_node(items_list).get_children():
		slot.connect("bought", get_parent(), "_on_ShopItem_bought")
		slot.connect("sold", get_parent(), "_on_ShopItem_sold")
#	add_quest("fiveCoconuts")
#	add_quest("threeStarfish")
func set_items(price_table):
	for i in range (0, get_node(items_list).get_child_count()):
		remove_item_slot(i)
	add_items(price_table)
func add_items(price_table):
	var item_slot = load("res://scenes/GUI/ShopItem.tscn")
	for item_id in price_table.keys():
		var new_slot = item_slot.instance()
		new_slot.initialize(GDInv_ItemDB.get_item_by_id(item_id), price_table[item_id])
		get_node(items_list).add_child(new_slot)
		new_slot.connect("bought", get_parent(), "_on_ShopItem_bought")
		new_slot.connect("sold", get_parent(), "_on_ShopItem_sold")
func add_item(item_id, price_vector:Vector2):
	var item_slot = preload("res://scenes/GUI/ShopItem.tscn")
	var new_slot = item_slot.instance()
	new_slot.initialize(GDInv_ItemDB.get_item_by_id(item_id), price_vector)
	get_node(items_list).add_child(new_slot)
	new_slot.connect("bought", get_parent(), "_on_ShopItem_bought")
	new_slot.connect("sold", get_parent(), "_on_ShopItem_sold")
func remove_item(item):
	for i in range(0,get_node(items_list).get_child_count()):
		if get_node(items_list).get_child(i).item == item:
			call_deferred("remove_item_slot", i)
func remove_item_slot(i:int):
	if i<0 or i >= get_node(items_list).get_child_count():
		return
	get_node(items_list).get_child(i).queue_free()

func add_quest(quest_id):
	var new_quest = load("res://scenes/GUI/QuestBubble.tscn").instance()
	$HBoxContainer/Quests/VBoxContainer.add_child(new_quest)
	new_quest.initialize(quest_id)
	new_quest.connect("clicked", get_parent(), "_on_QuestBubble_clicked")
