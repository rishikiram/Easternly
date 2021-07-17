extends "res://scripts/Classes/Miniship_classV2.gd"

export(float) var oar_force := 1
var is_rowing := false
export(float) var wind_force_coefficient := 1.5

onready var sail_path = $Sail
onready var oar_path = $Oar

func row():
	get_tree().call_group("oars", "row")
func turn_sail(x=0):
	if x == 0:
		get_tree().call_group("Sail", "sail_updown")
	else:
		get_tree().call_group("Sail", "turn_sail", x)
func get_forces():
	var force_sum :=Vector2(0,0)
	if is_rowing:
		force_sum += Vector2(oar_force,0).rotated(rotation)
	force_sum += get_wind_force()
	return force_sum
func get_wind_force():
	#var areas = $Area2D.get_overlapping_areas()
	#var wind_vector := Vector2(0,0)
	
	#for area in areas:
		#if area.is_in_group("wind"):
			#wind_vector = area.get_parent().wind_vector
			#break
#	if Input.is_action_just_pressed("e"):
#		print(wind_vector)
	#if wind_vector == Vector2(0,0):
		#return 0
		
	var wind_vector := Vector2(InventoryData.wind_speed_counter,0)#Vector2(1,0)
	if $"../../WindParrallelX/Wind" and (not $"../../WindParrallelX/Wind".visible):
		return 0
	var ship_dir = Vector2(1,0).rotated(rotation)
	var sail_dir:Vector2 = ship_dir#sail_path.get_sail_direction().rotated(rotation)
	var wind_sail_angle = sail_dir.angle_to(wind_vector)
	return ship_dir*(ship_dir.dot(wind_vector)*wind_force_coefficient)
	#var force := Vector2()
	
	#if abs(wind_sail_angle) < PI/2:
		#force = sail_dir
#		$Sail.modulate = Color.from_hsv(0.3*sail_dir.length(), 1, 1)
	#else:
		#force = sail_dir.dot(wind_vector)*sail_dir
#		$Sail.modulate = Color.from_hsv(0.3*sail_dir.dot(wind_vector), 1, 1)
	#force = sail_dir.dot(wind_vector)*sail_dir
	#get_tree().call_group("Flag", "handle_wind_force", force.dot(ship_dir) )
	#return force.dot(ship_dir)*wind_force_coefficient
func _process(delta):
	rotate_mesh(rotation)
	#if Input.is_action_just_pressed("w"):
		#$Viewport/Ship3D/Camera.translation = $Viewport/Ship3D/Camera.translation + Vector3(-1, 1, 0)
		#$Sprite.position = $Sprite.position + Vector2(1,0)
	#if Input.is_action_just_pressed("s"):
		#$Viewport/Ship3D/Camera.translation = $Viewport/Ship3D/Camera.translation - Vector3(-1, 1, 0)
		#$Sprite.position = $Sprite.position - Vector2(1,0)
func rotate_mesh(rot):
	$Viewport/Ship3D/mesh.rotation = Vector3(0, -rot, 0)
	#print("DEBIG: rotation of ship mesh",$Viewport/KinematicBody/mesh.rotation)
	$Sprite.texture = $Viewport.get_texture()
	$Sprite.rotation = -rot
	
	$CollisionPolygon2D.rotation = -sin(rot*2) * .2
	$CollisionPolygon2D.scale.x = cos(rot*2)*.2 + .75
func _on_VisibilityNotifier2D_viewport_exited(viewport):
	if position.y > 0:
		position.y = -position.y
	else:
		position.y = -position.y


