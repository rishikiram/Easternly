extends Camera2D

export(NodePath) var player_path
var player

func _ready():
	if player_path == "" or get_node(player_path) == null:
		print("Camera needs a player!")
	player = get_node(player_path)
	get_tree().get_root().connect("size_changed", self, "on_window_resize")
	on_window_resize()
func on_window_resize():
	if OS.window_size == Vector2(1440, 900):
		zoom = Vector2(.5,.5)
	else:
		zoom = Vector2(.75,.75)
#		$Top.position = 


func _physics_process(delta):
	position.x = player.global_position.x
#	if Input.is_action_just_pressed("shift"):
#		if zoom == Vector2(1,1):
#			zoom = Vector2(.5,.5)
#		else:
#			zoom = Vector2(1,1)




func _on_Top_body_entered(body):
	if body.is_in_group("miniship"):
		body.position = Vector2(body.position.x, -body.position.y - 5)

func _on_Bottom_body_entered(body):
	if body.is_in_group("miniship"):
		body.position = Vector2(body.position.x, -body.position.y + 5)
