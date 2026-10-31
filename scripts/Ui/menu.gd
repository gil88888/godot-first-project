extends Control

var scene = preload("res://scenes/main.tscn")
@onready var camera: Camera2D = $Camera2D
@onready var background = $"background/moving background"
func _on_start_game_button_pressed() -> void:
	get_tree().change_scene_to_packed(scene)


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_setting_button_pressed() -> void:
	var tween: Tween = camera.create_tween()
	background.set_meta("move_background", false)
	await tween.tween_property(camera, "global_position", Vector2(5000 + 1920 / 2, 544.0), 0.5).finished # anything but math
	background.set_meta("move_background", true)
