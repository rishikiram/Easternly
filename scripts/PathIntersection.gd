extends Area2D


export(int) var exit_to_layer_bit:int
#export(String) var exit_to_new_parent:String

func _ready():
	#should be child of new sprite layer
	#with ysort child
	#should convert layer value to bit
	exit_to_layer_bit = log($'../StaticBody2D'.collision_layer)/log(2)
	




func _on_PathIntersection_body_exited(body):
	if body.is_in_group("Carriable"):
		var gp :Vector2 = body.global_position#i think sometimes unecessary 
		body.get_parent().remove_child(body)
		body.set_all_collision_layers(exit_to_layer_bit)
#		print(body, 'Collision Layer', body.collision_layer)
		$"../YSort".add_child(body)
#		print("parent changed to ", body.get_parent())
		body.global_position = gp
