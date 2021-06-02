extends Node
class_name ShopPriceTableCreator
var default_price_table
var SAVE_FOLDER = "res://resources/item data/"
var SAVE_FILE = "DefaultPriceTable.tres"
func _init():
	default_price_table = ShopPriceTable.new()
	var temp:={}
	for key in GDInv_ItemDB.REGISTRY.keys():
		temp[key] = GDInv_ItemDB.REGISTRY[key].price
	default_price_table.table = temp
func save_table():
	var directory: Directory = Directory.new()
	if not directory.dir_exists(SAVE_FOLDER):
		directory.make_dir_recursive(SAVE_FOLDER)
	
	var save_path = SAVE_FOLDER.plus_file(SAVE_FILE)
	var error:int = ResourceSaver.save(save_path, default_price_table )
	if error != OK:
		print("there was an issue saving the default shop table")
