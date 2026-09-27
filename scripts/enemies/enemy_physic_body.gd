extends CharacterBody2D
#
#var enemy_ready_to_jump = false
#var gravity = 1500
#var jump_power = 1500
#func _process(delta: float) -> void:
	#self.global_position.x =  $enemy_1.global_position.x
##func _physics_process(delta: float) -> void:
#
#func _physics_process(delta: float) -> void:
	#if not self.is_on_floor():
		#velocity.y += gravity * delta * 2
	#velocity.y += gravity * delta
	#position.y += velocity.y * delta
	#if self.is_on_floor():
		#if enemy_ready_to_jump:
			#velocity.y = -jump_power
	#move_and_slide()
 #
## check if there are obstacle infront the enemyג
#func _on_obstacle_detector_area_entered(area: Area2D) -> void:
	#if area.is_in_group("obstacle"):
		#enemy_ready_to_jump = true
#
#func _on_obstacle_detector_area_exited(area: Area2D) -> void:
	#if area.is_in_group("obstacle"):
		#enemy_ready_to_jump = false
