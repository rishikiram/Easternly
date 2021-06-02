extends MarginContainer


onready var coin_counter = $"Top Right/CoinContainer/Coin Counter"
func _enter_tree():
	GameData.connect("tik", self, "_on_clock_tik")
func _ready():
	PlayerVariables.connect("update_backpack", self, "_on_update_backpack")
	PlayerVariables.connect("update_HUD", self, "_on_update_HUD")
	get_player_inventory().visible = false
	update_coins()
	update_inventory()
#func _process(delta):
#	if Input.is_action_just_pressed("space"):
#		print(get_player_inventory().rect_position, get_player_inventory().rect_size )	
func _unhandled_input(event):
	if event.is_action_pressed("i"):
		get_player_inventory().visible = !(get_player_inventory().visible)
func _gui_input(event):
	print("gui input")

func update_coins():
	coin_counter.text = "Coins: " + str(PlayerVariables.coins)
#	resize_coin_counter()
func update_inventory():
	get_player_inventory().update()

#func resize_coin_counter():
#	var length = coin_counter.get_font("normal_font").get_string_size(coin_counter.text)
#	coin_counter.rect_size = Vector2(length.x,rect_size.y)
func get_player_inventory():
	return $"Top Right/Backpack/GridContainer"

func _on_update_HUD():
	update_coins()
	update_inventory()
func _on_update_backpack():
	update_inventory()
func _on_TextureButton_pressed():
	get_player_inventory().visible = !get_player_inventory().visible
func _on_clock_tik(time):
	$"Top Left/Time".text = str(time)
