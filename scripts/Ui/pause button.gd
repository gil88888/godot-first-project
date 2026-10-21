extends Button


func _on_toggled(toggled_on: bool) -> void:
	if toggled_on:
		GlobalVariables.game_stopped = true
		print("pause")	
	if not toggled_on:
		GlobalVariables.game_stopped = false
		print("unpause")
