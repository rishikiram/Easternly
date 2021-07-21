extends Node
###
# global changes scenes and saves/loads game
#
#	global also has a static func which finds node with group "Player" 
###
var rng = RandomNumberGenerator.new()
var current_scene = null
#var current_scene_path :String
signal scene_loaded
func _ready():
	rng.randomize()
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)
	randomize()
	Input.set_custom_mouse_cursor(load("res://art/GUI/Cursor_Hand-sheet.png"), Input.CURSOR_POINTING_HAND)
	
	InventoryData.connect("end_game", self, "_on_end_game")
#func save_test():
#	var save_game = File.new()
#	save_game.open("user://savegame.save", File.WRITE)
#	save_game.store_line("test")
#	save_game.close()
##	initialize_mouse_cursor()
func start_game():
	call_deferred("_deferred_start_game")
	InventoryData.start_game()
func _deferred_start_game():
	var old_scene = current_scene
	# Load the new scene.
	var s = ResourceLoader.load("res://scenes/OceanIsometric.tscn")
	
	# Instance the new scene.
	current_scene = s.instance()
	current_scene.run_tutorial = true
	
	# Add it to the active scene, as child of root.
	get_tree().get_root().add_child(current_scene)
	get_tree().set_current_scene(current_scene)
	emit_signal("scene_loaded")
	old_scene.free()
func _on_end_game():
	call_deferred("_deferred_on_end_game")
func _deferred_on_end_game():
	# Load the new scene.
	current_scene.free()
	var s = ResourceLoader.load("res://scenes/StartMenu.tscn")
	
	# Instance the new scene.
	current_scene = s.instance()
	current_scene.run_gameover = true
	
	# Add it to the active scene, as child of root.
	get_tree().get_root().add_child(current_scene)
	get_tree().set_current_scene(current_scene)
	emit_signal("scene_loaded")
func goto_scene(scene_path, ship_enviroment_node = null):#island_id #-1 could be the ocean
	#get scene state from game data
	call_deferred("_deferred_goto_scene", scene_path, ship_enviroment_node)
func _deferred_goto_scene(scene_path, ship_enviroment_node = null):
	# It is now safe to remove the current scene
	if current_scene.has_method("save_scene"):#
		current_scene.save_scene()
#		GameData.island_registry[current_scene.unique_id] = current_scene.save_game()
	current_scene.free()
	
	# Load the new scene.
#	var new_scene_data = GameData.island_registry[scene_id]
#	var s = ResourceLoader.load(new_scene_data["scene path"])
	var s = ResourceLoader.load(scene_path)
	
	# Instance the new scene.
	current_scene = s.instance()
#	current_scene_path = scene_path
#	current_scene.scene_state = new_scene_data
	
	# Add it to the active scene, as child of root.
	get_tree().get_root().add_child(current_scene)
	####ready func runs of scene###
	# Optionally, to make it compatible with the SceneTree.change_scene() API.
	##not sure what this does####
	get_tree().set_current_scene(current_scene)
	
#	if current_scene.has_method("load_scene"):#in ready function beacuse it should be called everytime
#		current_scene.load_scene()#GameData.island_registery[scene_path])
	emit_signal("scene_loaded")
#func save_game(slot = 1):
#	current_scene.save_scene()
#	var save_dict := {
#		"game data" : GameData.create_save_file(),
#		"current scene path" : current_scene.scene_path,
#		"player state" : PlayerVariables.save_game()
#
#	}
#	var json_str = JSON.print(save_dict)
#	var save_game = File.new()
#
#	save_game.open("user://savegame" +str(slot)+ ".save", File.WRITE)
#	save_game.store_line(json_str)
#	save_game.close()
#	#write savve_dict as json to a save file
#func load_game(save_file_path = "user://savegame1.save" ):
#	var save_game = File.new()
#	if not save_game.file_exists(save_file_path):
#		print("save file not found")
#		return
#	#gets first line which is json dict for everything
#	save_game.open(save_file_path, File.READ)
#	var save_data = parse_json(save_game.get_line())
#	save_game.close()
#
#	GameData.load_save_file(save_data["game data"])
#	goto_scene(save_data["current scene path"])
##	yield(self, "scene_loaded")
##	PlayerVariables.load_game(save_data["player state"]) 
##func create_island_save(dict: Dictionary, island_name:String):
##	var file = File.new()
##	file.open("res://resources/island data/" + island_name +".json", File.WRITE)
##	file.store_line(to_json(dict))
##	file.close()
#static func find_player(node, group_name = "Player"):
#	for child in node.get_children():
##		print("checked ", child.name)
#		if child.is_in_group(group_name):
#			return child
#		elif child.get_child_count() > 0:
#			var nod = find_player(child) 
#			if nod != null:
#				return nod
#	return null
