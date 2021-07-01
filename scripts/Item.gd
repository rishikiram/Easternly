extends RigidBody2D
class_name Item

var item: GDInv_ItemDefinition = null;
var player_in_range:= false setget set_PIR

export(String) var item_id := "set item manually"
export(Vector2) var global_item_scale := Vector2(2,2)

#can't take arguments becasue its a scene
#func _init(item_def = null) -> void:
#	if (item_def != null):
#		item = item_def
		
func init(item_def):
	item = item_def
	
func _ready():
	#connect("input_event", self, "_on_Item_input_event")
	if item == null:
		item = GDInv_ItemDB.get_item_by_id("coconut")
	if item_id != "set item manually":
		item = GDInv_ItemDB.get_item_by_id(item_id)
	
	var texture_path = "res://art/item sprites/%s.png" % item.identifier
	$Sprite.texture = load(texture_path)
	
	linear_damp = 2
	
	#global.item_scale
	$Sprite.scale = global_item_scale#should be global scale
	$CollisionShape2D.scale = global_item_scale
func set_PIR(b):
	if b:
		player_in_range = b
		contact_monitor = true
		contacts_reported = 1
	else:
		player_in_range = b
		contact_monitor = false
		contacts_reported = 0

func _on_Item_input_event(_viewport, event, _shape_idx):
	if (event is InputEventMouseButton && event.pressed):
		if player_in_range:
			PlayerVariables.clicked_item = self
#func turn_off_collision_for():
func ignore_player_for_moment(player, t := 0.3):
	$Timer.wait_time = t
	$Timer.start()
	yield($Timer, "timeout")
	remove_collision_exception_with(player)
func set_all_collision_layers(b:int):
	var l = pow(2,b)
	collision_layer = l
	collision_mask = l
func _on_Item_mouse_entered():
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
func _on_Item_mouse_exited():
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
func _on_Item_body_entered(body):
	if body.is_in_group("Player") and !body.is_holding_item:# and get_colliding_bodies().has(body):
		body.pickup_item(self)
#func get_save_dictionary():
#	var save_dict := {
#			"identifier" : item.identifier,
#			"parent path" : get_parent().get_path(),
#			"position" : [position.x, position.y],
#			"collision layer" : int(log(collision_layer)/log(2))
#		}
#	return save_dict
