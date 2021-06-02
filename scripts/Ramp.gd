extends Sprite


export(bool) var docked = false
func _ready():
	update_ramp()

func update_ramp():
	if docked:
		set_Rail(false)
		set_Ramp(true)
	if not docked:
		set_Ramp(false)
		set_Rail(true)
		
func set_Ramp(b:bool):
	visible = b
	if b:
		$Room.enable()
	else: 
		$Room.disable()
	$"Ship Entrance".monitoring = b
	$"Ship Exit".monitoring = b
	$"Stair".monitoring = b
	
func set_Rail(b:bool):
	$Rail.set_collision_layer_bit(2,b)
	$Rail.set_collision_mask_bit(2,b)
	$Rail.set_collision_layer_bit(3,b)
	$Rail.set_collision_mask_bit(3,b)
