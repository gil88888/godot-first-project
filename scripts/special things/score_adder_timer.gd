extends Timer

func _on_timeout() -> void:
	GlobalVariables.score_label.add_score(1)
	self.start()
