tool
extends Area2D

#var is_tilted = get_parent().is_tilted 

onready var animated_sprite = get_node("../AnimatedSprite")
#var wind_vector 
#enum DIRECTION {N,E,S,W,NE, SE, SW, NW}
#export(DIRECTION) var direction = DIRECTION.NE
#onready var WindForeground = get_tree().get_root().get_node("Node").get_node('CanvasLayer').get_node('WindForeground') 
func _ready():
	set_animation(get_parent().is_tilted )
	#set_wind_vector()
	#get_parent().wind_vector = wind_vector
#func set_tilted(b):
#	set_animation(b)
func set_animation(b):
	if b:
		animated_sprite.play('tilted')
	else:
		animated_sprite.play('normal')
#func set_wind_vector():
	#if is_tilted:
		#wind_vector = Vector2(1,0).rotated( rotation+(PI/4) )
	#else:
		#wind_vector = Vector2(1,0).rotated(rotation)
		
#func _on_WindArea_body_entered(body: KinematicBody2D)->void:
#	if body is KinematicBody2D:
#		var wind_speed = get_parent().get_child(0).speed_scale
#		var rota = get_parent().rotation
#		#var rota = rotation
#		if is_tilted: 
#			rota -= PI/4
#		PlayerVariables.wind_vector = Vector2(wind_speed,0).rotated(rota)
		
		#PlayerVariables.wind_vector = Vector2(1,0).rotated(rota)
		#change_wind_animation()
		
#func change_wind_animation():
	#WindForeground.is_tilted = is_tilted
	#WindForeground.direction = direction
	#WindForeground.visible = true
	
#func _on_WindArea_body_exited(body):
	#if body is KinematicBody2D:
		#print('body exited signal triggered')
