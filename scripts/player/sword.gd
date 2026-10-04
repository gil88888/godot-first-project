extends Node2D

var can_attack = true 
func _process(_delta: float) -> void:
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
