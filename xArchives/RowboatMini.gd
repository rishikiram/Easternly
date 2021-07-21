extends "res://scripts/Classes/Miniship_class.gd"
export(float) var oar_force := 1.5
var is_rowing = false

onready var anim_player := $Sprite/AnimationPlayer
func _ready():
	$Sprite.frame = 0
func get_forces():
	var force_sum :float=0
	if is_rowing:
		force_sum += oar_force
	return force_sum
func row():
	if !is_rowing:
		anim_player.play("row forward")
func _on_AnimationPlayer_animation_finished(anim_name):
	match anim_name:
		"row back":
			is_rowing = false
		"row forward":
			anim_player.play("row back")
			is_rowing = true
		
	
