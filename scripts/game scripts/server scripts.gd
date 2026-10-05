extends Node

var border_less = false
var data_saver_file = preload("res://scripts/game scripts/data saver.gd").new()
func _ready() -> void:
	data_saver_file.load_data()
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("full_screen"):
		if border_less:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			border_less = false
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			border_less = true
func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		print("closing game")
		data_saver_file.save_data()
		
