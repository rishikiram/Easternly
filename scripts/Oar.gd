extends Sprite

export (float) var start_angle = 3*PI/2
export (float) var center_angle = PI/2

export (float) var oar_speed = 20
export (bool) var is_right_side = true

var speed = 4
var is_rowing = false
var t = 0
	
func row():
	is_rowing = true
func _physics_process(delta):
	####for testing####
	#f Input.is_action_pressed('click'):
		#t += delta
		
	#Idea... animate oar going into water and switch frames when angle equals some number
	###update oar rotation#####
	if is_rowing:
		###row forward speed####
		if t < PI:
			t += delta*2.2
		#####row back code-depends on boat speed#####
		else:
			get_parent().is_rowing = true
			speed = get_parent().speed
			if speed == 0:
				t += delta
			else:
				t += delta*speed/oar_speed + delta
		# move oars#
		if is_right_side:
			rotation = center_angle - PI / 4 * sin(t+start_angle)
		else: 
			rotation = -center_angle + PI / 4 * sin(t+start_angle)
	#####stop after one row#####
	if t >= 2*PI:
		t=0
		is_rowing = false
		get_parent().is_rowing = false
	#speed = get_parent().speed/1000
	


