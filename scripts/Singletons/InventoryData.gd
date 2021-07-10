extends Node

var coins:=0
enum CURRENCY {coin, starfish, mango, carpet, porcelain}
signal update_HUD
func _ready():
	pass
func add_coins(amount = 1)->bool:
	coins += 1
	emit_signal("update_HUD")
	return true
func remove_coins(amount = 1)->bool:
	coins -= 1
	emit_signal("update_HUD")
	return true
	

