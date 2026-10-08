extends Node

var border_less = false
var data_saver_file = preload("res://scripts/game scripts/data saver.gd").new()
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	data_saver_file.load_data()
func _process(_delta: float) -> void:
	# check if fullscreen button is pressed
	if Input.is_action_just_pressed("full_screen"):
		if border_less:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			border_less = false
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			border_less = true
	# debug healing
	if Input.is_action_pressed("heal"):
		GlobalVariables.player_max_hp = 234828394723984
		GlobalVariables.player_hp = 234828394723984
		print("heal")
	# check if the game is paused and pause it if so
	if GlobalVariables.game_stopped:
		get_tree().paused = true
	else:
		get_tree().paused = false
func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		print("closing game")
		data_saver_file.save_data()
		
