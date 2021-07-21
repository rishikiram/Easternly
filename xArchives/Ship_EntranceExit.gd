extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
export(bool) var is_exit := true
func _ready():
#	connect("body_exited", self, "_on_Area2D_body_exited")
	connect("body_entered", self, "_on_Area2D_body_exited")

func _on_Area2D_body_exited(body):
	if is_exit:
		yield(get_tree(), "idle_frame")
		if body != null and (body.is_in_group("Player") or body.is_in_group("Carriable")):
			if not body.get_parent().is_in_group("Player"):
				var gp :Vector2 = body.global_position
				body.get_parent().remove_child(body)
				body.set_all_collision_layers(0)
#				print(body, 'changed collision layers to 0')
				var island = get_tree().get_nodes_in_group("Island")[0]
#				print(island.ship_enviroment_parent_path)
#				var par = get_node(island.ship_enviroment_parent_path)
				get_node(island.ship_enviroment_parent_path).add_child(body)
				print("parent changed to ", body.get_parent())
				body.global_position = gp


#		if body.is_in_group("Player") || body.is_in_group("Carriable"):
#			body.set_all_collision_layers(0)
#			print(body, 'changed collision layers to 0')
			
	else:
#		if body.is_in_group("Player") || body.is_in_group("Carriable"):
#			body.set_all_collision_layers(2)
#			print(body, 'changed collision layers to 2')
		yield(get_tree(), "idle_frame")
		if body != null and (body.is_in_group("Player") or body.is_in_group("Carriable")):
			if not body.get_parent().is_in_group("Player"):
				var gp :Vector2 = body.global_position
				body.get_parent().remove_child(body)
				body.set_all_collision_layers(3)
#				print(body, 'changed collision layers to 3')
				$"../YSort".add_child(body)
#				print("parent changed to ", body.get_parent())
				body.global_position = gp
			
	
