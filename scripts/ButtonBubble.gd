extends Control


func _ready():
	rect_size = $DialogBubble.fit_to_text() #+ Vector2(28,0)
	$DialogBubble.rect_size = rect_size
func set_and_fit_text(st):
	rect_size = $DialogBubble.set_and_fit_text(st)
	$DialogBubble.rect_size = rect_size
#	rect_size = $DialogBubble.set_and_fit_text(st)
#	print(self, rect_size, $DialogBubble.set_and_fit_text(st))
#func fit_to_text():
#	$DialogBubble.fit_to_text()
func get_text()-> String:
	return $DialogBubble.text
#func _process(delta):
#	if Input.is_action_just_pressed("space"):
#		print(self, $DialogBubble.text, rect_size)
#	if Input.is_action_just_pressed("e"):
#		print($DialogBubble.rect_size)
#	if Input.is_action_just_pressed("a"):
#		rect_size = $DialogBubble.fit_to_text()

