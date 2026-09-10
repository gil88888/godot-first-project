extends Node2D

@onready var player = $"../../../Character/CharacterBody2D"
@onready var invincible_time_func = $"../../../Character/player_invincible"
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player") and GlobalVariables.player_invincible == false:
		GlobalVariables.player_hp =- 20
		invincible_time_func.player_invincible(2)
