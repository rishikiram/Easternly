extends Node

#var rng = RandomNumberGenerator.new()

var cannon_position:Vector2
var pinball_position:Vector2
func _ready():
#	cannon_position = $Pinball/Cannon.position
#	$Pinball/Cannon.position = $Pinball/Cannon.position + Vector2(-230, 250)
	pinball_position = $Pinball.position
	$Pinball.position = $Pinball.position + Vector2(0, -250)
	$Background/OceanBackround.on_window_resize()
	
func start_pinball():
	var tween = $Tween
	tween.interpolate_property($Camera2D, "position",
		$Camera2D.position, Vector2(135,170), 2,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)

	tween.interpolate_property($Camera2D, "zoom",
		$Camera2D.zoom, Vector2(.25,.25), 2,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	
	#Vector2(145,-180)	
	tween.interpolate_property($Pinball, "position",
		$Pinball.position, pinball_position, 2.5,
		Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
	#Vector(-100, 230)
#	tween.interpolate_property($Pinball/Cannon, "position",
#		$Pinball/Cannon.position, cannon_position, 2.5,
#		Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)

	tween.start()

func _on_NPC_clicked():
	start_pinball()





func _on_TextureButton_pressed():
	Global.goto_scene("res://scenes/OceanIsometric.tscn")