extends CharacterBody2D

var gravity = 1000
var jump_power = 1000
var enemy_flipped: bool = false
var movement_cooldown_flag: bool = false
var movement_cooldown_wait_time: float = 0.0
var random_movement: int = 0
var last_random_movement: int = 0
var enemy_ready_to_dash = false
var super_dash = false
var enemy_ready_to_jump = false
@onready var movement_cooldown_timer: Timer = $"enemy_1/movement cooldown"
@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("player") 

func _process(delta: float) -> void:
	# change the sprite and dashing hitbox if the enemy flipped
	#self.global_position.x =  $enemy_1.global_position.x
	if enemy_flipped:
		$enemy_1/Sprite2D.flip_h = true
		$"enemy_1/dashing place".position.x = -516
		$"enemy_1/obstacle detector".position.x = -135
	else:
		$"enemy_1/dashing place".position.x = 516
		$"enemy_1/obstacle detector".position.x = 135
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
					#if super_dash:
						#movement_cooldown_wait_time = 0
						#super_dash = false
					#else:
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

		movement_cooldown_timer.wait_time = movement_cooldown_wait_time
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
func _physics_process(delta: float) -> void:
	if not self.is_on_floor():
		velocity.y += gravity * delta * 1.5
		self.global_position.x = move_toward(self.global_position.x, player.global_position.x, 800 * delta)
	velocity.y += gravity * delta
	position.y += velocity.y * delta
	if self.is_on_floor():
		if enemy_ready_to_jump:
			velocity.y = -jump_power
	move_and_slide()
 
# check if there are obstacle infront the enemyג
func _on_obstacle_detector_area_entered(area: Area2D) -> void:
	if area.is_in_group("obstacle"):
		enemy_ready_to_jump = true
		super_dash = true
		enemy_ready_to_dash = true

func _on_obstacle_detector_area_exited(area: Area2D) -> void:
	if area.is_in_group("obstacle"):
		enemy_ready_to_jump = false


# check if the player is in the dashing place
func _on_dashing_place_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		enemy_ready_to_dash = true
		
func _on_dashing_place_area_exited(area: Area2D) -> void:
	if area.is_in_group("player"):
		enemy_ready_to_dash = false


func _on_movement_cooldown_timeout() -> void:
	movement_cooldown_flag = false
