extends Sprite2D

var bullet_direction := Vector2.ZERO
var bullet_speed := 3000
var bullet_rotation := 0

func _ready() -> void:
	if GlobalVariables.abilities.get("ranged_attack"):
		set_meta("bullet_damage", 5)

func _process(delta):
	self.position += (bullet_direction * bullet_speed * delta) 
	self.rotation = bullet_direction.angle()
	$Label.text = str(get_meta("bullet_damage"))
	if GlobalVariables.abilities.get("ranged_attack"):
		set_meta("bullet_damage", minf(
			get_meta("bullet_damage") + 45.0 * delta,
			30.0
		))

# delete the bullet if it hit something
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("block bullet"):
		print(get_meta("bullet_damage"))
		self.queue_free()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("block bullet"):
		print(get_meta("bullet_damage"))
		if GlobalVariables.abilities.get("piercing_plus"):
			set_meta("bullet_damage", get_meta("bullet_damage") * 1.5)
			self.scale.y = 1.5
		elif GlobalVariables.abilities.get("piercing"):
			set_meta("bullet_damage", get_meta("bullet_damage") / 2)
			self.scale.y = 0.5
		else:
			self.queue_free()


# delete bullet out of screen
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	self.queue_free()
