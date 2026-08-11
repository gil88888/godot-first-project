extends Node2D

@onready var timer = $"invincible timer"
func player_invincible(invincible_time: float) -> void:
	timer.wait_time = invincible_time
	GlobalVariables.player_invincible = true
	timer.start()


func _on_invincible_timer_timeout() -> void:
	GlobalVariables.player_invincible = false
