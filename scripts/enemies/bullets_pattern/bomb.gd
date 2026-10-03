extends Node2D

var timer_animation_counter: int = 0

func explode() -> void:
	$Sprite2D.visible = true
	$"explosion delay".start()
	self.set_meta("delete_tween", true)
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("obstacle"):
		explode()


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		Playerhp.hurt_player(40)
		explode()
 


func _on_explosion_delay_timeout() -> void:
	timer_animation_counter += 1
	$Area2D.scale += Vector2(1, 1)
	# size up for temp animation
	$Sprite2D.scale += Vector2(1, 1)
	if timer_animation_counter >= 5:
		self.queue_free()
		
