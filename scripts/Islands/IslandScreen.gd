extends Node2D

export (Vector2) var size:= Vector2(0,5*6*16)


func _ready():
	
	if size == Vector2(0,0):
		size.x = $Area2D.position.x + $Area2D/CollisionShape2D.position.x

