extends Node2D

var can_attack = true 
func _process(_delta: float) -> void:
	# change the place that the sword is facing to if the attack ended
	if $"reload timer".is_stopped():
		if get_global_mouse_position().x > $"..".global_position.x:
			$Sprite2D.position.x = 221
			$Sprite2D.flip_h = false
			$hitbox.position.x = 221
		elif get_global_mouse_position().x < $"..".global_position.x:		
			$Sprite2D.position.x = -221
			$Sprite2D.flip_h = true
			$hitbox.position.x = -221
	if can_attack:
		self.visible = false
		$hitbox/CollisionShape2D.disabled = true
	if Input.is_action_just_pressed("slash") and can_attack:
		attack()


func attack() -> void:
	print("sword attack")
	self.visible = true
	$hitbox/CollisionShape2D.disabled = false
	can_attack = false
	$"reload timer".start()
	
	

func _on_reload_timer_timeout() -> void:
	can_attack = true
