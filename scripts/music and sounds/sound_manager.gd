extends Node

var music_bus = AudioServer.get_bus_index("music")
var music_list = []
var music_searcher_helper: int = 0
var last_music = null
var music = null
func _ready() -> void:
	for i in $"battle musics".get_children():
		music_list.append(i)

func search_music() -> void:
	for i in music_list:
		music_searcher_helper += 1
		if i.playing:
			music_searcher_helper = 0
			break
		if music_searcher_helper == len(music_list):
			music_searcher_helper = 0
			while true:
				music = music_list.pick_random()
				if music != last_music:
					last_music = music
					music.play()
					break

func _process(_delta: float) -> void:
	if GlobalVariables.game_stopped:
		AudioServer.set_bus_effect_enabled(music_bus, 0, true)
	else:
		AudioServer.set_bus_effect_enabled(music_bus, 0, false)
	if music_searcher_helper == 0:
		search_music()
