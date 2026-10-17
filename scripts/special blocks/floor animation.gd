extends AnimatedSprite2D

func _ready() -> void:
	if get_meta("synced"):
		frame = 1
	else:
		frame = 0
	play()
