extends Node

const screen_size = Vector2(720, 450)
var rng = RandomNumberGenerator.new()

#enum {SIXbySIX, TENbyTEN, CIRCLE}
const DIMENTIONS = [Vector2(1,1), Vector2(2,2), Vector2(2,2)]
const PATHS = ["res://scenes/Islands/6x6", "res://scenes/Islands/12x12", "res://scenes/Islands/12x12"]

var next_chunk_position  = 0
var chunk_buffer = 50

var loader
var recent_resource 
var time_max = 1
signal resource_loaded

export (bool) var run_tutorial:= false
func _ready():
	if run_tutorial:
		load_tutorial()
		run_tutorial = false
		
	load_chunk(Vector2(next_chunk_position,-225))
func load_tutorial():
	#load wind tutorial
	$"WindParrallelX/Wind".visible = false
	$"YSort/Pirate Miniship".idle = true
	#load key coins tutorial
	var tutorial = load("res://scenes/Islands/Screen/Tutorial.tscn").instance()
	$YSort.add_child(tutorial)#position = 0,0
	next_chunk_position = tutorial.size.x
	
func _process(time):
	if loader == null:
		# no need to process anymore
		set_process(false)
		return
	# Wait for frames to let the "loading" animation show up.
	#if wait_frames > 0:
		#wait_frames -= 1
		#return

	var t = OS.get_ticks_msec()
	# Use "time_max" to control for how long we block this thread.
	while OS.get_ticks_msec() < t + time_max:
		# Poll your loader.
		var err = loader.poll()

		if err == ERR_FILE_EOF: # Finished loading.
			var resource = loader.get_resource()
			loader = null
			recent_resource = resource
			return emit_signal("resource_loaded")
			break
		elif err == OK:
			update_progress()
		else: # Error during loading.
			#show_error()
			print("error")
			loader = null
			break

func load_chunk(position = Vector2(0,-225), screen = screen_size, num_screens = 3):
	#from generated map, load chunk instantiates each islnad and places it according to the map.
	#the map takes the size of the screen, which is half a full screen becaue of camera zoom
	#idealy this should preload scenes it needs and then add everyting when needed
	#return the position of the the end of the chunk generated.
	# also moves player detector to near end of new chunk 
	
	#create virtual map for new islands
	var map = generate_map(Vector2(12,5),InventoryData.island_density_counter)
	#print("map is: \n", map)
	#load/instantiate islands in map into scene
	var island_resources := {}
	
	for island in map:
		
		var scene_path = PATHS[island[0]]+'/'+get_random_scene_in_folder(PATHS[island[0]])
		if not island_resources.has(scene_path):
			loader = ResourceLoader.load_interactive(scene_path)
			set_process(true)
			yield(self, "resource_loaded")
			island_resources[scene_path] = recent_resource
	
	#island_resources = load_islands(island_resources)
	
	#for island in map:
		var new_island = island_resources[scene_path].instance()
		$YSort.add_child(new_island)
		new_island.position = (convert_isometric_coordinate(island[1]+Vector2(0,-12)) + position)
		#print(new_island.position)
		# transform by chunk x-cordinate
	$PlayerDetector.position = Vector2(position.x + screen.x*num_screens -720,0)
	next_chunk_position = position.x + convert_isometric_coordinate(Vector2(12,-12)).x #2304
	InventoryData.increase_difficulty()
	
	#50%change of adding screen island
	if true:#Global.rng.randi()%2 == 0:
		loader = ResourceLoader.load_interactive("res://scenes/Islands/Screen/IslandScreen_a.tscn")
		set_process(true)
		yield(self, "resource_loaded")
		var island = recent_resource.instance()
		$YSort.add_child(island)
		island.position = Vector2(next_chunk_position,0)
		next_chunk_position += island.size.x + chunk_buffer
		$PlayerDetector.position = Vector2(next_chunk_position-720,0)
		
	

func generate_map(size=Vector2(12,5), density = 30):
	var map_matrix := create_isometric_matrix()#5,12 #pass in size ideally
	
	#loops through map 
	#randomly place islands on map
		#update map to represent islands locations
	#record islands location
	#convert location of isometric coordinates to cartesian coordinates.
	
	#get number of island: density/screen area
	var num_islands = density#ceil((size.x * size.y)/(screen_size.x * screen_size.y)*density)
	var island_list = []
	#[ [type, position :Vector2()], [t, p] ]
	
	#repeat number of islands
	for i in range(num_islands):
		var j = 0
		while j < 100:#no infinite loop
			#random position and type
			var island_type = Global.rng.randi_range(0, 2)#if island type is static there is no bug not sure why
			var x_cord = Global.rng.randi_range(0,map_matrix.size()-1)#(0, 16)
			var y_cord = Global.rng.randi_range(0,map_matrix[0].size()-1)#(0, 15)
			
			#check no other islands in area
			var bad_island = false
			for k in range(DIMENTIONS[island_type].x):
				for l in range(DIMENTIONS[island_type].y):
					if x_cord+k >= map_matrix.size() or y_cord+l >= map_matrix[0].size() or map_matrix[x_cord+k][y_cord+l] != 1:
						bad_island = true
						break
			if not bad_island:
				island_list.append([island_type, Vector2(x_cord, y_cord)])
				#update map
				for k in range(DIMENTIONS[island_type].x):
					for l in range(DIMENTIONS[island_type].y):
						map_matrix[x_cord+k][y_cord+l] = 0 #false, occupied
				break
			j += 1
		
	#return list of position and island ids
#	for row in map_matrix:
#		print(row)
	return island_list
#30 square tall
#5 * 6x6 rows tall
#rows 10 squares long
func create_isometric_matrix(h=5, w=12) -> Array:
	var matrix := []
	for x in range(w+h):#12+4+1): #w+h
		var a = []
		a.resize(w+h-1)#12+4) #w+h-1 
		matrix.append(a)
		for y in range(w+h-1):#12+4): #w+h-1
			if x + y < w-1:#11:#inner big #h*2+1
				matrix[x][y] = 0
			elif x + y > w+(2*h)-2:#20: #w+(2*h)-2 #outer big
				matrix[x][y] = 0
			elif x-y > w:#12: #w #high x, low y
				matrix[x][y] = 0
			elif y-x > w-1:#11:  #w+2*h+1 #high y, low x
				matrix[x][y] = 0
			else:
				matrix[x][y] = 1
#		print(matrix[x], " row: ",x)
	
	return matrix
func convert_isometric_coordinate(iso:Vector2):
	var x_v = Vector2(16,8)*6
	var y_v = Vector2(-16,8)*6
	#var p = Vector2(iso.x*x_v.x + iso.y*y_v.x, iso.x*x_v.y + iso.y*y_v.y)
	#print(p)
	return Vector2(iso.x*x_v.x + iso.y*y_v.x, iso.x*x_v.y + iso.y*y_v.y)
func get_random_scene_in_folder(folder_path):
	var numScenes = 0
	var scenes = []
	var dir = Directory.new()
	if dir.open(folder_path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while (file_name != ""):
			#print(file_name)
			if dir.current_is_dir() or file_name == ".." or file_name == ".":
				# Directories, Skip.
				pass
			else:
				scenes.append(file_name)
				numScenes += 1
			file_name = dir.get_next()
		#print("Got a list of "+str(numScenes)+" files")
	return scenes[floor(Global.rng.randf_range(0, numScenes))]

func update_progress():
	var progress = float(loader.get_stage()) / loader.get_stage_count()
	print(progress, "% stages loaded")

func _on_PlayerDetector_body_entered(body):
	print("body entered ",self.name," is ",body.name)
	if body.is_in_group("miniship"):
		load_chunk(Vector2(next_chunk_position,-225))


func _on_Area2D_area_entered(area):
	if area.is_in_group("IslandArea"):
		area.get_parent().queue_free()


