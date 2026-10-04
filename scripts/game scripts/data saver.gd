extends Node

func save_data() -> void:
	var data = {
		"best score": GlobalVariables.best_score
	}
	var file = FileAccess.open("user://savegame.json", FileAccess.WRITE)
	file.store_string(JSON.stringify(data))
	file.close()
	print(OS.get_user_data_dir())

func load_data() -> void:
	if not FileAccess.file_exists("user://savegame.json"):
		return
	var file = FileAccess.open("user://savegame.json", FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	file.close()

	GlobalVariables.best_score = data["best score"]
