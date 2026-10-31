extends Node

var can_regenerating: bool = true
var regenerating_flag: bool = true
@onready var hit_sfx = preload("res://resources/sfx/player damaged.wav")
var sound_player := AudioStreamPlayer.new()
var regenerating_timer
func _ready() -> void:
	
	sound_player.stream = hit_sfx
	add_child(sound_player)
func hurt_player(hp: int, invincible_time: float = 2) -> void:
	regenerating_timer = self.get_tree().get_first_node_in_group("regenerating timer")
	if not GlobalVariables.player_invincible:
		sound_player.play()
		can_regenerating = false
		regenerating_timer.start()
		GlobalVariables.player_hp -= hp
		player_invincible(invincible_time)

func player_invincible(invincible_time: float = 2) -> void:
	GlobalVariables.player_invincible = true
	await get_tree().create_timer(invincible_time).timeout
	GlobalVariables.player_invincible = false
	
func _process(_delta: float) -> void:
	if can_regenerating and regenerating_flag:
		if GlobalVariables.abilities.get("regenerating_plus"):
			regenerating_flag = false
			await self.get_tree().create_timer(0.5).timeout
			if randi_range(1, 3) == 1:
				GlobalVariables.player_hp += 1
			regenerating_flag = true
			
		elif GlobalVariables.abilities.get("regenerating"):
			regenerating_flag = false
			await self.get_tree().create_timer(1).timeout
			if randi_range(1, 3) == 1:
				GlobalVariables.player_hp += 1
			regenerating_flag = true
		


func _on_regenerating_timer_timeout() -> void:
	can_regenerating = true
