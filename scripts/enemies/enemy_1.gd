extends Area2D

var speed: int = 100
var jump_power: int = 300
@onready var movement_cooldown_timer: Timer = $"movement cooldown"
var movement_cooldown_flag: bool = false
var movement_cooldown_wait_time: float = 0.0
var random_num: int = 0
var enemy_hp: int = 100
@onready var invincible_time_func = $"../../obstacles/player_invincible"
var enemy_hit_animation_flag: bool = true

func _process(delta: float) -> void:
	# check if the enemy is dead
	if enemy_hp <= 0:
		self.queue_free()
		
	# enemy movement
	if not movement_cooldown_flag:
		# make the move
		movement_cooldown_flag = true
		# check the number for the movement cooldown
		random_num = randi_range(1, 5)
		match random_num:
			1:
				movement_cooldown_wait_time = 1
			2:
				movement_cooldown_wait_time = 1
			3:
				movement_cooldown_wait_time = 0.5
			4:
				movement_cooldown_wait_time = 0.5

		movement_cooldown_timer.start()
	match random_num:
		1:
			self.global_position.x += 1
		2:
			self.global_position.x -= 1
		3:
			self.position = self.position.move_toward(Vector2(999999, self.global_position.y), (400 * delta))
		4:
			self.position = self.position.move_toward(Vector2(-999999, global_position.y), (400 * delta))


func _on_movement_cooldown_timeout() -> void:
	movement_cooldown_flag = false


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player") and GlobalVariables.player_invincible == false:
		GlobalVariables.player_hp -= 30
		invincible_time_func.player_invincible(2)
		print(GlobalVariables.player_hp)
	if area.is_in_group("gun bullet"):
		enemy_hp -= 10
		if enemy_hit_animation_flag:
			self.get_node("Sprite2D").modulate = Color(90, 90, 0)
			enemy_hit_animation_flag = false
			$"hit animation".start()
			

func _on_hit_animation_timeout() -> void:
		enemy_hit_animation_flag = true
		self.get_node("Sprite2D").modulate = Color(253, 0, 0)
