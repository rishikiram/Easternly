extends Area2D


export(String) var next_scene_path: String
#export (String) var next_scene_parent_path:String
#export (Vector2) var next_scene_global_position:Vector2

var ship_in_range = false
#var ship_started_inside = false
var the_ship

func dock_ship(ship):
#	var shipEnvo = $"/root/Node/CanvasLayer/Ship Enviroment"
##	$"/root/Node/CanvasLayer/Ship Enviroment".scale = Vector2(1,1)
##	shipEnvo.miniboat_position = $"/root/Node/Beach Scene/YSort/MiniBoat".global_position
#	var scene_state := {
#		"ship_enviroment": $"/root/Node/CanvasLayer/Ship Enviroment"
#	}
#	$"/root/Node/CanvasLayer/Ship Enviroment Container".remove_child($"/root/Node/CanvasLayer/Ship Enviroment")
	var ship_id = $"/root/Node/CanvasLayer/Ship Enviroment Container".get_child(0).ship_id
	GameData.set_ship_location(ship_id, next_scene_path)
	PlayerVariables.player_state = 0
	Global.goto_scene(next_scene_path)
#	Global.goto_scene(next_scene_path, [[$"/root/Node/CanvasLayer/Ship Enviroment", next_scene_parent_path, next_scene_global_position]])

func _on_Docking_Area_body_entered(body):
	if body.is_in_group("miniship"):
		the_ship = body
		ship_in_range = true
func _on_Docking_Area_body_exited(body):
	if body.is_in_group("miniship"):
		the_ship = null
		ship_in_range = false
func _on_Docking_Area_input_event(viewport, event, shape_idx):
	if ship_in_range:
		if event is InputEventMouseButton and event.pressed:
			dock_ship(the_ship)
			
