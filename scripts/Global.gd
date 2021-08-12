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
	
	GameData.connect("end_game", self, "_on_end_game")
func start_game():
	call_deferred("_deferred_start_game")
	GameData.start_game()
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
	AudioManager.stop_music()
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

func pause_and_switch_scene(path):
	#load new scene(pinball)
	var new_scene = ResourceLoader.load(path)
	
	#pause and hide ocean_isometric
	get_tree().paused = true
	current_scene.visible = false#doesnt work
	
	#add new scene
	get_tree().get_root().add_child(new_scene)
	
	#wait until pinball is done
	yield(new_scene, "resume")
	new_scene.queue_free()
	
	#move ship back to main scene
	var ship:KinematicBody2D = get_tree().get_nodes_in_group("miniship")[0]
	ship.get_parent().remove_player_child_and_disable()
	
	#resume ocean scene
	get_tree().paused = false
	current_scene.visible = true#umm
