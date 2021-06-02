extends Sprite

var ar_B:Array
var ar_A:Array
func _process(delta):
	global_position = get_viewport().get_mouse_position()
	ar_B = $Area2D.get_overlapping_bodies()
	for b in ar_B:
		if b.is_in_group("Clickable"):
			Input.MOUSE_MODE_HIDDEN
			visible = true
			return
	ar_A = $Area2D.get_overlapping_areas()
	for a in ar_A:
		if a.is_in_group("Clickable"):
			Input.MOUSE_MODE_HIDDEN
			visible = true
			return
#	visible = false
			
