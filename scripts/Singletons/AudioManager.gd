extends Node

func start_music():
	$"Lofi Guitar Loop".play()
func stop_music():
	$"Lofi Guitar Loop".stop()
	
func gain_coin():
	$coin_gain.play()
func loose_coin():
	$coin_loose.play()

func start_ocean():
	$"Ocean Sounds".play()
func stop_ocean():
	$"Ocean Sounds".stop()
