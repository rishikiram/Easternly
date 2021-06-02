extends Timer
# Holds all of the data needed to save game. 
# Is only accessed by other nodes, ndoes not operate on anything else
var clock := 0
signal tik
#var day = 0
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
#		day += 1
#		if day == 7:
#			day = 0

enum SHIP_TYPES {PIRATE, ROWBOAT}
var SHIP_PATHS := [
	"res://scenes/Ship Enviroments/Pirate.tscn",
	"res://scenes/Ship Enviroments/Rowboat.tscn"
	]
var MINISHIP_PATHS := [
	"res://scenes/Miniships/Pirate Mini.tscn",
	"res://scenes/Miniships/Rowboat Mini.tscn"
]
var ship_registery := []#{0(ship id#):{"type" : ROWBOAT, "location" : 0, "in route" : true/false}}
var global_ship_counter := 0
func add_ship(ship_type, island_path = "res://scripts/Islands/HomeIsland.gd", ship_state = {}):# maybe location should be path or scnee name
	if ship_registery.size() <= global_ship_counter:
		ship_registery.resize(global_ship_counter + 1)
	ship_registery[global_ship_counter] = {
		"id" : global_ship_counter,
		"type" : ship_type, 
		"location" : island_path,
		"state" : ship_state
	}
	global_ship_counter += 1
	return (global_ship_counter - 1)
func set_ship_location(ship_id:int, location_scene_path:String):
	ship_registery[ship_id]["location"] = location_scene_path

var island_registery := {}#{"res://island scene path" : island_save_dict}
var route_registery := []

func get_ships_at(island_path):
	var ship_dict_list = []
	for i in range (0,ship_registery.size()):
		if ship_registery[i]["location"] == island_path:
			ship_dict_list.append(ship_registery[i])
	return ship_dict_list
func get_ship(ship_id):
	return ship_registery[ship_id]
	
func load_save_file(game_data):
	route_registery = game_data["route registery"]
	ship_registery = game_data["ship registery"]
	island_registery = game_data["island registery"]
	global_ship_counter = game_data["global ship counter"]
	clock = game_data["clock"]
func create_save_file():
	var save_file := {
		"island registery" : island_registery,
		"route registery" : route_registery, 
		"ship registery" : ship_registery,
		"global ship counter" : global_ship_counter,
		"clock" : clock
	}
	return save_file

var current_route := {}
var current_ship_id := -1
enum ship_event {BOUGHT, SOLD, COLLECTED, DOCKED, AT_SEA}
func start_route(ship_id, start_items = []):
	if current_route.size() != 0:
		print("route already in progress")
		return
		
	current_ship_id = ship_id
	current_route["start time"] = clock
#	current_route["start day"] = day
	current_route["start items"] = start_items
	current_route["ship type"] = ship_registery[ship_id]["type"]
	current_route["event log"] = []
	current_route["times"] = []
func update_route(event: Array):#[[event, modifiers],[bought, "coconut", 3(price)],
	#[arrived, res//island path], [at sea]
	#events: buy/sell item, dock at island, leave to sea
	if current_route.size() == 0:
		return 
#	for event in event_log:
	current_route["event log"].append(event)
	current_route["times"].append(clock)
func end_route():
	if current_route.size() == 0:
		print("route not started!")
		return 
	current_route["end time"] = clock
	route_registery.append(current_route)
	current_route = {}
	current_ship_id = -1
		#end time
		#log items returned 
		#with minus items 
