extends "res://scripts/Classes/Miniship_class.gd"

export(float) var oar_force := 1.5
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
	var force_sum :float=0
	if is_rowing:
		force_sum += oar_force
	force_sum += get_wind_force()
	return force_sum
func get_wind_force():
	var areas = $Area2D.get_overlapping_areas()
	var wind_vector := Vector2(0,0)
	for area in areas:
		if area.is_in_group("wind"):
			wind_vector = area.get_parent().wind_vector
			break
#	if Input.is_action_just_pressed("e"):
#		print(wind_vector)
		
	var ship_dir = Vector2(1,0).rotated(rotation)
	var sail_dir:Vector2 = sail_path.get_sail_direction().rotated(rotation)
	var wind_sail_angle = sail_dir.angle_to(wind_vector)
	var force := Vector2()
	
	if abs(wind_sail_angle) < PI/2:
		force = sail_dir
#		$Sail.modulate = Color.from_hsv(0.3*sail_dir.length(), 1, 1)
	else:
		force = sail_dir.dot(wind_vector)*sail_dir
#		$Sail.modulate = Color.from_hsv(0.3*sail_dir.dot(wind_vector), 1, 1)
	get_tree().call_group("Flag", "handle_wind_force", force.dot(ship_dir) )
	return force.dot(ship_dir)*wind_force_coefficient
