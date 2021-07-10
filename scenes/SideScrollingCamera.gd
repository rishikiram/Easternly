extends Camera2D

export(NodePath) var player_path
var player

func _ready():
	if player_path == "" or get_node(player_path) == null:
		print("Camera needs a player!")
	player = get_node(player_path)

func _physics_process(delta):
	position.x = player.global_position.x
	if Input.is_action_just_pressed("shift"):
		if zoom == Vector2(1,1):
			zoom = Vector2(.5,.5)
		else:
			zoom = Vector2(1,1)
