extends Timer
var clock := 0
signal tik
#var da
var day_length := 300#10 min if each tick is a second
var week_length := 7

func _enter_tree():
	connect("timeout", self, "add_time_unit")
func _ready():
	wait_time = 1
#	load_island_data()
	start()
func add_time_unit():
	clock += 1
	if clock % 600 == 0:
		if clock == 600*week_length:
			clock = 0
	emit_signal("tik", clock)

var coins:=0
enum CURRENCY {coin, starfish, mango, carpet, porcelain}
signal update_HUD
signal end_game

func start_game():
	coins = 0
	island_density_counter = 25
	wind_speed_counter = .7
func add_coins(amount = 1)->bool:
	coins += amount
	emit_signal("update_HUD")
	AudioManager.gain_coin()
	return true
func remove_coins(amount = 1)->bool:
	coins -= amount
	emit_signal("update_HUD")
	if coins < 0:
		emit_signal("end_game")
	AudioManager.loose_coin()
	#if driving ship, or end of pinball scene, end game
	return true
	
var island_density_counter = 25
var wind_speed_counter = .7

func increase_difficulty(i= 1):
	island_density_counter += i
	wind_speed_counter += i/10

