extends Control

export(int) var vertical_margin_total = 22
export(String) var text 
var flipped := false
var max_width
#var text:String

onready var rtl = $MarginContainer/RichTextLabel
onready var mc = $MarginContainer

#func _process(delta):
#	if Input.is_action_just_pressed("space"):
#		visible = true
#

func _ready():
	if flipped:
		$NinePatchRect.texture = preload("res://art/GUI/DialogBoxX.png")
	set_and_fit_text(text)
#	font_height = rtl.get_font("normal_font").get_height()
#	print(font_height)
#	text = rtl.text
#	var length = rtl.get_font("normal_font").get_string_size(text)
#	print('l= ',length)
#
#	var height = length.y *((int(length.x) / 200)+1) 
#	print('h= ',height)
#
#	rect_size = Vector2(250,height+vertical_margin_total)
func set_and_fit_text(string):
	text = string
	if text != null and text != "":
		rtl.text = text
	return fit_to_text()
func fit_to_text():
	var length = rtl.get_font("normal_font").get_string_size(rtl.text)
	var height = (length.y+1) *((int(length.x) / 200)+1) 
#	print('h= ',height)

	if length.x <= 220:
		rect_size = Vector2(length.x+30, 26+vertical_margin_total)
		return Vector2(length.x+30, 26+vertical_margin_total)
	rect_size = Vector2(250,height+vertical_margin_total)
	return Vector2(250,height+vertical_margin_total)
