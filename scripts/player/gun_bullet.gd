extends Sprite2D

var bullet_direction := Vector2.ZERO
var bullet_speed := 3000
var bullet_rotation := 0
func _process(delta):
	self.position += (bullet_direction * bullet_speed * delta) 
	self.rotation = bullet_direction.angle()
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("block bullet"):
		self.queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
		self.queue_free()
