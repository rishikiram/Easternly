extends Node

var coins:=0
enum CURRENCY {coin, starfish, mango, carpet, porcelain}
signal update_HUD
signal end_game
func _ready():
	pass
func start_game():
	coins = 0
	island_density_counter = 25
	wind_speed_counter = .7
func add_coins(amount = 1)->bool:
	coins += amount
	emit_signal("update_HUD")
	return true
func remove_coins(amount = 1)->bool:
	coins -= amount
	emit_signal("update_HUD")
	if coins < 0:
		emit_signal("end_game")
	#if driving ship, or end of pinball scene, end game
	return true
	
var island_density_counter = 25
var wind_speed_counter = .7

func increase_difficulty(i= 1):
	island_density_counter += i
	wind_speed_counter += i/10

