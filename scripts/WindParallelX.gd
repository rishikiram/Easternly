extends Sprite


var frames = [
preload("res://art/Wind Animation/Wind1.png"),
preload("res://art/Wind Animation/Wind2.png"),
preload("res://art/Wind Animation/Wind3.png"),
preload("res://art/Wind Animation/Wind4.png"),
preload("res://art/Wind Animation/Wind5.png"),
preload("res://art/Wind Animation/Wind6.png"),
preload("res://art/Wind Animation/Wind7.png"),
preload("res://art/Wind Animation/Wind8.png"),
preload("res://art/Wind Animation/Wind9.png"),
preload("res://art/Wind Animation/Wind10.png"),
preload("res://art/Wind Animation/Wind11.png"),
preload("res://art/Wind Animation/Wind12.png"),
preload("res://art/Wind Animation/Wind13.png"),
]
var frameframe := 0


func _on_Timer_timeout():
	frameframe = (frameframe+1) % 13
	self.texture = frames[frameframe]

export(NodePath) var camera_path
export(float) var scroll_scale
var camera

func _ready():
	
	on_window_resize()
	if camera_path:
		camera = get_node(camera_path)
	get_tree().get_root().connect("size_changed", self, "on_window_resize")



func _process(delta):
	if camera:
		region_rect.position = camera.position/scale.x / scroll_scale

func on_window_resize():
	#print(OS.window_size)
	region_rect.size = Vector2(OS.window_size.x*13, OS.window_size.x*13)/ scale.x
