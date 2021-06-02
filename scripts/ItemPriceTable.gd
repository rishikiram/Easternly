extends Resource
class_name ItemPriceTable

#export(String) var id
export(int) var buy_price
export(int) var sell_price

func _init(item):
#	id = item.identifier
	buy_price = item.price.x
	sell_price = item.price.y
