extends Node2D

export (Vector2) var size:= Vector2(9,5)

var original_wind_speed 
func _ready():
	original_wind_speed = GameData.wind_speed_counter
func _on_Area2D_A_body_entered(body):
	if body.is_in_group("miniship"):
		GameData.wind_speed_counter+=0.2
		print(GameData.wind_speed_counter)


func _on_Area2D_B_body_entered(body):
	if body.is_in_group("miniship"):
		GameData.wind_speed_counter = original_wind_speed
		print(GameData.wind_speed_counter)
