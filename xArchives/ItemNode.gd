#extends RigidBody2D
#
#class_name Item
#
#var item: GDInv_ItemDefinition = null;
#
#export(String) var item_id := "set item manually"
#
#func _init(item_def = null) -> void:
#	if (item_def != null):
#		item = item_def
#
#func _ready():
#	connect("input_event", self, "_on_Item_input_event")
#
#
#
#	self.scale = get_parent().scale
#	#weight = 1
#
#	if item_id != "set item manually":
#		item = GDInv_ItemDB.get_item_by_id(item_id)
#
#	#for testing#
#	#linear_velocity = Vector2(100,100)
#	linear_damp = 1
#	#gravity_scale = 0
#
#
#	if !self.has_node("Sprite"): 
#		var sprite :Sprite = Sprite.new()
#		add_child(sprite)
#		var texture_path = "res://art/item sprites/%s.png" % item.identifier
#		sprite.texture = load(texture_path)
#		sprite.scale = scale
#
#	if !self.has_node("CollisionShape2D") || !self.has_node("CollisionPolygon2D") : 
#		var collisionbody: CollisionShape2D = CollisionShape2D.new()
#		add_child(collisionbody)
#		collisionbody.shape = CircleShape2D.new()
#		collisionbody.shape.radius = 4
#		collisionbody.scale = scale
	
