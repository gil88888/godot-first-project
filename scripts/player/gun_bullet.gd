extends Sprite2D

var direction := Vector2.ZERO
var speed := 3000

func _process(delta):
	position += direction * speed * delta


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("block bullet"):
		self.queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
		self.queue_free()
