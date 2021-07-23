extends Area2D

var distance := 100.0
var current_distance = distance
var ground_speed := distance/.6 #2 seconds d/t
var direction := Vector2(1,0)
var height := 32

var idle := true

func _process(delta):
	if idle:
		$Sprite.position.y = -3 + sin($Timer.time_left/$Timer.wait_time*2*PI)*5
		return
	var displacment = direction*delta*ground_speed
	current_distance -= displacment.length()
	position += Vector2(displacment.x, displacment.y/2)
	$Sprite.position.y = current_distance*(current_distance-distance)/(pow(distance/2,2))*height
	if current_distance < 0:
		queue_free()
	
	

func _on_Coin_Spinning_body_entered(body):
	if body.is_in_group("miniship"):
		GameData.add_coins(1);
		queue_free()
