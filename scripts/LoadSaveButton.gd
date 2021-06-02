extends Button

export (int) var slot := 1

func _on_Button_pressed():
	if slot < 1:
		print("error!")
	Global.load_game("user://savegame" +str(slot)+ ".save")

