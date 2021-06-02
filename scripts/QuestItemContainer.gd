extends "res://scripts/ItemContainter.gd"

#export(bool) var repeat_quest = false
#export(Array) var quest_item_ids :Array
#export(Array) var item_amounts:Array
var star_height = 15
var quests :Array #-. array of dicts of quests
export(PoolStringArray) var quest_ids :PoolStringArray
###a quest is a dictionary items and repeat or not
#
#export(String) var quest_id := "fiveCoconuts"

signal quest_completed

func _ready():
	load_quests()
	update_quests()

func load_quests():
#	if !QuestDB.REGISTRY.has(quest_id):
#		print("Quest id in ", self, " doesnt exist!")
#		return
#	var q = QuestDB.REGISTRY[quest_id]
#	for key in q.keys():
#		quest_item_ids.append(key)
##		print(q[key])
#		item_amounts.append(q[key])
	for id in quest_ids:
		if !QuestDB.REGISTRY.has(id):
			print("Quest id in ", self, " doesnt exist!")
			return
		quests.append(QuestDB.REGISTRY[id].items)
#		quests.append(QuestDB.REGISTRY[id])

#func update_quest():
#	for i in range(0,quest_item_ids.size()):
#		var num_held:int = get_item_count(quest_item_ids[i])
#		if num_held >= item_amounts[i]:#complete quest
#			emit_signal("quest_completed", quest_id)
#			consume_quest_items()
#			if !repeat_quest:#remove quest if not repeat
#				quest_item_ids.remove(i)
#				item_amounts.remove(i)
#				draw_stars(0)
#				break
#		draw_stars( clamp(num_held,0,item_amounts[i]) )
func update_quests():
	var num_stars:=0
	var quest_complete := true
	for quest in quests:
		var quest_item_count:=0
		for item_id in quest.keys():
			var num_have = get_item_count(item_id)
			if num_have < quest[item_id]:#complete quest
				quest_complete = false
			quest_item_count += clamp( num_have, 0,quest[item_id])
		if quest_complete:
			emit_signal("quest_completed", quest_ids[quests.find(quest)])
			consume_quest_items(quest)
			quest_item_count = 0
			if !quest.has("repeat"):#remove quest if not repeat
				call_deferred("remove_quest", quest)
		num_stars += quest_item_count
	draw_stars( num_stars )
	
func consume_quest_items(quest):
#	for i in range (0,quest_item_ids.size()):
#		for _j in range (0, item_amounts[i]):
#			$GDInv_Inventory.remove_item_by_id(quest_item_ids[i])
	for item_id in quest:
		for _j in range(0,quest[item_id]):
			remove_item_by_id(item_id)
func remove_quest(quest):
	quest_ids.remove(quests.find(quest))
	quests.erase(quest)
func get_item_count(id: String)->int:
	var count:= 0
	for item in inventory:
		if item.identifier == id:
			count += 1
	return count
func draw_stars(x:int) -> void:
	$Stars.region_rect.size.y = x*star_height
	$Stars.position.y = 3.5 - 7.5*$Stars.global_scale.y*x
	$Stars.visible = true
	yield(get_tree().create_timer(2), "timeout")
	$Stars.visible = false
	
func screen_added_item(item: GDInv_ItemDefinition):
	if quests.size() == 0:
		return
	for quest in quests:
		if item.identifier in quest.keys():
			return
	yield(get_tree(), "idle_frame")
	inventory.erase(item)
	spawn_item(item)
#func add_stack(item_stack: GDInv_ItemStack) -> bool:
#	var added:bool = .add_stack(item_stack)
##	
#	update_quest()
#	return added
func add_item(item: GDInv_ItemDefinition) -> bool:
	var added:bool = .add_item(item)
	if quests.size() > 0:
		screen_added_item(item)
		update_quests()
	return added
func spawn_item(item: GDInv_ItemDefinition):
	.spawn_item(item)
	update_quests()


func _on_QuestItemContainer_mouse_entered():
	$Stars.visible = true


func _on_QuestItemContainer_mouse_exited():
	$Stars.visible = false
