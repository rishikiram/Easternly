extends StaticBody2D

func _on_TextureButton_pressed():
	open_book()
func open_book():
	$Routes/RouteMenu.visible = !$Routes/RouteMenu.visible
	$Routes/RouteMenu.update()
