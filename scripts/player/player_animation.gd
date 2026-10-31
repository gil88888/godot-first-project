extends AnimatedSprite2D

@onready var player_body: CharacterBody2D = $".."

var last_moved_place: String = "right"


func _process(_delta: float) -> void:
	# check if the player using the ghost mode ability
	if player_body.ghost_mode_enabled:
		animation = "idle front"
		stop()
	else:
		# Update the last movement direction
		if Input.is_action_just_pressed("move_left"):
			last_moved_place = "left"
		elif Input.is_action_just_pressed("move_right"):
			last_moved_place = "right"

		# Choose the animation based on the player's state
		if not player_body.is_on_floor():
			if last_moved_place == "right":
				animation = "air right"
			else:
				animation = "air left"
		else:
			var moving_left = Input.is_action_pressed("move_left")
			var moving_right = Input.is_action_pressed("move_right")

			if moving_left and not moving_right:
				last_moved_place = "left"
				animation = "walking left"
				play()
			elif moving_right and not moving_left:
				last_moved_place = "right"
				animation = "walking right"
				play()
			else:
				if last_moved_place == "right":
					animation = "idle right"
					play()
				else:
					animation = "idle left"
					play()
					
					
