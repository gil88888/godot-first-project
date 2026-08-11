extends Camera2D

@onready var player = $"../../Character/CharacterBody2D"
@onready var camera_placment = $"../../Character/CharacterBody2D/Area2D"

var camera_speed = 1

func _process(delta):
	# move the camera toward the camera block x and y
			#if camera_placment.camera_move_x:
				#global_position.x = move_toward(global_position.x, camera_placment.camera_x, camera_speed * delta)
			#if camera_placment.camera_move_y:
				#global_position.y = move_toward(global_position.y, camera_placment.camera_y, camera_speed * delta)
			## disable the camera if not need to move
			#if global_position.x == camera_placment.camera_x:
				#camera_placment.camera_move_x = false
			#if global_position.y == camera_placment.camera_y:
				#camera_placment.camera_move_y = false

	self.global_position.x = move_toward(player.global_position.x, self.global_position.y, camera_speed * delta)
	self.global_position.y = move_toward(player.global_position.y + 300, self.global_position.x, camera_speed * delta)

	#self.global_position.x = move_toward(global_position.x, player.global_position.x, camera_speed * delta)
	#self.global_position.y = move_toward(global_position.y, player.global_position.y, camera_speed * delta)
#func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
			#global_position.x = move_toward(global_position.x, camera_placment.camera_x, 2000)
			#global_position.y = move_toward(global_position.y, camera_placment.camera_y, 2000)
