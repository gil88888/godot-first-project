extends AnimatedSprite2D

func _ready() -> void:
	var tween = self.create_tween()
	tween.set_loops()
	tween.tween_property(self, "position:y", 5, 0.7)
	tween.tween_property(self, "position:y", -5, 0.7)
	$"../despawn timer".start()
	
func _on_animation_finished() -> void:
	await self.get_tree().create_timer(1).timeout
	self.play()


func _on_despawn_timer_timeout() -> void:
	self.get_parent().queue_free()
	print("healing potion deleted")
