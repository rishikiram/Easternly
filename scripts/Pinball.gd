extends Node2D



var coin
export (bool) var testing = false
#var rng = RandomNumberGenerator.new()

func _ready():
	coin = preload("res://scenes/Pinball/coin.tscn")
	for child in $Boxes.get_children():
		child.set_item(GDInv_ItemDB.get_random_item())
		child.connect("coin_landed", self, "box_activated")
	
	if testing:
		$Camera2D.current = testing
		$Timer.start()
		



func box_activated(item):
	#if item == bet
	InventoryData.add_coins(1)
	
func fire_cannon():
	InventoryData.remove_coins(1)
	$Cannon/AnimationPlayer.play("Fire")
	var coin = load("res://scenes/Pinball/coin.tscn").instance()
	yield(get_tree().create_timer(2.1), "timeout")
	add_child(coin)
	coin.position = $Cannon.position
	coin.linear_velocity = Vector2(0,-185+Global.rng.randf_range(-10,10))
	coin.angular_velocity = Global.rng.randf_range(-10,10)

func _on_Cannon_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		if $Cannon/AnimationPlayer.is_playing():
			return
		fire_cannon()
		_on_Cannon_mouse_exited()
func _on_Cannon_mouse_entered():
	if $Cannon/AnimationPlayer.is_playing():
			return
	$Cannon/Sprite3.visible = true
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
func _on_Cannon_mouse_exited():
	$Cannon/Sprite3.visible = false
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
func _on_Timer_timeout():
	fire_cannon()
