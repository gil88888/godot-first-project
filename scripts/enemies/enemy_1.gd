extends Area2D
@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("player") 
var speed: int = 100
var enemy_hp: int = 200
var enemy_hit_animation_flag: bool = true
var enemy_flipped: bool = false
var movement_cooldown_flag: bool = false
@onready var attack_class = EnemyAttacks.new(self)
var bullet_1_scene := preload("res://scenes/bullet_1.tscn")

func attack() -> void:
	var bullet_1 = bullet_1_scene.instantiate()
	var bullet_x = self.global_position.x + randi_range(-500, 500)
	var bullet_y = player.global_position.y + randi_range(-600, -800)
	
	if randi_range(1, 10) == 1:
		attack_class.attack_pattern(Vector2(player.global_position.x, player.global_position.y - 500), player.global_position, bullet_1, 8000, 1, false, true, true, false, true)
	else:
		attack_class.attack_pattern(Vector2(bullet_x, bullet_y), player.global_position , bullet_1, 1500, 0.5, true, true, true)															
	
		
func _process(_delta: float) -> void:
	# check if the enemy is dead
	if enemy_hp <= 0:
		GlobalVariables.score_label.add_score(randi_range(100, 200))
		self.get_parent().global_position = Vector2(23234234, 234234234)
		enemy_hp = 100
		await self.get_tree().create_timer(2).timeout
		self.get_parent().queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player damage collision") and GlobalVariables.player_invincible == false:
		Playerhp.hurt_player(25)
	if area.is_in_group("gun bullet"):
		print(area)
		enemy_hp -= area.get_parent().get_meta("bullet_damage")
		GlobalVariables.score_label.add_score(randi_range(5, 15))
		if enemy_hit_animation_flag:
			self.get_node("Sprite2D").modulate = Color(90, 90, 0)
			enemy_hit_animation_flag = false
			$"hit animation".start()
	if area.is_in_group("sword"):
		enemy_hp -= 15
		GlobalVariables.score_label.add_score(randi_range(50, 70))
		if enemy_hit_animation_flag:
			self.get_node("Sprite2D").modulate = Color(90, 90, 0)
			enemy_hit_animation_flag = false
			$"hit animation".start()
			

func _on_hit_animation_timeout() -> void:
		enemy_hit_animation_flag = true
		self.get_node("Sprite2D").modulate = Color(253, 0, 0)
		

		
# check if the player is in the attack range
func _on_area_attack_view_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		$"area attack view/attack_cooldown".start()

func _on_area_attack_view_area_exited(area: Area2D) -> void:
	if area.is_in_group("player"):
		$"area attack view/attack_cooldown".stop()

# on the attack cooldown end
func _on_attack_cooldown_timeout() -> void:
	attack()
