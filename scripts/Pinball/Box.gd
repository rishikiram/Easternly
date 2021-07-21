extends StaticBody2D

var count:= 0

enum ITEM  {blue, orange, pink, coconut}
var item_sprites = [
	preload("res://art/item sprites/starfish_blue.png"),
	preload("res://art/item sprites/starfish_orange.png"),
	preload("res://art/item sprites/seashell_pink.png"),
	preload("res://art/item sprites/coconut.png")
]
var item = ITEM.coconut
signal coin_landed
export (int) var item_manual = 0
export (bool) var delete_coins := true

func _ready():
	set_item(item_manual)
func set_item(i: int):
	item = i
	$Sprite2/item.texture = item_sprites[item]

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
