extends Control



#var x = 1
#func _process(delta):
#	if Input.is_action_just_pressed("lmb"):
#		var s = "cococococo nuts" + str(x)
#		x+=1
#		add_bubble(s)
#var dialogue_list:Array

func _on_initiate_dialog(body):# (body, file_path):
	var new_dialogue :DialogueVStacker = DialogueVStacker.new(body.get_node("Dialogue"))
	add_child(new_dialogue)
	
	var y_offset: Vector2 = Vector2(0,40)
	new_dialogue.rect_global_position = body.global_position - y_offset
	
	body.get_node("Dialogue").connect_all_signals_to(new_dialogue)

func add_bubble(text):
	var new_bubble = load("res://scenes/GUI/DialogBubble.tscn").instance()
	$VStacker.add_child(new_bubble)
	new_bubble.set_and_fit_text(text)
	$VStacker.stack()
	
func add_button(text, id):
	var new_button = load("res://scenes/GUI/QuestionBubble.tscn").instance()
	$VStacker.add_child(new_button)
	new_button.set_and_fit_text(text)
	new_button.get_node("TextureButton").connect("button_down", self, "_on_choice_pressed", id)
	$VStacker.stack()
	
func _on_choice_pressed(id):
#	$Dialogue.next_dialogue(id)
	pass
	
func _on_Dialogue_Dialogue_Next(ref, actor, text):
	add_bubble(text)
	
	
func _on_Dialogue_Choice_Next(ref, choices):
	for i in range(0, choices.size()):
		add_button(choices[i].Dialogue, i)


func _on_Dialogue_Conditonal_Data_Needed():
	pass # Replace with function body.


func _on_Dialogue_Dialogue_Started():
	pass # Replace with function body.


func _on_Dialogue_Dialogue_Ended():
	pass # Replace with function body.
