extends ProgressBar

#var progress_tween: Tween
@onready var dashing_timer: Timer = $"../../../Character/Player body/dashing timer"
#func set_progress(new_value: float) -> void:
	#if progress_tween:
		#progress_tween.kill()
#
	#progress_tween = create_tween()
	#progress_tween.tween_property($ProgressBar, "value", new_value, 0.5)

func _process(_delta: float) -> void:
	if not dashing_timer.is_stopped():
		self.value = (dashing_timer.wait_time - dashing_timer.time_left) * 100 / dashing_timer.wait_time 
	else:
		self.value = 100
