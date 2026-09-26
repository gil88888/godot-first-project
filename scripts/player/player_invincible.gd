extends Node2D

func player_invincible(invincible_time: int) -> void:
	GlobalVariables.player_invincible = true
	await get_tree().create_timer(invincible_time).timeout
	GlobalVariables.player_invincible = false
