extends Node

func save_data() -> void:
	var data = {}
	var file = null
	if FileAccess.file_exists("user://savegame.json"):
		file = FileAccess.open("user://savegame.json", FileAccess.READ)
		data = JSON.parse_string(file.get_as_text())
		file.close()

		if data == null:
			data = {}

	var key = "best score danger " + str(GlobalVariables.danger_level)
	data[key] = GlobalVariables.best_score

	file = FileAccess.open("user://savegame.json", FileAccess.WRITE)
	file.store_string(JSON.stringify(data))
	file.close()


func load_data() -> void:
	if not FileAccess.file_exists("user://savegame.json"):
		GlobalVariables.best_score = 0
		return

	var file = FileAccess.open("user://savegame.json", FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	file.close()

	if data == null:
		GlobalVariables.best_score = 0
		return

	var key = "best score danger " + str(GlobalVariables.danger_level)

	if data.has(key):
		GlobalVariables.best_score = data[key]
	else:
		GlobalVariables.best_score = 0
