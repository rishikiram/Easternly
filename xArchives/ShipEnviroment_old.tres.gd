extends Node2D

export(bool) var add_player:= false
#export(bool) var add_camera:= false
export(bool) var docked:= false
export(Vector2) var dialogue_position := Vector2(0,-80)
export(String) var next_scene_path := "res://scenes/Beach.tscn"
#export(String) var next_scene_parent_path := "/root/Node/CanvasLayer"
export(Vector2) var  miniboat_position:=  Vector2(93,73)
func _ready():
	
#	if in_world:
#		var ship_ysort = $"Ship YSort"
#		remove_child(ship_ysort)
#		get_node("../World YSort").add_child(ship_ysort)
	set_docked(docked)
	turn(0)
	if add_player:
		var new_player = preload("res://scenes/DinoPlayer.tscn").instance()
		$"Ship YSort/Lower Deck/YSort".add_child(new_player)
		new_player.set_all_collision_layers(2)
		new_player.position = Vector2(125, 50)
#		if add_camera:
#			var new_cam = Camera2D.new()
#			new_player.add_child(new_cam)
#			new_cam.current = true
var sail_is_up:= false
var sail_state:=0
#positive is right, negative is left
func turn(x:int):
	if sail_is_up:
		$"Ship YSort/Lower Deck/YSort/Sail_Up".visible = false
		$"Ship YSort/Lower Deck/YSort/Sail_Center".visible = true
		sail_is_up = false
		return
	
	sail_state += x
	sail_state = clamp(sail_state, -1, 1)
	match sail_state:
		-1:#left
			$"Ship YSort/Lower Deck/YSort/Sail_Center".visible = false
			$"Ship YSort/Lower Hull/YSort/Sail_Right".visible = false
			$"Ship YSort/Lower Deck/YSort/Sail_Left".visible = true
		0:#center
			$"Ship YSort/Lower Deck/YSort/Sail_Left".visible = false
			$"Ship YSort/Lower Hull/YSort/Sail_Right".visible = false
			$"Ship YSort/Lower Deck/YSort/Sail_Center".visible = true
		1:#right
			$"Ship YSort/Lower Deck/YSort/Sail_Left".visible = false
			$"Ship YSort/Lower Deck/YSort/Sail_Center".visible = false
			$"Ship YSort/Lower Hull/YSort/Sail_Right".visible = true
func sail_updown():
	sail_state = 0
	if !sail_is_up:
		$"Ship YSort/Lower Deck/YSort/Sail_Center".visible = false
		$"Ship YSort/Lower Hull/YSort/Sail_Right".visible = false
		$"Ship YSort/Lower Deck/YSort/Sail_Left".visible = false
		$"Ship YSort/Lower Deck/YSort/Sail_Up".visible = true
		sail_is_up = true
	else:
		$"Ship YSort/Lower Deck/YSort/Sail_Up".visible = false
#		$"Ship YSort/Lower Hull/YSort/Sail_Right".visible = false
#		$"Ship YSort/Lower Deck/YSort/Sail_Left".visible = false
		$"Ship YSort/Lower Deck/YSort/Sail_Center".visible = true
		sail_is_up = false
func _on_Anchor_pressed():
	if docked:
		ask_to_set_sail()
func _on_Button_set_sail():
	if docked:
		ask_to_set_sail()
func ask_to_set_sail():
	$Dialogue.DialogueResource = load("res://resources/dialogue/setSail.tres")
	var vstack = DialogueVStacker.new($Dialogue)
	add_child(vstack)
	vstack.position = dialogue_position
	$Dialogue.start_dialogue()
func _on_Dialogue_Event(event:String, modifiers):
	if event.findn("sail") >= 0:
		call_deferred("set_sail")
func set_sail():
	var ship_ysort = $"/root/Node/Node2D/World YSort/Ship YSort"
	ship_ysort.get_parent().remove_child(ship_ysort)
	ship_ysort.position = Vector2(0,0)
	add_child(ship_ysort)
		
#	var miniboat = load("res://scenes/MiniBoat.tscn").instance()
	var nodes_to_transfer := {
		"ship_enviroment": self,
		"miniship_position": miniboat_position
	}
	self.get_parent().remove_child(self)
	Global.goto_scene(next_scene_path)

	
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



#func _process(delta):
#	if Input.is_action_just_released("space"):
#		print(position, global_position)







