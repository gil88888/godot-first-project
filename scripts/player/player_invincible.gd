extends Node2D

func hurt_player(hp: int, invincible_time: int = 2) -> void:
	GlobalVariables.player_invincible = true
	GlobalVariables.player_hp -= hp
	if GlobalVariables.player_hp <= 0:
		get_tree().change_scene_to_file("res://scenes/death screen.tscn")
	await get_tree().create_timer(invincible_time).timeout
	GlobalVariables.player_invincible = false
	
