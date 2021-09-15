extends Sprite

export(NodePath) var camera_path
export(float) var scroll_scale
var camera

func _ready():
	if camera_path:
		camera = get_node(camera_path)
	get_tree().get_root().connect("size_changed", self, "on_window_resize")
	on_window_resize()
	

func _process(delta):
	if camera:
		region_rect.position = camera.position/scale.x / camera.zoom.x#scroll_scale
	
func on_window_resize():
	#print(OS.window_size)
	region_rect.size = OS.window_size / scale.x
