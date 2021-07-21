tool
extends MarginContainer


var highligheted_box = load("res://art/GUI/Box_highlighted.png")
var box = load("res://art/GUI/Box.png")

var item:GDInv_ItemDefinition
var item_sprites_path := "res://art/item sprites/"

var highlighted_color:= Color(0.95,0.4,0.4)
var default_color:= Color(1,1,1)

signal bought
signal sold

func initialize(an_item:GDInv_ItemDefinition, price_vector:Vector2):
	item = an_item
	set_item() 
	if price_vector.x < 0 and price_vector.y < 0:
		set_price(item.price)
	else:
		set_price(price_vector)
	
func set_item():
	$Item/ItemImage.texture = load(item_sprites_path + item.identifier+".png")
	$Item/ItemLabel.text = item.identifier#replace with below
func set_price(price_vector):
	$Price/Buy/BuyPriceLabel.text = "Buy: "+str( price_vector.x )
	$Price/Sell/SellPriceLabel.text = "Sell: "+str( price_vector.y)
func _on_ShopItem_mouse_entered():
	$NinePatchRect.texture = highligheted_box
func _on_ShopItem_mouse_exited():
	$NinePatchRect.texture = box
#func _on_ShopItem_gui_input(event):
#	if event is InputEventMouseButton and event.pressed:
#		initialize("starfish_orange")
#		pass

func _on_Buy_mouse_entered():
	$Price/Buy/BuyPriceLabel.set("custom_colors/font_color", highlighted_color)
func _on_Buy_mouse_exited():
	$Price/Buy/BuyPriceLabel.set("custom_colors/font_color", default_color)
func _on_Buy_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		emit_signal("bought", item)
		
func _on_Sell_mouse_entered():
	$Price/Sell/SellPriceLabel.set("custom_colors/font_color", highlighted_color)
func _on_Sell_mouse_exited():
	$Price/Sell/SellPriceLabel.set("custom_colors/font_color", default_color)
func _on_Sell_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		emit_signal("sold", item)
