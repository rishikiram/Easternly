extends Area2D

#onready var WindForeground = get_tree().get_root().get_node("Node").get_node('CanvasLayer').get_node('WindForeground') 


func _on_Area2D_body_entered(body):
	if body is KinematicBody2D:
		#print('Wind Reset')
		PlayerVariables.wind_vector = Vector2(0,0)
		#WindForeground.visible = false

