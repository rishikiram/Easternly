extends Node2D


#export(PoolStringArray) var shop_items:PoolStringArray=[
#	"coconut", 
#	"starfish_blue",
#	"starfish_orange",
#	"seashell_pink"
#	]
export(Resource) var price_table_resource 
func _ready():
	update_shop()
func update_shop():
	$ShopGUI.set_items(price_table_resource.table)
func add_quest(quest_id):
	$ShopGUI.add_quest(quest_id)
func _on_ShopItem_bought(item):
	var added = PlayerVariables.buy_item(item, price_table_resource.table[item.identifier].x)
	if !added:
		print("inventory full!")
		return
	update_shop()
func _on_ShopItem_sold(item):
	var sold = PlayerVariables.sell_item(item, price_table_resource.table[item.identifier].y)
	if !sold:
		print("cant sell!")
		return
	update_shop()
#func _on_QuestBubble_clicked(quest_bubble):
#
func _on_XButton_pressed():
	visible = false
