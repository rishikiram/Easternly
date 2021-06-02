extends "res://ShipEnviroment_class.gd"
#export(int) var test = 1
#func _ready():
#	set_docked(docked)
func set_docked(b:bool):
	docked = b
	$"Ramp".docked = b
	$"Ramp".update_ramp()
	if docked:
		$"Anchor_up".visible = false
		$"Anchor_down".visible = true
	else:
		$"Anchor_up".visible = true
		$"Anchor_down".visible = false
func add_player():
	var new_player = load("res://scenes/Players/Sloth.tscn").instance()
	get_node(player_spawn_parent).add_child(new_player)
	new_player.position = player_spawn_location
	new_player.set_all_collision_layers(3)

var sail_is_up:= false
var sail_state:=0
#positive is right, negative is left
onready var sail_up_node := $"Lower Deck/YSort/Sail_Up"
onready var sail_center_node := $"Lower Deck/YSort/Sail_Center"
onready var sail_right_node := $"Lower Hull/YSort/Sail_Right"
onready var sail_left_node := $"Lower Deck/YSort/Sail_Left"
func turn_sail(x:int):
	if sail_is_up:
		sail_up_node.visible = false
		sail_center_node.visible = true
		sail_is_up = false
		return
	
	sail_state += x
	sail_state = clamp(sail_state, -1, 1)
	match sail_state:
		-1:#left
			sail_center_node.visible = false
			sail_right_node.visible = false
			sail_left_node.visible = true
		0:#center
			sail_left_node.visible = false
			sail_right_node.visible = false
			sail_center_node.visible = true
		1:#right
			sail_left_node.visible = false
			sail_center_node.visible = false
			sail_right_node.visible = true
func sail_updown():
	sail_state = 0
	if !sail_is_up:
		sail_center_node.visible = false
		sail_right_node.visible = false
		sail_left_node.visible = false
		sail_up_node.visible = true
		sail_is_up = true
	else:
		sail_up_node.visible = false
		sail_center_node.visible = true
		sail_is_up = false


func _on_Anchor_up_pressed():
	if docked:
		ask_to_set_sail()
func _on_Anchor_down_pressed():
	if docked:
		ask_to_set_sail()

