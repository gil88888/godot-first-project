extends CharacterBody2D

const speed = 800.0
var current_speed = speed
const super_jump_power = -1000
var enemy_hp: int = 500 
var gravity: int = 1500
var can_move: bool = true
var player_current_position: Vector2
var player_location: String = "right"
var attacking: bool = false
var bullet: Node2D = null
var in_attack_range: bool = false
var bullet_spawn_locations_left: Array = [Vector2(-200, 100), Vector2(-200, 300), Vector2(-200, 500), Vector2(-200, 700), Vector2(-200, 900)]
var bullet_spawn_locations_right: Array = [Vector2(200, 100), Vector2(200, 300), Vector2(200, 500), Vector2(200, 700), Vector2(200, 900)]
var bullet_spawn_locations_down: Array = [Vector2(100, -100), Vector2(0, -100), Vector2(-100, -100)]
@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("player")
@onready var enemy_animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_class = EnemyAttacks.new(self)
@onready var attack_area: Sprite2D = $"attack area"
@onready var attack_cooldown_timer: Timer = $"attack cooldown"
var bullet_1_scene = preload("res://scenes/bullet_1.tscn")
var bullet_2_scene = preload("res://scenes/bullet_2.tscn")
var attack_area_scene = preload("res://scenes/attack_area.tscn")
var flying: bool = false
var player_position: Vector2
var flying_movement_animation_checker: int = 0
var flying_animation_flag: bool = true
var player_is_in_sky_detector: bool = false
var slide: bool = false
func attack_up(area):
	var bullet_2 = bullet_2_scene.instantiate()
	var tween: Tween = bullet_2.create_tween()
	get_tree().current_scene.add_child(bullet_2)
	bullet_2.global_position = self.global_position
	await tween.tween_property(bullet_2, "global_position:y", bullet_2.global_position.y + 200, 0.1).finished
	await get_tree().create_timer(0.2).timeout
	bullet_2.get_node("AnimatedSprite2D").play()
	await attack_class.attack_pattern(bullet_2.global_position, Vector2(bullet_2.global_position.x, -10200), bullet_2, 3000, 0, true, true, false, false, true, false, false, true)
	bullet_2.queue_free()
	if is_instance_valid(area):
		area.queue_free()


func flying_animation():
	flying_animation_flag = false
	if flying_movement_animation_checker % 2 == 0:
		velocity.y -= 20
	else:
		velocity.y += 20
	flying_movement_animation_checker += 1
	await get_tree().create_timer(0.1).timeout
	flying_animation_flag = true
	
func jump_attack():
	player_position = player.global_position
	attacking = true
	velocity.y = super_jump_power - global_position.y
func attack():
	flying = true
	attacking = false
	can_move = false
	velocity.y = 0
	gravity = 0
	# attack
	print_rich("[color=green]" + str(player_position))
	for i in range(4):
		bullet = bullet_1_scene.instantiate()
		var tween: Tween = bullet.create_tween()
		get_tree().current_scene.add_child(bullet)
		bullet.global_position = self.global_position
		bullet.set_meta("damage", 50)
		if player_location == "right":
			await tween.tween_property(bullet, "global_position", self.global_position - bullet_spawn_locations_right[i], 0.25).finished
		else:
			await tween.tween_property(bullet, "global_position", self.global_position - bullet_spawn_locations_left[i], 0.25).finished
		attack_class.attack_pattern(bullet.global_position, player_position, bullet, 2000, 1 - (i * 0.25), true, true, true, true, true, false)
	attack_area.visible = true
	if randi_range(1, 2) == 1:
		await get_tree().create_timer(0.5).timeout
		for i in bullet_spawn_locations_down:
			bullet = bullet_1_scene.instantiate()
			get_tree().current_scene.add_child(bullet)
			await rotate_bullet(bullet.get_node("Sprite2D"), i)
			bullet.global_position = global_position - i
			print_rich("[color=red]", global_position - i)
			print_rich("[color=orange]", bullet.position)
			var target_place: Vector2
			var list_index = bullet_spawn_locations_down.find(i)
			var move_x = true
			if list_index == 0:
				target_place = Vector2(-100000000, -1000)
				move_x = true
			elif list_index == 1:
				target_place = Vector2(0, -1000)
				move_x = false
			else:
				target_place = Vector2(1000000, -1000)
				move_x = true
			attack_class.attack_pattern(bullet.global_position, target_place, bullet, 1500, 0.5, true, true, false, move_x, true, false, true)
	flying = false
	can_move = true
	velocity.y = 2000
func rotate_bullet(bullet_to_rotate: Sprite2D, rotate_position):
	bullet_to_rotate.rotation = bullet_to_rotate.global_position.angle_to_point(rotate_position)
	bullet_to_rotate.flip_h = true
	bullet_to_rotate.flip_v = true

func _physics_process(delta: float) -> void:
	if slide and not get_meta("shocked"):
		slide = false
		set_collision_mask_value(2, false)
		await get_tree().create_timer(0.2).timeout
		set_collision_mask_value(2, true)
		
	# make the attack area be the size from the enemy to the ground
	var size = global_position.y - 449
	attack_area.scale.y = size / attack_area.texture.get_size().y
	attack_area.position.y = -(size / 2) + 64
	
	# make the enemy unable to collide with other enemies
	for i in get_tree().get_nodes_in_group("physic enemies"):
		add_collision_exception_with(i)
		
	# check if the enemy is shocked
	if get_meta("shocked"):
		enemy_animation.modulate = modulate.darkened(-0.5)
	else:
		enemy_animation.modulate = modulate.darkened(0)
	if enemy_hp <= 0:
		GlobalVariables.score_label.add_score(randi_range(150, 300))
		global_position = Vector2(23234234, 234234234)
		enemy_hp = 100
		await self.get_tree().create_timer(2).timeout
		queue_free()
	# check if the enemy not mid attack
	if flying:
		if flying_animation_flag:
			flying_animation()
		
	elif not is_on_floor():
		velocity += get_gravity() * delta
	else:
		attack_area.visible = false
	if can_move and not get_meta("shocked"):
		if randi_range(1, 600) == 1:
			global_position.x = move_toward(global_position.x, player_current_position.x, (current_speed * 4) * delta)
		else:
			global_position.x = move_toward(global_position.x, player_current_position.x, current_speed * delta)
	
	# if the slug reached the current player position, switch to the other side
	if global_position.x == player_current_position.x:
		if player_location == "right":
			if not attacking:
				player_location = "left"
			player_current_position.x += 300
		else:
			if not attacking:
				player_location = "right"
			player_current_position.x -= 300
	# change the slug sprite to the side it heading
	if player_location == "right":
		enemy_animation.flip_h = false
	else:
		enemy_animation.flip_h = true
	if attacking and velocity.y >= 0:
		gravity = 0
		velocity.y = 0
		attack()
	move_and_slide()

func _on_check_player_position_timeout() -> void:
	# check where the player supposed to be
	if not attacking:
		if player.global_position.x - self.global_position.x < 0:
			player_location = "right"
		else:
			player_location = "left"
		player_current_position = player.global_position


func _on_attack_cooldown_timeout() -> void:
	if not attacking and velocity.y == 0 and is_on_floor() and global_position.y > -750 and not get_meta("shocked") and not player_is_in_sky_detector:
		if not in_attack_range:
			if randf_range(1, 2) == 1:
				jump_attack()
		else:
			jump_attack()


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("gun bullet"):
		enemy_hp -= area.get_parent().get_meta("bullet_damage")
		GlobalVariables.score_label.add_score(randi_range(20, 50))
	if area.is_in_group("sword"):
		enemy_hp -= 10
		GlobalVariables.score_label.add_score(randi_range(20, 60))
	if area.is_in_group("player"):
		Playerhp.hurt_player(randi_range(10, 20), 2)
	if area.is_in_group("fly"):
		set_meta("shocked", true)
		await get_tree().create_timer(3).timeout
		set_meta("shocked", false)
		flying = false # beta


func _on_jump_attck_disabled_range_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		in_attack_range = true
		current_speed = 400

func _on_jump_attck_disabled_range_area_exited(area: Area2D) -> void:
	if area.is_in_group("player"):
		in_attack_range = false
		current_speed = speed
		
func _on_sky_detector_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		player_is_in_sky_detector = true

func _on_sky_detector_area_exited(area: Area2D) -> void:
	if area.is_in_group("player"):
		player_is_in_sky_detector = false


func _on_attack_up_cooldown_timeout() -> void:
	if player_is_in_sky_detector:
		var attack_area_2: Sprite2D = attack_area_scene.instantiate()
		add_child(attack_area_2)
		attack_area_2.scale = Vector2(2, 20)
		attack_area_2.position.y = -705
		await get_tree().create_timer(0.5).timeout
		can_move = false
		for i in range(10):
			attack_up(attack_area_2)
			await get_tree().create_timer(0.01).timeout
		can_move = true


func _on_sliding_timer_timeout() -> void:
	if global_position.y < player.global_position.y:
		slide = true
		await get_tree().create_timer(0.1).timeout
		slide = false
