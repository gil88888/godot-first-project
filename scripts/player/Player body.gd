extends CharacterBody2D
var speed: int = 1000 # 200
var running_speed: int = 1400
var dash_speed: int = 6500
var current_speed: int = speed
var gravity: float = 1500 # 1500
var jump_power: int = 1700 # 1300
var running_flag: bool = true
var jump_buffer_time: float = 0.1
var jump_buffer_timer: float = 0.0
var coyote_time: float = 0.10
var coyote_timer: float = 0.0
var invinicible_animation_flag: bool = true
var can_jump: bool = false
var can_dash: bool = true
var last_place_moved: String = "right"
var player_dashing: bool = false
var player_can_spring_jump: bool = false
var push_player: String = "no"
var push_speed: float
var can_stop_velocity: bool = true
var velocity_stopped: bool = false
var dashing_ProgressBar_animation_flag: bool = true
var ghost_mode_enabled: bool = false
var player_current_position = null
var active_player_variable_jump = true
var body_platform_list = []
@onready var animation_timer: Timer = $"invincible animation"
@onready var player_area: Area2D = $"Player area2d collision"
@onready var dashing_timer: Timer = $"dashing timer"
@onready var dash_meter: TextureProgressBar = $"../../Ui Layer/UI/TextureProgressBar"
func _physics_process(delta):
	# disable movement if the player cant move
	if not GlobalVariables.player_can_move:
		velocity.x = 0
		velocity.y = 0
		coyote_timer = 0
		
	# make the player fall if not on floor or stopping velocity
	if not self.is_on_floor():
		if not velocity_stopped:
			velocity.y += gravity * delta * 2
	# Variable jump height
	if Input.is_action_just_released("jump") and velocity.y < 0 and active_player_variable_jump:
		velocity.y *= 0.25
		
	# check if the player being pushed from the borders
	if push_player == "minus":
		if abs(-1.2 * push_speed) < 3000:
			self.velocity.x = -1.2 * push_speed
		else:
			self.velocity.x = -3000
	elif push_player == "plus":
		if abs(-1.2 * push_speed) < 3000:
			
			self.velocity.x = +1.2 * push_speed
		else:
			self.velocity.x = +3000
			
		
	# movement and dashing
	if GlobalVariables.player_can_move:
		if player_dashing:
			if last_place_moved == "right":
				self.velocity.x = dash_speed
			else:
				self.velocity.x = -dash_speed
		else:	
			if Input.is_action_pressed("move_right"):
				velocity.x = current_speed
				last_place_moved = "right"
			elif Input.is_action_pressed("move_left"):
				last_place_moved = "left"
				velocity.x = -current_speed
			else:
				velocity.x = 0
	if is_on_floor() or ghost_mode_enabled:
		active_player_variable_jump = true
		coyote_timer = coyote_time
		if push_player != "no":
			push_player = "no"
			velocity.x = 0
	else:
		coyote_timer -= delta
	can_jump = coyote_timer > 0
	
	if Input.is_action_just_pressed("jump"):
		jump_buffer_timer = jump_buffer_time

	if jump_buffer_timer > 0:
		jump_buffer_timer -= delta
	# check jump
	if GlobalVariables.player_can_move:
		if jump_buffer_timer > 0 and can_jump:
			velocity.y = - jump_power
			coyote_timer = 0
			jump_buffer_timer = 0
	# check if shift is pressed to make the player run
	if GlobalVariables.player_can_move:
		if Input.is_action_pressed("run") and running_flag and self.is_on_floor():
			current_speed += (running_speed - speed)
			running_flag = false
		elif not velocity_stopped:
			#current_speed -= (running_speed - speed)
			current_speed = speed
			running_flag = true
	# check jumping options that is not regular jump
	if GlobalVariables.player_can_move:
		if Input.is_action_just_pressed("jump") and player_area.in_jump_block and player_area.jump_block.jump_block_disabled == false:
			self.velocity.y = player_area.jump_block.velocity_y
			active_player_variable_jump = false
		if player_can_spring_jump and Input.is_action_just_pressed("jump"):
			self.velocity.y -= 1500
			player_can_spring_jump = false
		elif player_can_spring_jump:
			player_can_spring_jump = false
			self.velocity.y -= 1250
		
	# check if the player can dash
	if Input.is_action_just_pressed("dash") and can_dash and GlobalVariables.player_can_move:
		if GlobalVariables.abilities.get("dash"):
			dash()
	# if cant because of the loading time make the dashing progress bar red
	elif Input.is_action_just_pressed("dash") and GlobalVariables.player_can_move and dashing_ProgressBar_animation_flag:
		dashing_ProgressBar_animation_flag = false
		for i in range(8):
			if dash_meter.value == 100:
				dash_meter.texture_under = preload("res://resources/sprites/dash loading bar unfinished.png")
				dash_meter.texture_progress = preload("res://resources/sprites/dash loading bar unfinished.png")
				break
			await self.get_tree().create_timer(0.2, false).timeout
			if i % 2 == 0:
				dash_meter.texture_under = preload("res://resources/sprites/dash loading bar depleted.png")
				dash_meter.texture_progress = preload("res://resources/sprites/dash loading bar depleted.png")
			else:
				dash_meter.texture_under = preload("res://resources/sprites/dash loading bar unfinished.png")
				dash_meter.texture_progress = preload("res://resources/sprites/dash loading bar unfinished.png")
		dash_meter.texture_under = preload("res://resources/sprites/dash loading bar depleted.png")
		dash_meter.texture_progress = preload("res://resources/sprites/dash loading bar filled.png")
		dashing_ProgressBar_animation_flag = true
	# check if the player active the fall from platform action
	if Input.is_action_pressed("fall_from_platform"):
		fall_from_platform()
		
		
	# check if the player collide with the borders
	if GlobalVariables.player_collide_with_borders:
		push_player_from_borders()
	# add function to the player to stop velocity_y with the key W
	if Input.is_action_just_pressed("stop velocity") and can_stop_velocity and not self.is_on_floor() and GlobalVariables.abilities.get("stop_velocity"):
		velocity_stopped = true
		can_stop_velocity = false
		current_speed = 50
		# check what is the current velocity y and change the velocity y
		if self.velocity.y > 0:
			self.velocity.y = 50
		elif self.velocity.y < 0:
			self.velocity.y = -50
		else:
			self.velocity.y = 0
			
		if self.velocity.x > 0:
			self.velocity.y = 50
		elif self.velocity.y < 0:
			self.velocity.y = -50
		else:
			self.velocity.x = 0
		$velocity_stop_timer.start()
	if Input.is_action_just_released("stop velocity"):
		print("velocity stopped")
		$velocity_stop_timer.stop()
		$velocity_stop_timer.timeout.emit()
	# active the anti hitbox ability when pressing the action
	if Input.is_action_just_pressed("ghost mode") and not player_dashing and velocity == Vector2(0, 0) and GlobalVariables.abilities.get("ghost_mode") and not ghost_mode_enabled:
		ghost_mode()
		print("ghost mode")
		
	# check all the platform the player is collide with
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()

		if collider is StaticBody2D:
			body_platform_list.append(collider)
	
	
	move_and_slide()
func _process(_delta: float) -> void:
	# kill the player if the hp is bellow 0
	if GlobalVariables.player_hp <= 0:
		get_tree().change_scene_to_file("res://scenes/death screen.tscn")
		return
	# check if the player have the time slower abilty
	if GlobalVariables.abilities.get("time_slower") and not ghost_mode_enabled:
		Engine.time_scale = 0.9
		
	if ghost_mode_enabled:
		$"player animation".modulate.a = 0.5
		$"player animation".global_position = player_current_position
		$"black box".visible = true
		var min_anti_gravity: int = 500
		var max_anti_gravity: int = 1500
		var highest_y: int = -500
		var lowest_y: int = 2000
		current_speed = 4000 # make the player faster
		# make the player grvity as his global y if anti hitbox enbled(idk how this is work)
		gravity = clampf(
			remap(global_position.y, highest_y, lowest_y, min_anti_gravity, max_anti_gravity), min_anti_gravity,max_anti_gravity)
	else:
		$"player animation".global_position = self.global_position
		$"player animation".modulate.a = 1
		$"black box".visible = false
		gravity = 1500
	# check if the player have the better dash loading ability
	if GlobalVariables.abilities.get("dash_plus"):
		$"dashing timer".wait_time = 4
	elif GlobalVariables.abilities.get("dash"):
		$"dashing timer".wait_time = 10
	# check if the player have the size down abilities
	if GlobalVariables.abilities.get("size_down_plus"):
		self.scale = Vector2(0.8, 0.8)
	elif GlobalVariables.abilities.get("size_down"):
		self.scale = Vector2(0.9, 0.9)
	else:
		self.scale = Vector2(1, 1)
	# check if the player being invincible
	if GlobalVariables.player_invincible == true:
		if invinicible_animation_flag == true:
			invinicible_animation_flag = false
			animation_timer.start()
	if not player_can_spring_jump:
		for spring_block in $"../../blocks/springs".get_children():
			if spring_block.spring_ready:
				player_can_spring_jump = true
		# i have a lot of movement bugs so:
	#print(speed, " ",  current_speed)

# a function that make the player fall from a platform
func fall_from_platform() -> void:
	for i in body_platform_list:
		var collision_shape = i.get_node_or_null("CollisionShape2D")
		if collision_shape != null:
			if collision_shape.one_way_collision:
				add_collision_exception_with(i)
				print("sdf")
	await get_tree().create_timer(0.1).timeout
	for i in body_platform_list:
		remove_collision_exception_with(i)

	body_platform_list = []

# active ghost mode
func ghost_mode() -> void:
	$"Player area2d collision/CollisionShape2D".disabled = true # make the player collision disabled
	$player_hit_place/CollisionShape2D.disabled = true # make the player unhitable
	Engine.time_scale = 0.25 # make the game slow
	ghost_mode_enabled = true # a variable that help to make the player gravity
	$gun/reload_time.wait_time = 0.1 # make the gun really fast
	var tween = create_tween().set_loops()
	tween.tween_property($"../..", "modulate", Color.BLACK, 0.2)
	tween.tween_property($"../..", "modulate", Color.WHITE, 0.2)
	player_current_position	 = self.global_position
	$sword.process_mode = Node.PROCESS_MODE_DISABLED
	await self.get_tree().create_timer(1.5, false, false, false).timeout # make a timer that end after 0.3 seconds(the game slower so the timer will be 3 seconds) 
	# return the game to the normal mode
	Playerhp.player_invincible(1.5)
	$sword.process_mode = Node.PROCESS_MODE_INHERIT
	self.global_position = player_current_position
	$"Player area2d collision/CollisionShape2D".disabled = false
	$player_hit_place/CollisionShape2D.disabled = false
	$"../..".modulate = Color.WHITE
	current_speed = speed

	
	tween.kill()
	Engine.time_scale = 1
	ghost_mode_enabled = false
	$gun/reload_time.wait_time = 0.3

# start the animation 
func _on_invincible_animation_timeout() -> void:
		invinicible_animation_flag = true
		# if player still invincible make him invisible and then visible
		if GlobalVariables.player_invincible == true:
			if self.visible == true:
				self.visible = false
			else:
				invinicible_animation_flag = true
				self.visible = true
		# if not, return
		else:
			self.visible = true
			return
func dash() -> void:
	if GlobalVariables.abilities.get("invincible_dash"):
		Playerhp.player_invincible(1)
	can_dash = false
	player_dashing = true
	await self.get_tree().create_timer(0.1).timeout
	player_dashing = false
	$"dashing timer".start()


	
func push_player_from_borders() -> void:
	if self.global_position.x > 0:
		push_player = "minus"
	else:
		push_player = "plus"
	push_speed = abs(velocity.x)
	GlobalVariables.player_can_move = false
	await self.get_tree().create_timer(0.1).timeout
	push_player = "no"
	GlobalVariables.player_can_move = true


func _on_velocity_stop_timer_timeout() -> void:
	velocity_stopped = false
	current_speed = speed
	await self.get_tree().create_timer(5).timeout
	can_stop_velocity = true


func _on_dashing_timer_timeout() -> void:
	can_dash = true
