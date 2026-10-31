extends Control

@onready var camera: Camera2D = $"../Camera2D"
@onready var background = $"../background/moving background" 


func _on_back_from_settings_button_pressed() -> void:
	var tween: Tween = camera.create_tween()
	background.set_meta("move_background", false)
	await tween.tween_property(camera, "global_position", Vector2(960, 544), 0.5).finished # anything but math
	background.set_meta("move_background", true)
