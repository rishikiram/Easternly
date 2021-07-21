extends MarginContainer


onready var coin_counter = $"Top Right/Coin/Label"
func _enter_tree():
	GameData.connect("tik", self, "_on_clock_tik")
func _ready():
	InventoryData.connect("update_HUD", self, "_on_update_HUD")
	update_coins()
func update_coins():
	coin_counter.text = str(InventoryData.coins)
func _on_update_HUD():
	update_coins()
