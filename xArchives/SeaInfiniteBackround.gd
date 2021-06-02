extends Node2D

var player_path = get_parent().get_node('Player')
func _process(delta):
	var player_position = player_path.position

