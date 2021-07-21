extends MarginContainer


onready var coin_counter = $"Top Right/Coin/Label"
func _ready():
	GameData.connect("update_HUD", self, "_on_update_HUD")
	update_coins()
func update_coins():
	coin_counter.text = str(GameData.coins)
func _on_update_HUD():
	update_coins()
