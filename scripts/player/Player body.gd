extends CharacterBody2D
var speed: int = 1000 # 200
var running_speed: int = 1400
var dash_speed: int = 6500
var current_speed: int = speed
var gravity: int = 1500 # 1500
var jump_power: int = 1700 # 1300
var running_flag: bool = true
var jump_buffer_time: float = 0.10
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
@onready var animation_timer: Timer = $"invincible animation"
@onready var player_area: Area2D = $"Player area2d collision"
@onready var dashing_timer: Timer = $"dashing timer"
@onready var dash_meter: ProgressBar = $"../../CanvasLayer/Control/dash meter"
func _physics_process(delta):
	# make the player fall if not on floor or stopping velocity
	if not self.is_on_floor():
		if not velocity_stopped:
			velocity.y += gravity * delta * 2

		
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
	if is_on_floor():
		coyote_timer = coyote_time
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
		if Input.is_action_just_released("run") and self.is_on_floor():
			current_speed -= (running_speed - speed)
			running_flag = true
	# check jumping options that is not regular jump
	if GlobalVariables.player_can_move:
		if Input.is_action_just_pressed("jump") and player_area.in_jump_block and player_area.jump_block.jump_block_disabled == false:
			self.velocity.y = player_area.jump_block.velocity_y
		if player_can_spring_jump and Input.is_action_just_pressed("jump"):
			self.velocity.y -= 1500
			player_can_spring_jump = false
		elif player_can_spring_jump:
			player_can_spring_jump = false
			self.velocity.y -= 1250
		
	# check if the player can dash
	if Input.is_action_just_pressed("dash") and can_dash and GlobalVariables.player_can_move:
		dash()
	# if cant because of the loading time make the dashing progress bar red
	elif Input.is_action_just_pressed("dash") and GlobalVariables.player_can_move and dashing_ProgressBar_animation_flag:
		dashing_ProgressBar_animation_flag = false
		var style = dash_meter.get_theme_stylebox("fill").duplicate()
		for i in range(8):
			if dash_meter.value == 100:
				style.bg_color = Color.html("#5ef281")
				break
			await self.get_tree().create_timer(0.2).timeout
			if i % 2 == 0:
				style.bg_color = Color.html("#f25e5e")
			else:
				style.bg_color = Color.html("#5ef281")
			dash_meter.add_theme_stylebox_override("fill", style)
		dashing_ProgressBar_animation_flag = true
			
	# check if the player collide with the borders
	if GlobalVariables.player_collide_with_borders:
		push_player_from_borders()
	# add function to the player to stop velocity_y with the key W
	if Input.is_action_just_pressed("stop velocity") and can_stop_velocity and not self.is_on_floor():
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
		print("stoped")
		$velocity_stop_timer.stop()
		$velocity_stop_timer.timeout.emit()
	
	
		
	move_and_slide()
func _process(_delta: float) -> void:
	# check if the player being invincible
	if GlobalVariables.player_invincible == true:
		if invinicible_animation_flag == true:
			invinicible_animation_flag = false
			animation_timer.start()
	if not player_can_spring_jump:
		for spring_block in $"../../springs".get_children():
			if spring_block.spring_ready:
				player_can_spring_jump = true
		# i have a lot of movement bugs so:
	#print(speed, " ",  current_speed)


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
	await self.get_tree().create_timer(1.5).timeout
	push_player = "no"
	GlobalVariables.player_can_move = true


func _on_velocity_stop_timer_timeout() -> void:
	velocity_stopped = false
	current_speed = speed
	await self.get_tree().create_timer(5).timeout
	can_stop_velocity = true


func _on_dashing_timer_timeout() -> void:
	can_dash = true
