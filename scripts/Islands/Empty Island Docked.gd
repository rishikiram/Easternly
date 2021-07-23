extends Node

#var rng = RandomNumberGenerator.new()

var cannon_position:Vector2
var pinball_position:Vector2
var started = false
func _ready():
	GameData.add_coins(10)
#	cannon_position = $Pinball/Cannon.position
#	$Pinball/Cannon.position = $Pinball/Cannon.position + Vector2(-230, 250)
	pinball_position = $Pinball.position
	$Pinball.position = $Pinball.position + Vector2(0, -250)
	$Background/OceanBackround.on_window_resize()
#	get_tree().get_root().connect("size_changed", self, "on_window_resize")
#	set_pinball_position()

#func set_pinball_position():
#	var x = OS.window_size.x * $Camera2D.zoom.x *.75 - 246
#	var y = OS.window_size.y * $Camera2D.zoom.y *.75 - 142
#	print("x: ",x,"  y: ", y," " ,OS.window_size)
#	$Pinball.position = Vector2(x,y)

#func on_window_resize():
#	set_pinball_position()
	
func start_pinball():
	var tween = $Tween
	tween.interpolate_property($Camera2D, "position",
		$Camera2D.position, Vector2(135,170), 2,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)

	tween.interpolate_property($Camera2D, "zoom",
		$Camera2D.zoom, Vector2(.25,.25), 2,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	
#	tween.interpolate_property($"Background/OceanBackround", "scale",
#		$"Background/OceanBackround".scale, $"Background/OceanBackround".scale*(.4/.25), 2,
#		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	
	#Vector2(145,-180)	
	tween.interpolate_property($Pinball, "position",
		$Pinball.position, pinball_position, 2.5,
		Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
	#Vector(-100, 230)
#	tween.interpolate_property($Pinball/Cannon, "position",
#		$Pinball/Cannon.position, cannon_position, 2.5,
#		Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)

	tween.start()
	started = true

func _on_NPC_clicked():
	if not started:
		start_pinball()





func _on_TextureButton_pressed():
	Global.goto_scene("res://scenes/OceanIsometric.tscn")
