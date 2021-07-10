extends StaticBody2D

var count:= 0
var item:GDInv_ItemDefinition
signal coin_landed
func set_item(i: GDInv_ItemDefinition):
	item = i
	var texture_path = "res://art/item sprites/%s.png" % item.identifier
	$Sprite2/item.texture = load(texture_path)

func _on_Area2D_body_entered(body):
	$AnimationPlayer.play("blink")
	emit_signal("coin_landed", item)
	body.queue_free()
	
	count += 1
	$"Sprite2/Node2D/RichTextLabel2".text = str(count)
