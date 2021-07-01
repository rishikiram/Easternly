extends Node2D


var coin
var rng = RandomNumberGenerator.new()
func _ready():
	coin = preload("res://scenes/Pinball/coin.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_Timer_timeout():
	var nc = coin.instance()
	add_child(nc)
	nc.position = Vector2(49 + rng.randf_range(-5,5), -40+rng.randf_range(-8,8))
