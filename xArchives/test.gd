extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("space"):
		print('torqued')
#		$Item.apply_impulse(Vector2(3,0), Vector2(0,100))
		$Item.angular_velocity = 10
#	pass
