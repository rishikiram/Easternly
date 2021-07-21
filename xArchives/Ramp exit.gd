extends Area2D

export(bool) var is_exit := true
func _ready():
#	connect("body_exited", self, "_on_Area2D_body_exited")
	connect("body_entered", self, "_on_Area2D_body_entered")

func _on_Area2D_body_entered(body):
	if is_exit:
		yield(get_tree(), "idle_frame")
		if body.is_in_group("Player") or body.is_in_group("Carriable"):
			if not body.get_parent().is_in_group("Player"):
				var gp :Vector2 = body.global_position
				body.get_parent().remove_child(body)
				body.set_all_collision_layers(2)
				print(body, 'changed collision layers to 2')
				$"../../Lower Deck/YSort".add_child(body)
				print("parent changed to ", body.get_parent())
				body.global_position = gp

	else:
		yield(get_tree(), "idle_frame")
		if body.is_in_group("Player") or body.is_in_group("Carriable"):
			if not body.get_parent().is_in_group("Player"):
				var gp :Vector2 = body.global_position
				body.get_parent().remove_child(body)
				body.set_all_collision_layers(3)
				print(body, 'changed collision layers to 3')
				$"../YSort".add_child(body)
				print("parent changed to ", body.get_parent())
				body.global_position = gp
