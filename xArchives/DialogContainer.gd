extends MarginContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
var min_height = 65
var min_width = 65
var text:String
var font_height
onready var rtl = $MarginContainer/RichTextLabel
onready var mc = $MarginContainer
func _ready():
	font_height = rtl.get_font("normal_font").get_height()
#	print(font_height)
	text = rtl.text
	
	var length = rtl.get_font("normal_font").get_string_size(text)
#	print('l= ',length)
	var height = 17*((int(length.x) / 150)+1) 
#	print('h= ',height)

	rect_size = Vector2(150,height+22)

