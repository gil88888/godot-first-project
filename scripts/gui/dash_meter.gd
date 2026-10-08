extends ProgressBar
@onready var player: CharacterBody2D = $"../../../Character/Player body"
@onready var dashing_timer: Timer = $"../../../Character/Player body/dashing timer"

func _process(_delta: float) -> void:
	if not dashing_timer.is_stopped():
		self.value = (dashing_timer.wait_time - dashing_timer.time_left) * 100 / dashing_timer.wait_time 
	else:
		self.value = 100
	if player.player_dashing:
		print("dashed")
		var progress_tween = create_tween()
		progress_tween.tween_property(self, "value", 0, 0.1)
