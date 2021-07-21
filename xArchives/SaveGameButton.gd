extends Button

export(int) var save_slot := -1

func _on_Button_pressed():
	if save_slot < 1:
		print("error!")
	Global.save_game(save_slot)
