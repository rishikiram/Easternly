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
