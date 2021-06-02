extends Node


func _on_coveredArea_body_entered(body):
	if body.is_in_group('Player'):
		
		$Tween.interpolate_property(self, "modulate",
		Color(1,1,1,1), Color(1,1,1,0.4), .5,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$Tween.start()
		
		$Tween.interpolate_property($YSort, "modulate",
		Color(1,1,1,1), Color(1,1,1,0.4), .5,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$Tween.start()


func _on_coveredArea_body_exited(body):
	if body.is_in_group('Player'):
		$Tween.stop_all()
		$Tween.interpolate_property(self, "modulate",
		Color(1,1,1,0.4), Color(1,1,1,1), .2,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$Tween.start()
		
		$Tween.interpolate_property($YSort, "modulate",
		Color(1,1,1,0.4), Color(1,1,1,1), .2,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$Tween.start()

