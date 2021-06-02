extends TextureRect

var i = 0
#var rotation = get_parent.rotation
#var texture 
onready var is_tilted = get_parent().is_tilted

var frame1 = preload("res://art/WindAreaAnimation/Wind2Area1.png")
var frame2 = preload("res://art/WindAreaAnimation/Wind2Area2.png")
var frame3 = preload("res://art/WindAreaAnimation/Wind2Area3.png")
var frame4 = preload("res://art/WindAreaAnimation/Wind2Area4.png")
var frame5 = preload("res://art/WindAreaAnimation/Wind2Area5.png")
var frame6 = preload("res://art/WindAreaAnimation/Wind2Area6.png")
var frame7 = preload("res://art/WindAreaAnimation/Wind2Area7.png")
var frame8 = preload("res://art/WindAreaAnimation/Wind2Area8.png")
var frames = [frame1,frame2,frame3,frame4,frame5,frame6,frame7,frame8]

var frame21 = preload("res://art/WindAreaAnimation/WindArea1.png")
var frame22 = preload("res://art/WindAreaAnimation/WindArea2.png")
var frame23 = preload("res://art/WindAreaAnimation/WindArea3.png")
var frame24 = preload("res://art/WindAreaAnimation/WindArea4.png")
var frame25 = preload("res://art/WindAreaAnimation/WindArea5.png")
var frame26 = preload("res://art/WindAreaAnimation/WindArea6.png")
var frame27 = preload("res://art/WindAreaAnimation/WindArea7.png")
var frame28 = preload("res://art/WindAreaAnimation/WindArea8.png")
var frames2 = [frame21,frame22,frame23,frame24,frame25,frame26,frame27,frame28]


func _draw():
	#rect_scale.x = -1
	#rect_rotation = 90
	
	draw_texture(texture, Vector2())
	
func _on_Timer_timeout():
	i = (i+1) % 8
	if is_tilted:
		texture = frames[i]
	else:
		texture = frames2[i]
	update()
