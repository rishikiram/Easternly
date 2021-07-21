extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var quest_folder_path = "res://resources/quest_data"
var REGISTRY = {}
# Called when the node enters the scene tree for the first time.
func _ready():
	load_quests()

func load_quests():
	var file_paths = list_json_files_in_directory(quest_folder_path)
	for file in file_paths:
		load_quest(quest_folder_path +"/"+ file)

func load_quest(url: String) -> void:
	var file = File.new();
	
	if (!file.file_exists(url)):
		print("      Failed to open file! Doesn't exist!");
		return;
	
	if (file.open(url, File.READ)):
		print("      Failed to open file!");
		return;

	#print("test: ", file.get_as_text())

	var json_result = JSON.parse(file.get_as_text());
	file.close();

	if (json_result.error != 0):
		print("      Parse error (", json_result.error, ")");
		return;

	#print("      Data: ", json_result.result);
	var quest_data:Dictionary = json_result.result;
	check_quest_data(quest_data);
	
	
func check_quest_data(quest_data):
	var quest_id: String = quest_data.get("id");

	if (quest_id == null):
		print("      Malformed json! Missing 'id' field!");
		return;
		
	if (typeof(quest_id) != TYPE_STRING):
		print("      Malformed json! Field 'id' is not string!");
		return;

	var items = quest_data.get("items", {});
	if (typeof(items) != TYPE_DICTIONARY):
		print("      Malformed json! Field 'items' is not map!");
		return;
	var reward = int(quest_data.get("reward"));
	if reward == null:
		print("      Malformed json! Field 'reward' is not map!");
		return;
		
	REGISTRY[quest_id] = {"items":items, "reward":reward};
#	REGISTRY[quest_id] = items;
	
	
func list_json_files_in_directory(path):
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with(".") and file.ends_with(".json"):
			files.append(file)

	dir.list_dir_end()

	return files
func get_quest_by_id(id:String):
	return REGISTRY[id]
