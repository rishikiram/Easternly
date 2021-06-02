extends MarginContainer

export (bool) var is_tilted = true
enum DIRECTION {N,E,S,W,NE, SE, SW, NW}
export(DIRECTION) var direction = DIRECTION.NE
func _ready():
	rect_scale = Vector2(5,5)
	rect_size = Vector2(210,210)
	rect_pivot_offset = rect_size/2
	rect_rotation = (direction%4) * 90
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
