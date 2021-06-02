extends MarginContainer


var highligheted_box = load("res://art/GUI/Box_highlighted.png")
var box = load("res://art/GUI/Box.png")
var item_sprites_path := "res://art/item sprites/"
var quest_id:String
#signal clicked

func initialize(QUEST_ID):
	quest_id = QUEST_ID
	var quest_item:PackedScene= load("res://scenes/GUI/QuestItem.tscn")
	var quest_items = QuestDB.REGISTRY[quest_id].items
	for key in quest_items:
		var new_slot = quest_item.instance()
		new_slot.get_node("TextureRect").texture = load(item_sprites_path+key+".png")
		new_slot.get_node("Label").text = "X"+str(quest_items[key])
		$MarginContainer/VBoxContainer.add_child(new_slot)
	var reward = $MarginContainer/VBoxContainer/Reward
	reward.get_node("Label").text = str(QuestDB.REGISTRY[quest_id].reward)
	$MarginContainer/VBoxContainer.move_child(reward, $MarginContainer/VBoxContainer.get_child_count()-1)
func _on_QuestBubble_mouse_entered():
	$NinePatchRect.texture = highligheted_box
func _on_QuestBubble_mouse_exited():
	$NinePatchRect.texture = box



func _on_QuestBubble_gui_input(event):
	if event is InputEventMouseButton && event.pressed:
		var completed = PlayerVariables.complete_quest(quest_id)
		if completed:
			queue_free()
