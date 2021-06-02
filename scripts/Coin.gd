extends RigidBody2D

var player
export(float) var acceleration:= 100
func _ready():
	set_physics_process(false)
	$AnimatedSprite.scale = Vector2(0.5,0.5)
	$CollisionShape2D.scale = Vector2(0.5,0.5)
	$Area2D.scale = Vector2(0.5,0.5)
func _physics_process(delta):
	applied_force = (player.global_position - global_position).normalized() * acceleration


func _on_Coin_body_entered(body):
	if body.is_in_group("Player"):
		PlayerVariables.coins += 1
		var hud = $"/root/Node/CanvasLayer/HUD"
		if hud != null:
			hud.update_coins()
		queue_free()


func _on_Area2D_body_entered(body):
	if body.is_in_group("Player"):
		player = body
		set_physics_process(true)


func _on_Area2D_body_exited(body):
	if body.is_in_group("Player"):
		player = null
		applied_force = Vector2(0,0)
		set_physics_process(false)
