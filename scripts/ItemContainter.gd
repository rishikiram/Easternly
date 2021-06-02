extends StaticBody2D

#onready var inventory = $GDInv_Inventory
var inventory:=[]

export(String) var item_spawn_parent:String = ".."
export(int) var box_type = 0
var animation:= "wood"

var player_in_range:= false
func _ready():
	if box_type == 1:
		animation = "silver"
	$AnimatedSprite.play(animation)
	$AnimatedSprite.frame = 5
	
	
	$ItemDetecter.collision_layer = collision_layer
	$ItemDetecter.collision_mask = collision_mask
	
#	$GDInv_Inventory.add_item_by_id("starfish_orange", 1)
#	$GDInv_Inventory.add_item_by_id("starfish_blue", 1)
#	$GDInv_Inventory.add_item_by_id("seashell_pink", 3)
#	$GDInv_Inventory.add_item_by_id("coconut", 2)
#	print("added coconuts and pink seashells and starfish")


#func add_stack(item_stack: GDInv_ItemStack) -> bool:
#	var added :bool = inventory.add_stack(item_stack)
#	return added
func add_item(item: GDInv_ItemDefinition) -> bool:
#	var added :bool = inventory.add_item(item, 1)
	inventory.append(item)
	return true
	
#spawns last item in inv, (last put it, first out)	
func spawn_top_item():
	if inventory.size() > 0:
		spawn_item(inventory[inventory.size()-1])
		inventory.remove(inventory.size()-1)
		return
	shake()
#	var item_stack : GDInv_ItemStack = $GDInv_Inventory.take_last_item()
#	#if theres no item- ?play animation shake?
#	if item_stack == null:
#		shake()
#		return
#	spawn_stack(item_stack)
	
#spawns first item in inv, (first put it, last out)
func spawn_bottom_item():
	if inventory[0] != null:
		spawn_item(inventory[0])
		return
	shake()
#	var item_stack : GDInv_ItemStack = $GDInv_Inventory.take_first_item(0)
#	#if theres no item- ?play animation shake?
#	if item_stack == null:
#		return
#	spawn_stack(item_stack)

#create item child and add it to const parent 
#func spawn_stack(stack: GDInv_ItemStack):
#	#### spawn item scene 
#	$AnimatedSprite.frame = 0
#	$AnimatedSprite.play(animation)
#	yield($AnimatedSprite, "frame_changed")# 2nd frame 
#	yield($AnimatedSprite, "frame_changed")# 3rd frame 
#	yield($AnimatedSprite, "frame_changed")# 4th frame
#	for _i in range(0, stack.stackSize):
#		var new_item  = preload("res://scenes/Item.tscn").instance()
#		new_item.init( stack.item )
#		get_parent().add_child(new_item)
#		#set collision layers
#		new_item.collision_layer = collision_layer
#		new_item.collision_mask = collision_mask
#		#spawn above container
#		new_item.position = position + Vector2(0, -12*scale.y)
#		#spawn moving in random direction from -pi/6 to 7pi/6  -1<x<1    ~2/3PI range  midpoint
#		new_item.linear_velocity = Vector2( (50 + randf()*25) *global_scale.x ,0).rotated( (randf()-0.5)*2 *(PI*.6) - PI/2)
func spawn_item(item: GDInv_ItemDefinition):
	#### spawn item scene 
	$AnimatedSprite.frame = 0
	$AnimatedSprite.play(animation)
	yield($AnimatedSprite, "frame_changed")# 2nd frame 
	yield($AnimatedSprite, "frame_changed")# 3rd frame 
	yield($AnimatedSprite, "frame_changed")# 4th frame
	var new_item  = preload("res://scenes/Item.tscn").instance()
	new_item.init( item )
	get_parent().add_child(new_item)
	#set collision layers
	new_item.collision_layer = collision_layer
	new_item.collision_mask = collision_mask
	#spawn above container
	new_item.position = position + Vector2(0, -12*scale.y)
	#spawn moving in random direction from -pi/6 to 7pi/6  -1<x<1    ~2/3PI range  midpoint
	new_item.linear_velocity = Vector2( (50 + randf()*25) *global_scale.x ,0).rotated( (randf()-0.5)*2 *(PI*.6) - PI/2)
func remove_item_by_id(id:String):
	for i in range (0,inventory.size()):
		if inventory[i].identifier == id:
			inventory.remove(i)
			return true
	return false
func shake():
	print("contaier is empty")
func set_all_collision_layers(b:int):
	var l = pow(2,b)
	collision_layer = l
	collision_mask = l
	$ItemDetecter.collision_layer = l
	$ItemDetecter.collision_mask = l
	
func _on_ItemDetecter_body_entered(body):
	if body is Item:#and time is out
		add_item(body.item)
		if body.get_parent().is_in_group("Player"):
			body.get_parent().is_holding_item = false
		body.queue_free()
		
		
func _on_ItemContainer_input_event(_viewport, event, _shape_idx):
#	print('signaled')
	if (event is InputEventMouseButton && event.pressed):
#		print(self, 'clicked')
		if player_in_range:
			spawn_top_item()
			#might be unecceseary
			#get_tree().set_input_as_handled()
func _on_ItemContainer_mouse_entered():
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
func _on_ItemContainer_mouse_exited():
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
func get_item_id_list():
	var list = []
	for item in inventory:
		list.append(item.identifier)
	return list
func set_items(ar:Array):
	for item_id in ar:
		add_item(GDInv_ItemDB.get_item_by_id(item_id))
		
