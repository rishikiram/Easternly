extends Label

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _process(delta):
	#text = str(get_tree().get_root().get_node("WindScene").get_node('Player').speed)
	text = "Speed = " + str( get_tree().get_root().get_node("Node").get_node("WindScene").get_node('Player').speed )
	
