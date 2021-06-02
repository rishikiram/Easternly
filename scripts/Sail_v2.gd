extends Sprite

#far left = -2, 
#left = -1, 
#center = 0, 
#right = 1, 
#far right = 2 
var angle
const center_frame = 1
const degree30_frame = 2
const degree60_frame = 3
const sailup_frame = 0

# I drew them going counterclockwise, 
# but in godot clockwise is positive rotation
func _ready():
	frame = 1
	angle = 0

func get_sail_direction():
	match angle:
		0:
			return Vector2(1,0)
		1:
			#return Vector2(1,0).rotated(PI/6) 
#			return Vector2(0.866025,0.5)
			return Vector2(1,0).rotated(PI/4)
		-1:
#			return Vector2(0.866025,-0.5)
			return Vector2(1,0).rotated(-PI/4)
		2:
			return Vector2(0.5, 0.866025)
		-2:
			return Vector2(0.5, -0.866025)
		_:
			return Vector2(0,0)
func sail_updown():
	match frame:
		sailup_frame:
			frame = center_frame
			angle = 0
		_:
			frame = sailup_frame
			angle = 10
func turn_sail(x) -> void:
	######positive is right, negative is left######
	
	#for the case when turn is called while sail is up
	#and angle is 10
	if angle == 10:
		angle = 0
		frame = center_frame
		return
		
	angle += x
#	angle = clamp(angle, -2, 2)
	angle = clamp(angle, -1, 1)
	if angle == 0:
		frame = center_frame
	elif angle == 1:
		frame = degree30_frame
		flip_r()
	elif angle == 2:
		frame = degree60_frame
		flip_r()
	elif angle == -1:
		frame = degree30_frame
		flip_l()
	elif angle == -2:
		frame = degree60_frame
		flip_l()
func flip_r():
	scale[0] = abs(scale[0]) * (-1)
func flip_l():
	scale[0] = abs(scale[0])
