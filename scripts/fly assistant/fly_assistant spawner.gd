extends Node
var fly_scene = preload("res://scenes/fly_assistant.tscn")
var timer_start_flag: bool = false
var fly: Node2D = null
@onready var player = $"../Character/Player body"

func _process(_delta: float) -> void:
	if GlobalVariables.abilities.get("fly_assistant") and not timer_start_flag:
		$respawn_timer.start()
		timer_start_flag = true


func _on_respawn_timer_timeout() -> void:
	fly = fly_scene.instantiate()
	$"..".add_child(fly)
	fly.global_position = player.global_position
	fly.set_meta("place_positon", player.global_position)
	print_rich("[color=green]fly spawned")
		
