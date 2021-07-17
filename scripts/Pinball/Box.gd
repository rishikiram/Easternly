extends StaticBody2D

var count:= 0
var item:GDInv_ItemDefinition
signal coin_landed
export (String) var item_manual := ""
export (bool) var delete_coins := true
func _ready():
	if item_manual != "":
		set_item(GDInv_ItemDB.get_item_by_id(item_manual))
func set_item(i: GDInv_ItemDefinition):
	item = i
	var texture_path = "res://art/item sprites/%s.png" % item.identifier
	$Sprite2/item.texture = load(texture_path)

func _on_Area2D_body_entered(body):
	if not body.is_in_group("coin") or body.clicked:
		return
	$AnimationPlayer.play("blink")
	emit_signal("coin_landed", item, body)
	if delete_coins:
		body.queue_free()
#	else:
#		body.input_pickable = false
	
	count += 1
	$"Sprite2/Node2D/RichTextLabel2".text = str(count)
