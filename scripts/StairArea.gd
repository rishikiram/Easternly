extends Area2D

export(float) var angle = -30

#onready var player = get_node("../../../YSort/KinematicBody2D")

#signal on_stair(angle)
#signal off_stair

func _ready():
	self.connect("body_entered", self, "_on_Stair_body_entered")
	self.connect("body_exited", self, "_on_Stair_body_exited")
	
#	self.connect("on_stair", player, "_on_Stair_on_stair")
#	self.connect("off_stair", player, "_on_Stair_off_stair")

func _on_Stair_body_entered(body):
	if body.is_in_group("Player"):
		if body.global_position.y > get_parent().global_position.y:
			body.horizontal_movment_angle =  angle
#			print("changed player dir")
func _on_Stair_body_exited(body):
	if body.is_in_group("Player"):
		body.horizontal_movment_angle =  0
#		print("reset player dir")

#func _on_Room_player_entered():
#	monitoring = false
#func _on_Room_player_exited():
#	monitoring = true


