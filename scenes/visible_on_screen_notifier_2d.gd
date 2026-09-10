extends VisibleOnScreenNotifier2D

var enemy_1_on_screen: bool = false

func _on_screen_entered() -> void:
	enemy_1_on_screen = true

func _on_screen_exited() -> void:
	enemy_1_on_screen = false
