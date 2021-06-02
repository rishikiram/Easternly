extends MarginContainer

var routepage_parent_path = "HBoxContainer"
func update():
	for child in get_node(routepage_parent_path).get_children():
		child.queue_free()
		
	var route_page :PackedScene= load("res://scenes/GUI/RoutePage.tscn")
	for route_dict in GameData.route_registery:
		var new_page = route_page.instance()
		get_node(routepage_parent_path).add_child(new_page)
		new_page.load_route(route_dict)

