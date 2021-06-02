tool
extends Node2D
export(bool) var is_tilted:bool setget set_tilted
export(Vector2) var wind_vector = Vector2() setget ,get_wind_vector

#func _ready():
#	if is_tilted:
#		wind_vector = Vector2(1,0).rotated( rotation-(PI/4) )
#	else:
#		wind_vector = Vector2(1,0).rotated(rotation)
##	$WindArea.wind_vector = wind_vector
func get_wind_vector() -> Vector2:
	if is_tilted:
		return Vector2(1,0).rotated( rotation-(PI/4) )
	else:
		return Vector2(1,0).rotated(rotation)
func set_tilted(b:bool):
	is_tilted = b
	if get_child_count() < 0:
		return
	if b:
		$AnimatedSprite.play("tilted")
	else:
		$AnimatedSprite.play("normal")
