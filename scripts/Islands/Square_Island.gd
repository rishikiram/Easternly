extends Node2D


var seen := false
var old_pos:Vector2

func _ready():
	set_process(false)
func _process(delta):
	$Path2D/PathFollow2D.get_child(0).rotate_mesh($Path2D/PathFollow2D.rotation)
#	$Path2D/PathFollow2D.unit_offset += delta/3
#	print($Path2D/PathFollow2D.unit_offset)
#	var tween = $Tween
#
#	print(tween)
func make_player_child(player:KinematicBody2D):
	old_pos = player.position
	GameData.distance += 100+floor(get_tree().get_nodes_in_group("miniship")[0].position.x)
	var angle = Vector2(1,0).angle_to(position - player.position + Vector2(0,48))
	$Path2D/PathFollow2D.unit_offset = angle/(2*PI)
	
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
		$Path2D/PathFollow2D.unit_offset, $Path2D/PathFollow2D.unit_offset+0.7, 4,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

func remove_player_child_and_disable():
	if not $Path2D/PathFollow2D.get_child(0):
		return
		
	var ship:KinematicBody2D = $Path2D/PathFollow2D.get_child(0)
	
	remove_child(ship)
	ship.position = old_pos
	
	get_parent().add_child(ship)
	
	ship.set_physics_process(true)
	ship.set_process(true)
	set_process(false)
	
func _on_Area2D_body_entered(body):
	if body.is_in_group('miniship'):
		$Area2D.set_collision_mask_bit(5, false)
		call_deferred("make_player_child", body)


func _on_Tween_tween_all_completed():
#	Global.pause_and_switch_scene("res://scenes/Islands/Empty Island Docked.tscn")
	Global.goto_scene("res://scenes/Islands/Empty Island Docked.tscn")
