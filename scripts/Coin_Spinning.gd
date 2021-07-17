extends Area2D

func _process(delta):
	$Sprite.position.y = sin($Timer.time_left/$Timer.wait_time*2*PI)*5
	


func _on_Coin_Spinning_body_entered(body):
	if body.is_in_group("miniship"):
		InventoryData.add_coins(1);
		queue_free()
