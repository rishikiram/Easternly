extends "res://scripts/Classes/Island_class.gd"

func _ready():
	if GameData.current_route != {}:
		GameData.end_route()
#func load_scene():
#	print("skip load scene")
#func _process(delta):
#	if get_tree().get_nodes_in_group("Player").size() > 0:
#		player_velocity = get_tree().get_nodes_in_group("Player")[0].velocity
