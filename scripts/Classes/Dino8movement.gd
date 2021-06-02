extends KinematicBody2D

export (int) var speed := 60#was 45, if chagne, you also need ot change it in _ready

var velocity := Vector2();
var horizontal_movment_angle := 0;
var is_holding_item := false

#var inventory_grid 
#export(int) var inventory_size := 6
#var itemlist := []
export(Vector2) var held_item_position:= Vector2(6,-3)
#onready var Animation_Player = $Sprite.get_node("AnimationPlayer")

signal mouse_released


func _enter_tree():
	PlayerVariables.connect("item_clicked", self, "_on_item_clicked")
	PlayerVariables.connect("backpack_item_removed", self, "_on_backpack_item_removed")
func _ready():
#	PlayerVariables.player = self
	
#	if PlayerVariables.get_signal_connection_list("item_clicked").size() <= 0:
#		PlayerVariables.connect("item_clicked", self, "_on_item_clicked")
#	if PlayerVariables.get_signal_connection_list("backpack_item_removed").size() <= 0:
#		PlayerVariables.connect("backpack_item_removed", self, "_on_backpack_item_removed")
#	connected = c && d
	
	
#	if $"/root/Node/CanvasLayer/HUD" != null:
#		inventory_grid = $"/root/Node/CanvasLayer/HUD".get_player_inventory()
#	else:
#		inventory_grid = load("res://scenes/GUI/InverntoryGrid.tscn").instance()
#		add_child(inventory_grid)
#		inventory_grid.rect_position = Vector2(9,-48)
#		inventory_grid.rect_scale = Vector2(0.25,0.25)
#	inventory_grid.connect("removed_item", self, "_on_InventoryGrid_removed_item")
#	inventory_grid.visible = false
#	inventory_grid.resize(inventory_size)
#	PlayerVariables.player_inventory.resize(inventory_size)
#	PlayerVariables.emit_signal("update_HUD")
	speed = 60 * global_scale.x
func get_input():
	#move
	if Input.is_action_pressed('d'):
		velocity += Vector2(1,0).rotated(deg2rad(horizontal_movment_angle))
	if Input.is_action_pressed('a'):
		velocity -= Vector2(1,0).rotated(deg2rad(horizontal_movment_angle))
	if Input.is_action_pressed('s'):
		velocity.y += 1
	if Input.is_action_pressed('w'):
		velocity.y -= 1
	velocity = velocity.normalized() * speed

func pickup_item(item):
	item.scale = Vector2(1/item.global_item_scale.x,1/item.global_item_scale.y)
	item.collision_layer = collision_layer
	item.collision_mask = collision_mask
	item.add_collision_exception_with(self)
	call_deferred('make_item_child', item)
func make_item_child (item):
	item.mode = RigidBody2D.MODE_KINEMATIC
	if item.get_parent() != null:
		item.get_parent().remove_child(item) 
	self.add_child(item)
	item.name = 'Item'#makses name item because code refers to its item as $Item
	$Item.set_position( Vector2(held_item_position.x*$Sprite.scale.x/abs($Sprite.scale.x),held_item_position.y) )#goes way playuer is facing
#	$Item.scale = Vector2(1,1)
	is_holding_item = true
func throw_item() -> void:
	var item = $Item
	#start time and tween
	$Timer.start()
	var tween = item.get_node('Tween')
	tween.interpolate_property(item.get_node('Sprite'), "modulate",
		Color(1,1,1,1), Color(1,0,0,1), $Timer.wait_time,
		Tween.TRANS_LINEAR, Tween.EASE_OUT_IN)
	tween.start()
	#wait for mouse release
	yield(self, "mouse_released")
	if is_holding_item == false:#incase item is stored while charging
		return
	#stop timer and tween
	var time_left:float = $Timer.get_time_left()
	$Timer.stop()
	item.get_node('Tween').stop(item.get_node('Tween'))
	item.get_node('Sprite').modulate = Color(1,1,1,1)
	#set impulse
	var throw_impulse = (100 + 200*($Timer.wait_time - time_left)/$Timer.wait_time)*global_scale.x
	var angle_to_mouse = item.get_angle_to(get_global_mouse_position()) +item.rotation
	var item_global_position = item.global_position
	#reparent
	self.remove_child(item)
	get_parent().add_child(item)
	#reset item
	item.mode = RigidBody2D.MODE_RIGID
#	item.set_collision_mask_bit(0, true)
	item.ignore_player_for_moment(self)#player can throw accross body and down
	item.global_position = item_global_position
	#throw
	item.apply_impulse( Vector2(), Vector2(throw_impulse,0).rotated(angle_to_mouse) )
	#randomize spin direction
	var omega: =1
	if randf() > .5:
		omega = -1 #spin faster with charge
	item.angular_velocity = omega *(10+10*($Timer.wait_time - time_left)/$Timer.wait_time)
	
	is_holding_item = false
	
func store_held_item():#!!
#	var added = inventory_grid.add_item($Item.item)
	var added = PlayerVariables.store_item($Item.item)
	if added:
#		$GDInv_Inventory.add_item($Item.item)
		$Item.queue_free()
		is_holding_item = false
# warning-ignore:unused_argument
var velocity_last_frame:Vector2
func _physics_process(delta):
	#check to pick up item
	if PlayerVariables.clicked_item != null:
		if !is_holding_item:
			pickup_item(PlayerVariables.clicked_item)
			PlayerVariables.clicked_item = null
		else:
			PlayerVariables.clicked_item = null
			print('cant pick up')#play some animation
	
	#reset velocity if right playerstate
	velocity = Vector2(0,0)
#	print(PlayerVariables.player_state)
	if PlayerVariables.player_state == 0:
		get_input()
	$Sprite.handle_state(velocity)
#	if velocity ==  Vector2(0,0):
#		Animation_Player.play('Idle')
#	else:
#		Animation_Player.play('Walk')
#	if velocity.x < 0 and $Sprite.scale[0] > 0:
#		flip()
#	if velocity.x > 0 and $Sprite.scale[0] < 0:
#		flip()
	velocity_last_frame = move_and_slide(velocity)
func _unhandled_input(event):
	if is_holding_item:
		if event.is_action_pressed("e"):
			store_held_item()
		if event.is_action_pressed("lmb"):
			throw_item()
	if event.is_action_released("lmb"):
		emit_signal("mouse_released")
	
func set_all_collision_layers(b:int):
	var l = pow(2,b)
#	set_collision_layer_bit(b, true)
#	set_collision_mask_bit(b, true)
	collision_layer = l
	collision_mask = l
#	$PlayerArea.set_collision_layer_bit(b, true)
#	$PlayerArea.set_collision_mask_bit(b, true)
	$PlayerArea.collision_layer = l
	$PlayerArea.collision_mask = l
	if is_holding_item:
		$Item.set_all_collision_layers(b)
#func flip():
#	$Sprite.scale[0] = $Sprite.scale[0] * -1
#	if is_holding_item:
#		$Item.position.x = -1*$Item.position.x
		
#func _on_InventoryGrid_removed_item(item):#!!
func _on_backpack_item_removed(item):
#	$GDInv_Inventory.remove_item(item)#####!!!
	if is_holding_item:
		var new_item  = preload("res://scenes/Item.tscn").instance()
		new_item.init( item )
		new_item.add_collision_exception_with(self)
		new_item.add_collision_exception_with($Item)
		#spawn at player
#		print($Sprite.global_scale.x, $Sprite.scale.x/abs($Sprite.scale.x))
		new_item.position = position + Vector2(8*global_scale.x * $Sprite.scale.x/abs($Sprite.scale.x) , -3) 
		get_parent().add_child(new_item)
		#set collision layers
		new_item.collision_layer = collision_layer
		new_item.collision_mask = collision_mask
		#spawn moving in random direction from -pi/6 to 7pi/6  -1<x<1    ~2/3PI range  midpoint
		#new_item.linear_velocity = Vector2( (50 + randf()*25) *global_scale.x ,0).rotated(randf()*2*PI)
		new_item.ignore_player_for_moment(self)
		new_item.ignore_player_for_moment($Item)
	else:
		var new_item  = preload("res://scenes/Item.tscn").instance()
		new_item.init( item )
		pickup_item(new_item)
func _on_PlayerArea_body_entered(body):
	if body.is_in_group("Clickable"):
		body.set_process(true)
		body.player_in_range = true #will respond to click
func _on_PlayerArea_body_exited(body):
	if body.is_in_group("Clickable"):
		body.player_in_range = false#will not respond to click

