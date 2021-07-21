extends Sprite

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
#func _init():
#	var item: GDInv_ItemDefinition = get_parent().item
#	var texture_path = "res://art/item sprites/%s.png" % item.identifier
#	texture = load(texture_path)

# Called when the node enters the scene tree for the first time.
func _ready():
	if get_parent().item != null:
		set_item_texture()
	
	
func set_item_texture():
	var item: GDInv_ItemDefinition = get_parent().item
	var texture_path = "res://art/item sprites/%s.png" % item.identifier
	texture = load(texture_path)
