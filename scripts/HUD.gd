extends MarginContainer


onready var coin_counter = $"Top Right/Coin/Label"
func _ready():
	GameData.connect("update_HUD", self, "_on_update_HUD")
	update_coins()
func update_coins():
	coin_counter.text = str(GameData.coins)
func _on_update_HUD():
	update_coins()
func _process(delta):
	if get_tree().get_nodes_in_group("miniship").size()>0:
		$"Top Left/Distance/Label".text = str(int(GameData.distance + get_tree().get_nodes_in_group("miniship")[0].position.x)/100) + " Meters"
"Top Left/Distance"
func _unhandled_key_input(event):
	if event.is_action_pressed("tab"):
		if Global.is_testing:
			var image = get_viewport().get_texture().get_data()
			image.flip_y()
			image.save_png("screenshot.png")
