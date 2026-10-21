extends Area2D
var in_jump_block = false
var jump_block = null

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("jumping blocks"):
		in_jump_block = true
		jump_block = area
	if area.is_in_group("healing"):
		print("heal detected")
		if GlobalVariables.player_hp != GlobalVariables.player_max_hp:
			print("healed")
			if GlobalVariables.abilities.get("better_healing_potion_plus"):
				GlobalVariables.player_hp += area.get_meta("heal") + 30
			elif GlobalVariables.abilities.get("better_healing_potion"):
				GlobalVariables.player_hp += area.get_meta("heal") + 15
			else:
				GlobalVariables.player_hp += area.get_meta("heal")
			area.queue_free()
	
func _on_area_exited(area: Area2D) -> void:	
	if area.is_in_group("jumping blocks"):
		in_jump_block = false
		jump_block = null
