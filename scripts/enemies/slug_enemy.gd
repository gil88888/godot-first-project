extends CharacterBody2D

@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("player") 
const speed: int = 300
var gravity: int = 0
var slug_hp: int = 50
var player_location: String = "right"
var player_current_position: Vector2
var can_move: bool = true
var in_floor: bool = true
var shocked: bool = false
@onready var invincibility_timer: Timer = $"invincibilty timer"
@onready var slug_animation: AnimatedSprite2D = $slug_animation

func _physics_process(delta: float) -> void:
	# check if the enemy is shocked
	if shocked:
		slug_animation.modulate = modulate.darkened(-0.5)
	else:
		slug_animation.modulate = modulate.darkened(0)
	# make the enemy unable to collide with other enemies
	for i in get_tree().get_nodes_in_group("physic enemies"):
		add_collision_exception_with(i)

	# check if the slug is dead
	if slug_hp <= 0:
		GlobalVariables.score_label.add_score(randi_range(50, 100))
		self.queue_free()

	if not in_floor:
		# if the enemy not on floor make it fall
		if not is_on_floor():
			velocity.y += gravity * delta
		# move the slug to the player location
		if can_move and not shocked:
			global_position.x = move_toward(global_position.x, player_current_position.x, speed * delta)
		
		# if the slug reached the current player position, switch to the other side
		if global_position.x == player_current_position.x:
			if player_location == "right":
				player_location = "left"
				player_current_position.x += 300
			else:
				player_location = "right"
				player_current_position.x -= 300
		# change the slug sprite to the side it heading
		if player_location == "right":
			slug_animation.flip_h = false
		else:
			slug_animation.flip_h = true

	move_and_slide()

func _on_check_player_position_timeout() -> void:
	# check where the player supposed to be
	if player.global_position.x - self.global_position.x < 0:
		player_location = "right"
	else:
		player_location = "left"
	player_current_position = player.global_position

func _on_animation_timer_timeout() -> void:
	slug_animation.play()

func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("gun bullet"):
		if invincibility_timer.is_stopped():
			hurt_slug(area.get_parent().get_meta("bullet_damage"))
			GlobalVariables.score_label.add_score(randi_range(5, 10))
	if area.is_in_group("sword"):
		if invincibility_timer.is_stopped():
			hurt_slug(10)
			GlobalVariables.score_label.add_score(randi_range(1, 5))
	if area.is_in_group("player"):
		Playerhp.hurt_player(randi_range(10, 25), 1.5)
	if area.is_in_group("fly"):
		shocked = true
		await get_tree().create_timer(3, false).timeout
		shocked = false
func invincibility_animation() -> void:
	for i in range(10):
		if i % 2 == 0:
			slug_animation.visible = false
		else:
			slug_animation.visible = true
		await get_tree().create_timer(0.1, false).timeout
	slug_animation.visible = true

func hurt_slug(damage) -> void:
	slug_hp -= damage
	slug_animation.play("hurt")
	can_move = false
	invincibility_timer.start()
	await get_tree().create_timer(0.5, false).timeout
	invincibility_animation()
	slug_animation.play("moving")
	can_move = true


func _on_slug_animation_animation_finished() -> void:
	in_floor = false
	gravity = 1000
	slug_animation.animation = "moving"
	$hitbox/CollisionShape2D.disabled = false
	if player.global_position.x - self.global_position.x < 0:
		player_location = "right"
	else:
		player_location = "left"
	player_current_position = player.global_position
