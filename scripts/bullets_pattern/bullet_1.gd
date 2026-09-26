extends Node2D

@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("player") 
func _ready() -> void:
	pass

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		GlobalVariables.player_hp -= 20
		PlayerInvincible.player_invincible(2)
		print(GlobalVariables.player_hp)
	#if area.is_in_group("gun bullet"):
		
