#extends Sprite
#
#
#func _physics_process(delta):
#	var velocity = get_parent().velocity
#	if velocity ==  Vector2(0,0):
#		Animation_Player.play('Idle')
#	else:
#		Animation_Player.play('Walk')
#	if velocity.x < 0 and $Sprite.scale[0] > 0:
#		flip()
#	if velocity.x > 0 and $Sprite.scale[0] < 0:
#		flip()
