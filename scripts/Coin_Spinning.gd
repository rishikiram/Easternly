extends RigidBody2D

func _process(delta):
	$Sprite.position.y = sin($Timer.time_left/$Timer.wait_time*2*PI)*5
	
