extends Node2D



var coin
export (bool) var testing = false

#var rng = RandomNumberGenerator.new()
var ITEMS = [	
	
	"starfish_blue",
	"starfish_orange",
	"seashell_pink",
	"coconut"
]
var items_done := [false,false,false,false]
func _ready():
	coin = load("res://scenes/Pinball/coin.tscn")
	#ready pinball boxes and bet boxes
	var box_count = [0,0,0,0]
	for child in $Boxes.get_children():
		var i = Global.rng.randi_range(0,3)
		box_count[i] += 1
		child.set_item( GDInv_ItemDB.get_item_by_id(ITEMS[i] ) ) 
		child.connect("coin_landed", self, "box_activated")
	$"Betting Panel".ready_boxes(box_count)

	if testing:
		$Camera2D.current = testing
#		$Timer.start()
func start():
	#spawn items - run func in Betting_Board
	$"Betting Panel".spawn_items()
	#launch items one by one
	
	#give rewards after all items land
	

func box_activated(item:GDInv_ItemDefinition, x_coin):
	var i = ITEMS.find(x_coin.item)
	if i >=0:
		items_done[i] = true
		check_finish_pinball()
	if item.identifier == x_coin.item:
		i = ITEMS.find(item.identifier)
		earn_coins($"Betting Panel".bets[i] * $"Betting Panel".rewards[i])
		print("earned: ",$"Betting Panel".bets[i] * $"Betting Panel".rewards[i])
	elif x_coin.item == "":
		earn_coins(1,false)

func earn_coins(i, add_coin = true):
	if add_coin:
		GameData.add_coins(i)
	for _j in range(i):
		var nc = coin.instance()
		nc.position = $"Betting Panel".position - Vector2(20,0)
		add_child(nc)
		yield(get_tree().create_timer(.2), "timeout")
func fire_cannon(new_coin = null):
	$Cannon/AnimationPlayer.play("Fire")
	if new_coin == null:
		new_coin = coin.instance()
	yield(get_tree().create_timer(2.1), "timeout")
	new_coin.position = $Cannon.position
	new_coin.linear_velocity = Vector2(0,-185+Global.rng.randf_range(-10,10))
	new_coin.angular_velocity = Global.rng.randf_range(-10,10)
	add_child(new_coin)

func check_finish_pinball():
	if !items_done.has(false):
		yield(get_tree().create_timer(4),"timeout")
		#play animation
		Global.goto_scene("res://scenes/OceanIsometric.tscn")
		

#func _on_Cannon_input_event(viewport, event, shape_idx):
#	if event is InputEventMouseButton and event.pressed:
#		if $Cannon/AnimationPlayer.is_playing():
#			return
#		start()
#		_on_Cannon_mouse_exited()
#func _on_Cannon_mouse_entered():
#	if $Cannon/AnimationPlayer.is_playing():
#			return
#	$Cannon/Sprite3.visible = true
#	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
#func _on_Cannon_mouse_exited():
#	$Cannon/Sprite3.visible = false
#	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
func _on_Timer_timeout():
	fire_cannon()


func _on_Cannon_Area2D_body_entered(body):
	if body.is_in_group("coin"):
		body.get_parent().remove_child(body)
		fire_cannon(body)
