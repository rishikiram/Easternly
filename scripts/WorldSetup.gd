#extends Node2D
#
#func _ready():
#	yield(Global, "scene_loaded")
#	#initialize Ship Envrioment(moved node)
#	$"Ship Enviroment".scale = Vector2(1,1)
#	$"Ship Enviroment".set_docked(true)
#	var ship_ysort = $"Ship Enviroment/Ship YSort"
#	var gp = ship_ysort.global_position
#	$"Ship Enviroment".remove_child(ship_ysort)
#	$"World YSort".add_child(ship_ysort)
#	ship_ysort.global_position = gp
#	#add camera2D to plyaer
#	var player_cam = Camera2D.new()
#	Global.find_player($"/root/Node").add_child(player_cam)
#	player_cam.make_current()
