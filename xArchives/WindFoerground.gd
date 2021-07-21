tool
extends Control
export(bool) var is_tilted := false setget set_tilted
export(bool) var play:= false setget set_play
var normal := [
	preload("res://art/Wind Animation/Wind1.png"),
	preload("res://art/Wind Animation/Wind2.png"),
	preload("res://art/Wind Animation/Wind3.png"),
	preload("res://art/Wind Animation/Wind4.png"),
	preload("res://art/Wind Animation/Wind5.png"),
	preload("res://art/Wind Animation/Wind6.png"),
	preload("res://art/Wind Animation/Wind7.png"),
	preload("res://art/Wind Animation/Wind8.png"),
	preload("res://art/Wind Animation/Wind9.png"),
	preload("res://art/Wind Animation/Wind10.png"),
	preload("res://art/Wind Animation/Wind11.png"),
	preload("res://art/Wind Animation/Wind12.png"),
	preload("res://art/Wind Animation/Wind13.png"),
]
var tilted := [
	preload("res://art/Wind Animation/Wind_NE_1.png"),
	preload("res://art/Wind Animation/Wind_NE_2.png"),
	preload("res://art/Wind Animation/Wind_NE_3.png"),
	preload("res://art/Wind Animation/Wind_NE_4.png"),
	preload("res://art/Wind Animation/Wind_NE_5.png"),
	preload("res://art/Wind Animation/Wind_NE_6.png"),
	preload("res://art/Wind Animation/Wind_NE_7.png"),
	preload("res://art/Wind Animation/Wind_NE_8.png"),
	preload("res://art/Wind Animation/Wind_NE_9.png"),
	preload("res://art/Wind Animation/Wind_NE_10.png"),
	preload("res://art/Wind Animation/Wind_NE_11.png"),
	preload("res://art/Wind Animation/Wind_NE_12.png"),
	preload("res://art/Wind Animation/Wind_NE_13.png"),
]
var frames:Array
export(int) var frame_offset := 1
var frame := 1
func _ready():
	set_tilted(is_tilted)
	$Timer.start()
func _on_Timer_timeout():
	frame += 1
	if frame >= frames.size() + frame_offset:
		frame -= frames.size()
	$Wind.texture = frames[frame%frames.size()]
	$Wind2.texture = frames[frame%frames.size()-frame_offset]
func set_tilted(b:bool):
	is_tilted = b
	if is_tilted:
		frames = tilted
	else:
		frames = normal
func set_play(b):
	play = b
	if $Timer == null:
		print("timer not instanced yet")
		return
	if b:
		print(get_children())
		$Timer.start()
	else:
		$Timer.stop()
