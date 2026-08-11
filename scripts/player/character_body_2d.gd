extends CharacterBody2D
var speed: int = 400 # 200
var running_speed: int = 700
var current_speed: int = speed
var gravity: int = 1000 # 1500
var jump_power: int = 1200 # 1300
var running_flag: bool = true
var animation_flag: bool = true
@onready var animation_timer: Timer = $"invincible animation"
@onready var player_area: Area2D = $Area2D
func _physics_process(delta):
	if not self.is_on_floor():
		velocity.y += gravity * delta * 1.5

	# movement
	if Input.is_action_pressed("move_right"):
		velocity.x = current_speed
	elif Input.is_action_pressed("move_left"):
		velocity.x = -current_speed
	else:
		velocity.x = 0
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -jump_power
		
	if Input.is_action_pressed("run") and running_flag and self.is_on_floor():
		current_speed += (running_speed - speed)
		running_flag = false
	if Input.is_action_just_released("run"):
		current_speed -= (running_speed - speed)
		running_flag = true
	if Input.is_action_just_pressed("jump") and player_area.in_jump_block and player_area.jump_block.jump_block_disabled == false:
		velocity.y = player_area.jump_block.velocity_y
		
	move_and_slide()
func _process(_delta: float) -> void:
	# check if the player being invincible
	if GlobalVariables.player_invincible == true:
		if animation_flag == true:
			animation_flag = false
			animation_timer.start()

# start the animation 
func _on_invincible_animation_timeout() -> void:
		animation_flag = true
		# if player still invincible make him invisible and then visible
		if GlobalVariables.player_invincible == true:
			if self.visible == true:
				self.visible = false
			else:
				animation_flag = true
				self.visible = true
		# if not, return
		else:
			self.visible = true
			return
