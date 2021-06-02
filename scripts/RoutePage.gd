extends MarginContainer
onready var main_container = $"MarginContainer/VBoxContainer"
export (Array) var ship_rent_prices := [60, 30]#[pirate, rowboat]
#{
#	GameData.SHIP_TYPES.ROWBOAT: 30,
#	GameData.SHIP_TYPES.PIRATE: 60
#}
func load_route(route_dict):
	var time_elapsed = str(route_dict["end time"] - route_dict["start time"])
	main_container.get_node("Time Label").text = "Time: "+time_elapsed
	
	var profit = calculate_profit(route_dict["event log"])
	main_container.get_node("Profit Label").text = "Profit: $" + str(profit)
	main_container.get_node("Profit").text = "and no items"
	
	var cost = ship_rent_prices[route_dict["ship type"]] + int(time_elapsed)/10
	main_container.get_node("Cost Label").text = "Cost: $" + str(cost)
	main_container.get_node("Cost").text = "Ship Rent: "+str(ship_rent_prices[route_dict["ship type"]])
	main_container.get_node("Cost").text += "\nTime Cost: "+str(int(time_elapsed)/10)
func calculate_profit(event_log):
	var profit = 0
#	var item_count = 0
	for event in event_log:
		if event[0] == "sold":
			profit += event[2]
#			item_count += 1
		if event[0] == "bought":
			profit -= event[2]
#			item_count += 1
	return profit
