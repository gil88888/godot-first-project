extends TextureProgressBar
@onready var player: CharacterBody2D = $"../../../Character/Player body"
@onready var velocity_stop_timer: Timer = $"../../../Character/Player body/velocity_cooldown"

func _process(_delta: float) -> void:
	# check if the player unlocked the dashing ability
	if GlobalVariables.abilities.get("stop_velocity"):
		self.visible = true
	else:
		self.visible = false
		
	if not velocity_stop_timer.is_stopped():
		self.value = (velocity_stop_timer.wait_time - velocity_stop_timer.time_left) * 100 / velocity_stop_timer.wait_time 
	else:
		self.value = 100
	if player.velocity_stopped:
		print("velocity stopped")
		var progress_tween = create_tween()
		progress_tween.tween_property(self, "value", -1, 0.1)
