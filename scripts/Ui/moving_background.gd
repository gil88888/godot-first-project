extends TextureRect

func _ready() -> void:
	visible = true
	size = Vector2(1000000, 1000000)
	self.global_position = Vector2(-10000, -10000)

func _process(delta: float) -> void:
	self.global_position = self.global_position.move_toward(Vector2(global_position.x - 1, global_position.y - 1), 1)
