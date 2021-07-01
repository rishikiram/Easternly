extends Node

const screen_size = Vector2(720, 450)
var rng = RandomNumberGenerator.new()

enum {SIXbySIX, TENbyTEN, CIRCLE}
const DIMENTIONS = [Vector2(384,192), Vector2(640,340), Vector2(284,150)]
const PATHS = ["res://scenes/Islands/6x6", "res://scenes/Islands/10x10", "res://scenes/Islands/10x10"]

var next_chunk_position  = 0
var chunk_buffer = 50

var loader
var recent_resource 
var time_max = 1
signal resource_loaded

func _ready():
	rng.randomize()
	load_chunk()#yield makes load chunk not return a value
	#print(next_chunk_position)
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
	var map = generate_map(Vector2(screen.x*num_screens, screen.y), 10)
	#print("map is: \n", map)
	#load/instantiate islands in map into scene
	var island_resources := {}
	
	for island in map:
		var scene_path = get_random_scene_in_folder(PATHS[island[0]])
		if not island_resources.has(scene_path):
			loader = ResourceLoader.load_interactive(PATHS[island[0]]+'/'+scene_path)
			set_process(true)
			yield(self, "resource_loaded")
			island_resources[scene_path] = recent_resource
	
	#island_resources = load_islands(island_resources)
	
	#for island in map:
		var new_island = island_resources[scene_path].instance()
		$YSort.add_child(new_island)
		new_island.position = (island[1] + position)
		#print(new_island.position)
		# transform by chunk x-cordinate
	$PlayerDetector.position = Vector2(position.x + screen.x*num_screens -720,0)
	next_chunk_position = position.x + screen.x*num_screens + chunk_buffer

func generate_map(size:Vector2, density = 10):
	#get number of island: density/screen area
	var num_islands = ceil((size.x * size.y)/(screen_size.x * screen_size.y)*density)
	var island_list = []
	#[ [type, position :Vector2()], [t, p] ]
	
	#repeat number of islands
	for i in range(num_islands):
		var j = 0
		while j < 100:
			#random position and type
			var island_type = floor(rng.randf_range(0, 3))
			var x_cord = ceil(rng.randf_range(0, size.x))
			var y_cord = ceil(rng.randf_range(0, size.y))
			
			#check no other islands in area
			var a = DIMENTIONS[island_type].x
			var bad_island = false
			for island in island_list:
				if pow((x_cord - island[1].x), 2)/pow(a, 2) + pow((y_cord - island[1].y), 2)/pow(a/2, 2) < 1:
					#x_cord = rng.randf_range(0, size.x)
					#y_cord = rng.randf_range(0, size.y)
					bad_island = true
					break
			if not bad_island:
				island_list.append([island_type, Vector2(x_cord, y_cord)])
				break
			j += 1
		
	#return list of position and island ids
	return island_list
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
	return scenes[floor(rng.randf_range(0, numScenes))]



func update_progress():
	var progress = float(loader.get_stage()) / loader.get_stage_count()
	print(progress, "% stages loaded")




func _on_PlayerDetector_body_entered(body):
	print("body entered ",self.name," is ",body.name)
	load_chunk(Vector2(next_chunk_position,-225))
	
