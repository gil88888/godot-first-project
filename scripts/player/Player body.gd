extends CharacterBody2D
var speed: int = 1000 # 200
var running_speed: int = 1200
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
@onready var animation_timer: Timer = $"invincible animation"
@onready var player_area: Area2D = $"Player area2d collision"
@onready var spring_block = $"../../platforms/spring block"
@onready var dashing_timer: Timer = $"dashing timer"
func _physics_process(delta):
	if not self.is_on_floor():
		velocity.y += gravity * delta * 2

	# movement and dashing
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

	if jump_buffer_timer > 0 and can_jump:
		velocity.y = - jump_power
		coyote_timer = 0
		jump_buffer_timer = 0
	# check if shift is pressed to make the player run
	if Input.is_action_pressed("run") and running_flag and self.is_on_floor():
		current_speed += (running_speed - speed)
		running_flag = false
	if Input.is_action_just_released("run"):
		current_speed -= (running_speed - speed)
		running_flag = true
	# check jumping options that is not regular jump
	if Input.is_action_just_pressed("jump") and player_area.in_jump_block and player_area.jump_block.jump_block_disabled == false:
		self.velocity.y = player_area.jump_block.velocity_y
	if spring_block.spring_ready and Input.is_action_just_pressed("jump"):
		self.velocity.y -= 3500
	elif spring_block.spring_ready:
		self.velocity.y -= 2500
	# check if the player can dash
	if Input.is_action_just_pressed("dash") and can_dash:
		dash()
		
	move_and_slide()
func _process(_delta: float) -> void:
	# check if the player being invincible
	if GlobalVariables.player_invincible == true:
		if invinicible_animation_flag == true:
			invinicible_animation_flag = false
			animation_timer.start()

	
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
	player_dashing = true
	await self.get_tree().create_timer(0.1).timeout
	player_dashing = false
	
