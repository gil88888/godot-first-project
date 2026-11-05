extends Control

@onready var camera: Camera2D = $"../Camera2D"
@onready var background = $"../background/moving background" 
@onready var sound_slider = $"sound slider"
@onready var sound_slider_label = $"sound slider/label"
func _on_back_from_settings_button_pressed() -> void:
	var tween: Tween = camera.create_tween()
	background.set_meta("move_background", false)
	await tween.tween_property(camera, "global_position", Vector2(960, 544), 0.5).finished # anything but math
	background.set_meta("move_background", true)

func _process(delta: float) -> void:
	sound_slider_label.text = ("sound: " + str(sound_slider.value))
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("sound effects"),
		sound_slider.value
	)
