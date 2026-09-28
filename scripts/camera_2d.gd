extends Camera2D

@onready var player = $"../Character/CharacterBody2D"
var camera_speed = 1


func _process(delta):
	self.global_position.x = move_toward(player.global_position.x, self.global_position.y, camera_speed * delta)
	self.global_position.y = move_toward(player.global_position.y + 300, self.global_position.x, camera_speed * delta)
