extends Node2D

export (bool) var testing := true
export(NodePath) var coin_parent = "."
var coin = preload("res://scenes/Pinball/coin.tscn")


func _ready():
	$Camera2D.current = testing

var bets = [0,0,0,0]
var rewards = [1,1,1,1]

func ready_boxes(box_count:Array):
	for i in range(box_count.size()):
		if box_count[i] == 0:
			rewards[i] = 100
		else:
			rewards[i] = 6.0/float(box_count[i])
	$Labels/Label/RichTextLabel.text = str(bets[0])+"$\nx"+str(rewards[0])
	$Labels/Label2/RichTextLabel.text = str(bets[1])+"$\nx"+str(rewards[1])
	$Labels/Label3/RichTextLabel.text = str(bets[2])+"$\nx"+str(rewards[2])
	$Labels/Label4/RichTextLabel.text = str(bets[3])+"$\nx"+str(rewards[3])
	
	
func spawn_items():
	for box in $Boxes.get_children():
		box.get_node("Area2D").monitoring = false
		var new_coin = coin.instance()
		new_coin.get_node("Sprite").texture = box.get_node("Sprite2/item").texture #load("res://art/item sprites/" + box.item_manual + ".png")
		get_node(coin_parent).add_child(new_coin)
		new_coin.global_position = box.global_position
		new_coin.item = box.item_manual
		new_coin.input_pickable = false
	#stop coin spawning?
func _on_Box_coin_landed(item, coin):
	bets[0] = bets[0]+1
	$Labels/Label/RichTextLabel.text = str(bets[0])+"$\nx"+str(rewards[0])
	GameData.remove_coins(1)
func _on_Box2_coin_landed(item, coin):
	bets[1] = bets[1]+1
	$Labels/Label2/RichTextLabel.text = str(bets[1])+"$\nx"+str(rewards[1])
	GameData.remove_coins(1)
func _on_Box3_coin_landed(item,coin ):
	bets[2] = bets[2]+1
	$Labels/Label3/RichTextLabel.text = str(bets[2])+"$\nx"+str(rewards[2])
	GameData.remove_coins(1)
func _on_Box4_coin_landed(item,coin):
	bets[3] = bets[3]+1
	$Labels/Label4/RichTextLabel.text = str(bets[3])+"$\nx"+str(rewards[3])
	GameData.remove_coins(1)
func _on_TextureButton_button_down():
	var new_coin = coin.instance()
	get_node(coin_parent).add_child(new_coin)
	new_coin.mode = RigidBody2D.MODE_KINEMATIC
	new_coin.set_physics_process(true)
	new_coin.clicked = true
	new_coin.input_pickable = true


func _on_Switch_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		
		$Switch.input_pickable = false
		
		var tween = $Tween
		tween.interpolate_property($Switch/Lever, "rotation",
		0, -PI/2, 1,
		Tween.TRANS_ELASTIC, Tween.EASE_OUT)
		tween.start()
		yield(tween,"tween_all_completed")
		spawn_items()


func _on_Switch_mouse_entered():
	$"Switch/Lever".frame = 1
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)


func _on_Switch_mouse_exited():
	$"Switch/Lever".frame = 0
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
