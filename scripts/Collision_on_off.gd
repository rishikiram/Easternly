extends StaticBody2D


const player_mask = 1
const inactive_mask = 4


func _on_Room_player_entered():
	#move collision mask
	set_collision_mask(inactive_mask)
	#make transparent
	get_parent().modulate = Color(1,1,1,0.4)

func _on_Room_player_exited():
	set_collision_mask(player_mask)
	get_parent().modulate = Color(1,1,1,1)

