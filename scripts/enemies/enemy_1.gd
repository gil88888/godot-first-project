extends Area2D

var speed: int = 100
var enemy_gravity: float = 1500.0
var jump_power: float = 600.0
var velocity_y: float = 0.0
@onready var movement_cooldown_timer: Timer = $"movement cooldown"
var movement_cooldown_flag: bool = false
var movement_cooldown_wait_time: float = 0.0
var random_movement: int = 0
var last_random_movement: int = 0
var enemy_hp: int = 100
var enemy_hit_animation_flag: bool = true
var enemy_flipped: bool = false
var enemy_ready_to_jump = false
var enemy_ready_to_dash = false
@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("player") 
@onready var attack_class = Enemy1Attacks.new(self)
var bullet_1_scene := preload("res://scenes/bullet_1.tscn")


func attack() -> void:
	var bullet_1 = bullet_1_scene.instantiate()
	
	var bullet_x = self.global_position.x + randi_range(-500, 500)
	var bullet_y = player.global_position.y - 300
	attack_class.attack_pattern(Vector2(bullet_x, bullet_y), player.global_position , bullet_1, 1500)

#func _physics_process(delta: float) -> void:
	#velocity_y += gravity * delta
	#position.y += velocity_y * delta
	#if enemy_ready_to_jump:
		#velocity_y = -jump_power
		
func _process(delta: float) -> void:
	#attack()
	# change the sprite and dashing hitbox if the enemy flipped
	if enemy_flipped:
		$Sprite2D.flip_h = true
		$"dashing place/CollisionShape2D".position.x = -516
		$"obstacle detector/CollisionShape2D".position.x = -135
	else:
		$"dashing place/CollisionShape2D".position.x = 516
		$"obstacle detector/CollisionShape2D".position.x = 135
	# check if the enemy is dead
	if enemy_hp <= 0:
		self.queue_free()
		
	# enemy movement
	if not movement_cooldown_flag:
		# make the move
		movement_cooldown_flag = true

		while true:
			if random_movement == last_random_movement:
				random_movement = randi_range(1, 2)
			else:
				break
		last_random_movement = random_movement
		match random_movement:
			1:
				if enemy_ready_to_dash:
					movement_cooldown_wait_time = 0.25
				else:
					movement_cooldown_wait_time = 3
					random_movement = 2
			2:
				movement_cooldown_wait_time = 3
			3:
				movement_cooldown_wait_time = 0.5
			4:
				movement_cooldown_wait_time = 0.5

		movement_cooldown_timer.start()
	match random_movement:
		1:
			self.global_position.x = move_toward(self.global_position.x, player.global_position.x, 800 * delta)
		2:
			self.global_position.x = move_toward(self.global_position.x, player.global_position.x, 200 * delta)
			# check where the enemy heading
			if (player.global_position.x - self.global_position.x) > 0:
				enemy_flipped = false
			else:
				enemy_flipped = true
		3:
			self.global_position.x = move_toward(self.global_position.x, player.global_position.x, 1000 * delta)

		4:
			self.position = self.position.move_toward(Vector2(-999999, self.global_position.y), (400 * delta))


func _on_movement_cooldown_timeout() -> void:
	movement_cooldown_flag = false


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player") and GlobalVariables.player_invincible == false:
		GlobalVariables.player_hp -= 30
		PlayerInvincible.player_invincible(2)
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
		
# check if the player is in the dashing place
func _on_dashing_place_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		enemy_ready_to_dash = true
		
func _on_dashing_place_area_exited(area: Area2D) -> void:
	if area.is_in_group("player"):
		enemy_ready_to_dash = false
		
# check if there are obstacle infront the enemy
func _on_obstacle_detector_area_entered(area: Area2D) -> void:
	if area.is_in_group("obstacle"):
		enemy_ready_to_jump = true

func _on_obstacle_detector_area_exited(area: Area2D) -> void:
	if area.is_in_group("obstacle"):
		enemy_ready_to_jump = false
		
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
