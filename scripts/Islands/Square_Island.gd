extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _process(delta):
	$Path2D/PathFollow2D.get_child(0).rotate_mesh($Path2D/PathFollow2D.rotation)
func make_player_child(player:KinematicBody2D):
	if player.get_parent():
		player.get_parent().remove_child(player)
	$Path2D/PathFollow2D.add_child(player)
	player.position= Vector2(0,0)
	player.rotation = 0
	player.set_physics_process(false)
	player.set_process(false)
	set_process(true)
	
	var tween = $Tween
	tween.interpolate_property($Path2D/PathFollow2D, "unit_offset",
		0, 1, 3,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

	
func _on_Area2D_body_entered(body):
	if body.is_in_group('miniship'):
		$Area2D.set_collision_mask_bit(5, false)
		call_deferred("make_player_child", body)


func _on_Tween_tween_all_completed():
	Global.goto_scene("res://scenes/Islands/Empty Island Docked.tscn")
