extends Area2D
var in_jump_block = false
var jump_block = null
var camera_x = 0
var camera_y = 0
var camera_move_x = false
var camera_move_y = false
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("jumping blocks"):
		in_jump_block = true
		jump_block = area
	if area.is_in_group("camera block"):
		camera_x = area.global_position.x
		camera_y = area.global_position.y
		camera_move_x = true
		camera_move_y = true

	
func _on_area_exited(area: Area2D) -> void:	
	if area.is_in_group("jumping blocks"):
		in_jump_block = false
		jump_block = null
