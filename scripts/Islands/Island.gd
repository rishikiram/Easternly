extends Node2D
var seen := false
func _ready():
	$VisibilityNotifier2D.connect("screen_entered",self,"_on_VisibilityNotifier2D_screen_entered")
	$VisibilityNotifier2D.connect("screen_exited",self,"_on_VisibilityNotifier2D_screen_exited")
func _on_VisibilityNotifier2D_screen_entered():
	seen = true
func _on_VisibilityNotifier2D_screen_exited():
	if seen:
		queue_free()
