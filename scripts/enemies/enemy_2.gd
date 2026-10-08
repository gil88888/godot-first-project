extends Area2D
@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("player") 
var speed: int = 100
var enemy_hp: int = 50
var enemy_hit_animation_flag: bool = true
var enemy_flipped: bool = false
var movement_cooldown_flag: bool = false
@onready var attack_class = Enemy1Attacks.new(self)
var teleporting_bullet_scene := preload("res://scenes/teleporting_bullet.tscn")
var teleporting_bullet = null
var can_contact_damage = true
func attack() -> void:
	teleporting_bullet = teleporting_bullet_scene.instantiate()
	attack_class.attack_pattern(Vector2(self.global_position.x, self.global_position.y), player.global_position , teleporting_bullet, 3000, 0, true, false, false, true, false)
	
		
func _process(_delta: float) -> void:
	# check if the teleporting bullet sending a signal to teleport
	if teleporting_bullet != null and self.get_parent().global_position != Vector2(23234234, 234234234):
		if teleporting_bullet.get_meta("position") != Vector2(1000, 0):
			teleporting_bullet.queue_free()
			print("can tp")
			can_contact_damage = false
			if self.get_parent().global_position > 	teleporting_bullet.get_meta("position"):
				self.get_parent().global_position = Vector2(teleporting_bullet.get_meta("position").x - 400, teleporting_bullet.get_meta("position").y + 350)
				
			elif self.get_parent().global_position < teleporting_bullet.get_meta("position"):
				self.get_parent().global_position = Vector2(teleporting_bullet.get_meta("position").x + 400, teleporting_bullet.get_meta("position").y + 350)
			await get_tree().create_timer(0.1).timeout
			can_contact_damage = true
	# check if the enemy is dead
	if enemy_hp <= 0:
		GlobalVariables.score_label.add_score(randi_range(200, 300))
		self.get_parent().global_position = Vector2(23234234, 234234234)
		enemy_hp = 100
		await self.get_tree().create_timer(2).timeout
		self.get_parent().queue_free()


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player") and GlobalVariables.player_invincible == false and can_contact_damage:
		Playerhp.hurt_player(randi_range(15, 30))
	if area.is_in_group("gun bullet"):
		if randi_range(1, 5) != 1:
			enemy_hp -= 10
			GlobalVariables.score_label.add_score(randi_range(5, 15))
			if enemy_hit_animation_flag:
				self.get_node("Sprite2D").modulate = Color(90, 90, 0)
				enemy_hit_animation_flag = false
				$"hit animation".start()
		else:
			var enemy_location = Vector2(self.get_parent().global_position.x, self.get_parent().global_position.y - 500)
			self.get_tree().get_first_node_in_group("teleporting enemy particles").global_position = self.get_parent().global_position
			self.get_tree().get_first_node_in_group("teleporting enemy particles").emitting = true
			self.get_parent().global_position = Vector2(100000, 100000)
			can_contact_damage = false
			await get_tree().create_timer(1).timeout
			self.get_tree().get_first_node_in_group("teleporting enemy particles").emitting = false
			if is_instance_valid(self.get_parent()):
				self.get_parent().global_position = enemy_location
			await get_tree().create_timer(0.1).timeout
			can_contact_damage = true
			
				
	elif area.is_in_group("sword"):
		if randi_range(1, 2) == 1:
			enemy_hp -= 25
			GlobalVariables.score_label.add_score(randi_range(5, 15))
			if enemy_hit_animation_flag:
				self.get_node("Sprite2D").modulate = Color(90, 90, 0)
				enemy_hit_animation_flag = false
				$"hit animation".start()
		elif randi_range(1, 2) == 1:
			enemy_hp -= 25
			GlobalVariables.score_label.add_score(randi_range(5, 15))
			if enemy_hit_animation_flag:
				self.get_node("Sprite2D").modulate = Color(90, 90, 0)
				enemy_hit_animation_flag = false
				$"hit animation".start()
			var enemy_spawn_location = 	self.get_tree().get_first_node_in_group("flying enemy spawn location")
			var size = (enemy_spawn_location.shape as RectangleShape2D).size
			var random_x = randf_range(enemy_spawn_location.global_position.x - size.x / 2,enemy_spawn_location.global_position.x + size.x / 2)
			var enemy_location = Vector2(random_x, enemy_spawn_location.global_position.y)
			self.get_tree().get_first_node_in_group("teleporting enemy particles").global_position = self.get_parent().global_position
			self.get_tree().get_first_node_in_group("teleporting enemy particles").emitting = true
			self.get_parent().global_position = Vector2(100000, 100000)
			await get_tree().create_timer(1).timeout
			can_contact_damage = false
			self.get_tree().get_first_node_in_group("teleporting enemy particles").emitting = false
			if is_instance_valid(self.get_parent()):
				self.get_parent().global_position = enemy_location
			await get_tree().create_timer(0.1).timeout
			can_contact_damage = true
		else:
			var enemy_spawn_location = 	self.get_tree().get_first_node_in_group("flying enemy spawn location")
			var size = (enemy_spawn_location.shape as RectangleShape2D).size
			var random_x = randf_range(enemy_spawn_location.global_position.x - size.x / 2,enemy_spawn_location.global_position.x + size.x / 2)
			var enemy_location = Vector2(random_x, enemy_spawn_location.global_position.y)
			self.get_tree().get_first_node_in_group("teleporting enemy particles").global_position = self.get_parent().global_position
			self.get_tree().get_first_node_in_group("teleporting enemy particles").emitting = true
			self.get_parent().global_position = Vector2(100000, 100000)
			await get_tree().create_timer(1).timeout
			can_contact_damage = false
			self.get_tree().get_first_node_in_group("teleporting enemy particles").emitting = false
			if is_instance_valid(self.get_parent()):
				self.get_parent().global_position = enemy_location
			await get_tree().create_timer(0.1).timeout
			can_contact_damage = true
			

func _on_hit_animation_timeout() -> void:
		enemy_hit_animation_flag = true
		self.get_node("Sprite2D").modulate = Color(0.91, 0.722, 0.346, 1.0)
		

		
# check if the player is in the attack range
func _on_area_attack_view_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		$"area attack view/attack_cooldown".start()

func _on_area_attack_view_area_exited(area: Area2D) -> void:
	if area.is_in_group("player"):
		$"area attack view/attack_cooldown".stop()

# on the attack cooldown end
func _on_attack_cooldown_timeout() -> void:
	if self.get_tree().get_first_node_in_group("teleporting bullet") == null:
		attack()
