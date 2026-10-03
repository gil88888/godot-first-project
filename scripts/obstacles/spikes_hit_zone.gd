extends Node2D

@onready var player = $"../../../Character/Player body"
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player") and GlobalVariables.player_invincible == false:
		Playerhp.hurt_player(20)
