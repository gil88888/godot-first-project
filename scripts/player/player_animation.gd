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
				play("air right")
			else:
				play("air left")
		else:
			var moving_left = Input.is_action_pressed("move_left")
			var moving_right = Input.is_action_pressed("move_right")

			if moving_left and not moving_right:
				last_moved_place = "left"
				play("walking left")
			elif moving_right and not moving_left:
				last_moved_place = "right"
				play("walking right")
			else:
				if last_moved_place == "right":
					play("idle right")
				else:
					play("idle left")
					
					
