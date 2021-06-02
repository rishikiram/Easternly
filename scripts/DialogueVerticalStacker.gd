extends Node2D
class_name DialogueVStacker


var bubble_scene = preload("res://scenes/GUI/DialogBubble.tscn")
var button_scene = preload("res://scenes/GUI/QBv2.tscn")
var dialogue_node
var button_list:Array = []

#signal open_shop
#export(int) var maxBubbles = 3

func _init(dn):
	dialogue_node = dn
	dialogue_node.connect_all_signals_to(self)
func _ready():
	scale = Vector2(.5,.5)#rect_scale = Vector2(.5,.5) 
	z_index = 1
	stack()
	
func stack():
#	while get_child_count() > maxBubbles:
#		remove_child(get_child(0))
	
	var h:= Vector2(0,0)
	for i in range(get_child_count()-1,-1, -1 ):
		h = h - Vector2(0,get_child(i).rect_size.y)
		get_child(i).rect_position = h - get_child(i).rect_pivot_offset
#		var p  = get_child(i)
#		print(p)
func add_bubble(text, flip = false):
	var new_bubble = bubble_scene.instance()
	new_bubble.flipped = flip
	add_child(new_bubble)
	new_bubble.set_and_fit_text(text)
	stack()
	
func add_button(text, id):
	var new_button = button_scene.instance()
	add_child(new_button)
	button_list.append(new_button)
	
	new_button.set_and_fit_text(text)
	new_button.get_node("TextureButton").connect("button_down", self, "_on_choice_pressed", [id])
	stack()

func _on_choice_pressed(id):
	for b in range(button_list.size()-1, -1, -1):
		if b == id:
			add_bubble(button_list[b].get_text(), true)
		
		remove_child(button_list[b])
	
	dialogue_node.next_dialogue(id)
func _on_Dialogue_Dialogue_Next(_ref, _actor, text):
	add_bubble(text)
	
	
func _on_Dialogue_Choice_Next(_ref, choices):
	for i in range(0, choices.size()):
		add_button(choices[i].Dialogue, i)

func _on_Dialogue_Dialogue_Event(_event, _modifiers):
	pass

func _on_Dialogue_Conditonal_Data_Needed():
	pass # Replace with function body.


func _on_Dialogue_Dialogue_Started():
	pass # Replace with function body.


func _on_Dialogue_Dialogue_Ended():
	queue_free()
