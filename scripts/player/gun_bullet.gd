extends Sprite2D

var bullet_direction := Vector2.ZERO
var bullet_speed := 3000
var bullet_rotation := 0
var enemies_pierced: int = 0
@onready var hit_sfx: AudioStreamPlayer = self.get_tree().get_first_node_in_group("bullet_hit_sfx")
func _ready() -> void:
	if GlobalVariables.abilities.get("ranged_attack"):
		set_meta("bullet_damage", 5)

func _process(delta):
	self.get_parent().global_position += (bullet_direction * bullet_speed * delta) 
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
		self.global_position = Vector2(390329423904, 9234823490)
		hit_sfx.pitch_scale = randf_range(0.5, 1.5)
		hit_sfx.play()
		self.queue_free()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("block bullet"):
		$"../teleporting enemy particles".emitting = true
		enemies_pierced += 1
		hit_sfx.pitch_scale = randf_range(0.75, 1.25)
		hit_sfx.play()
		print(get_meta("bullet_damage"))
		if GlobalVariables.abilities.get("piercing_plus") and enemies_pierced <= 3:
			if enemies_pierced == 0:
				set_meta("bullet_damage", get_meta("bullet_damage") * 1.5)
				self.scale.y += 1.5
		elif GlobalVariables.abilities.get("piercing") and enemies_pierced <= 3:
			set_meta("bullet_damage", get_meta("bullet_damage") / 2)
			self.scale.y -= 0.5
		else:
			
			self.queue_free()


# delete bullet out of screen
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	await get_tree().create_timer(3).timeout
	self.queue_free()
