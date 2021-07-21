extends Area2D

export(int) var fall_to_layer_bit:= 2
func _ready():
	connect("body_exited",self, "_on_ItemOverboard_body_exited")


func _on_ItemOverboard_body_exited(body):
	if body.is_in_group("Item"):
		yield(get_tree(), "idle_frame")
		if not body.get_parent().is_in_group("Player"):
			var gp :Vector2 = body.global_position
			body.get_parent().remove_child(body)
			body.set_all_collision_layers(fall_to_layer_bit)
#			print(body, 'Collision Layer', body.collision_layer)
			$"../YSort".add_child(body)
#			print("parent changed to ", body.get_parent())
			body.global_position = gp
