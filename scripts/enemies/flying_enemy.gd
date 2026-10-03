extends Area2D
var speed: int = 200
var enemy_hp: int = 200
var move_to: String
var enemy_hit_animation_flag = true
@onready var attack_class = Enemy1Attacks.new(self)
var bomb_scene := preload("res://scenes/bomb.tscn") 
var bomb_tween: Tween
var bomb
func attack() -> void:
	bomb = bomb_scene.instantiate()
	var bomb_x = self.global_position.x
	var bomb_y = self.global_position.y + 50
	bomb_tween = await attack_class.attack_pattern(Vector2(bomb_x, bomb_y), Vector2(bomb_x, (bomb_y)) , bomb, 500, 0, false, true)

func _ready() -> void:
	if randi_range(1, 2) == 1:
		move_to = "right"
	else:
		move_to = "left"

func _process(delta: float) -> void:
	if self.global_position.x >= 3100:
		move_to = "left"
	elif self.global_position.x <= -3100:	
		move_to = "right" 
	if move_to == "right":
		self.global_position.x = move_toward(self.global_position.x, 3100, speed * delta)
	elif move_to == "left":
		self.global_position.x = move_toward(self.global_position.x, -3100, speed * delta)
		
	# check if the enemy is dead
	if enemy_hp <= 0:
		GlobalVariables.score_label.add_score(randi_range(150, 250))
		self.global_position = Vector2(23234234, 234234234)
		enemy_hp = 100
		await self.get_tree().create_timer(2).timeout
		self.queue_free()
	if bomb != null and bomb.has_meta("delete_tween"):
		if bomb.get_meta("delete_tween"):
			bomb_tween.kill()
			
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player") and GlobalVariables.player_invincible == false:
		Playerhp.hurt_player(10)
	if area.is_in_group("gun bullet"):
		enemy_hp -= 10
		GlobalVariables.score_label.add_score(randi_range(1, 10))
		if enemy_hit_animation_flag:
			self.get_node("Sprite2D").modulate = Color(90, 90, 0)
			enemy_hit_animation_flag = false
			$"hit animation".start()
	if area.is_in_group("sword"):
		enemy_hp -= 30
		GlobalVariables.score_label.add_score(randi_range(40, 60))
		if enemy_hit_animation_flag:
			self.get_node("Sprite2D").modulate = Color(90, 90, 0)
			enemy_hit_animation_flag = false
			$"hit animation".start()


func _on_hit_animation_timeout() -> void:
	enemy_hit_animation_flag = true
	self.get_node("Sprite2D").modulate = Color(255, 255, 255)


func _on_attack_cooldown_timeout() -> void:
	attack()
	$"attack cooldown".start()
