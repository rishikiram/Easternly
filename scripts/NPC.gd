extends KinematicBody2D

var player_in_range:= false
var queued_dialogue
export(Vector2) var dialog_y_offset:= Vector2(0,-20)
export(Vector2) var coin_spawn_offset:= Vector2(0,30)
#export() var quest_container
const dialogue_folder := "res://resources/dialogue/"
#func open_shop():
#	sh

func _unhandled_key_input(event):
	if player_in_range && event.is_action_pressed("e"):
		if !$Dialogue.in_dialogue:
			initiate_dialog()
		else:
			$Dialogue.next_dialogue()
func initiate_dialog():
	var new_dialogue := DialogueVStacker.new($Dialogue)
	add_child(new_dialogue)
	new_dialogue.position = dialog_y_offset
#	$Dialogue.connect_all_signals_to(new_dialogue)
	$Dialogue.start_dialogue()
func _on_Dialogue_Event(event, modifiers):
	print("siganled, with this event:", event, modifiers)
	if event.findn("shop") > 0:
		$Shop.visible = true
	if event.findn("quest") > 0:
		$Shop.add_quest(modifiers[0])
	if event.findn("dialogue") > 0:
		queued_dialogue = load(dialogue_folder+modifiers[0]+".tres")
func _on_Dialogue_Ended():
	if queued_dialogue==null:
		return
	$Dialogue.DialogueResource = queued_dialogue
	queued_dialogue = null
	
		
func _on_NPCArea_body_entered(body):
	if body.is_in_group("Player") && !$Dialogue.in_dialogue:
			initiate_dialog()
func _on_NPCArea_body_exited(body):
	pass # Replace with function body.
func _on_NPCArea_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton && event.pressed:
		if !$Dialogue.in_dialogue:
			initiate_dialog()
		else:
			$Dialogue.next_dialogue()

func _on_QuestItemContainer_quest_completed(quest_id):
	var coin = load("res://scenes/Coin.tscn")
	var reward:int = QuestDB.REGISTRY[quest_id].reward
	for _i in range(0,reward):
		var c = coin.instance()
		get_parent().add_child(c)
		c.global_position = global_position + coin_spawn_offset

func _on_NPCArea_mouse_entered():
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
func _on_NPCArea_mouse_exited():
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)




