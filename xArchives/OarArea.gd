extends Area2D

onready var anim_player := get_node("../AnimationPlayer")
onready var oars = [get_node("../Deck/Back Oar"), get_node("../Hull/Front Oar")]
var player_in_range := false

const highlighted_frame = 7
const normale_frame = 0

func _on_Oar_Area_body_entered(body):
	if body.is_in_group("Player"):
		player_in_range = true
		$Sprite.visible = true
		if !anim_player.is_playing():
			oars[0].frame = highlighted_frame
			oars[1].frame = highlighted_frame
func _on_Oar_Area_body_exited(body):
	if body.is_in_group("Player"):
		player_in_range = false
		$Sprite.visible = false
		if !anim_player.is_playing():
			oars[0].frame = normale_frame
			oars[1].frame = normale_frame
func _on_AnimationPlayer_animation_finished(anim_name):
	yield(get_tree(),"idle_frame")
	yield(get_tree(),"idle_frame")
	if player_in_range and !anim_player.is_playing():
		oars[0].frame = highlighted_frame
		oars[1].frame = highlighted_frame
func _unhandled_key_input(event):
	if player_in_range and event.is_action_pressed("e", true):
#		row()
		match PlayerVariables.player_state: 
			0:
				PlayerVariables.player_state = 1
				$Sprite.visible = false
			1:
				PlayerVariables.player_state = 0
				$Sprite.visible = true
	if PlayerVariables.player_state == 1 and event.is_action_pressed("space", true):
		row()
		get_tree().call_group("oars", "row")
func row():
	if !anim_player.is_playing():
		anim_player.play("row")
		get_tree().call_group("oar", "row")

