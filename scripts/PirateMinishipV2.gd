extends "res://scripts/Classes/Miniship_classV2.gd"

export(float) var oar_force := 3
var is_rowing := false
export(float) var wind_force_coefficient := 1.5

#onready var sail_path = $Sail
#onready var oar_path = $Oar

func row():
	get_tree().call_group("oars", "row")
	
#func turn_sail(x=0):
#	if x == 0:
#		get_tree().call_group("Sail", "sail_updown")
#	else:
#		get_tree().call_group("Sail", "turn_sail", x)
func get_forces():
	var force_sum :=Vector2(0,0)
	if is_rowing:
		force_sum += Vector2(oar_force,0).rotated(rotation)
	force_sum += get_wind_force()
	return force_sum
	
func get_wind_force():
	var wind_vector := Vector2(GameData.wind_speed_counter,0)#Vector2(1,0)
	
	if not get_tree().get_nodes_in_group('wind') or (not get_tree().get_nodes_in_group('wind')[0].visible):
		return Vector2(0,0)
		
	var ship_dir = Vector2(1,0).rotated(rotation)
#	var sail_dir:Vector2 = ship_dir#sail_path.get_sail_direction().rotated(rotation)
	
#	var wind_sail_angle = sail_dir.angle_to(wind_vector)
	return ship_dir*(ship_dir.dot(wind_vector)*wind_force_coefficient)
	
func _process(delta):
	rotate_mesh(rotation)
#func _input(event):
#	if event.is_action_pressed("shift"):
#		var image = get_viewport().get_texture().get_data()
#		image.flip_y()
#		image.save_png("screenshot.png")
	
func rotate_mesh(rot):
	$Viewport/Ship3D/mesh.rotation = Vector3(0, -rot, 0)
	$Sprite.texture = $Viewport.get_texture()
	$Sprite.rotation = -rot
	#custom colision rotations for isometric
	$CollisionPolygon2D.rotation = -sin(rot*2) * .2
	$CollisionPolygon2D.scale.x = cos(rot*2)*.2 + .75



