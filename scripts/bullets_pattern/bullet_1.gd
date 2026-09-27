extends Node2D

@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("player") 
func _ready() -> void:
	pass

func _on_area_2d_area_entered(area: Area2D) -> void:
	# hit the player and deal damage if it enter the player
	if area.is_in_group("player"):
		GlobalVariables.player_hp -= 20
		PlayerInvincible.player_invincible(2)
		print(GlobalVariables.player_hp)
	# delete the bullet and add score if the player hit that with his gun
	if area.is_in_group("gun bullet"):
		self.queue_free()
		GlobalVariables.score += randi_range(3, 20)
