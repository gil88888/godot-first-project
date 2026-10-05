extends Node2D

var can_regenerating: bool = true
var regenerating_flag: bool = true
@onready var regenerating_timer: Timer = self.get_tree().get_first_node_in_group("regenerating timer") 
func hurt_player(hp: int, invincible_time: int = 2) -> void:
	can_regenerating = false
	regenerating_timer.start()
	GlobalVariables.player_invincible = true
	GlobalVariables.player_hp -= hp
	# kill the player if he is below 0 hp 
	if GlobalVariables.player_hp <= 0:
		get_tree().change_scene_to_file("res://scenes/death screen.tscn")
		
	await get_tree().create_timer(invincible_time).timeout
	GlobalVariables.player_invincible = false
func _process(_delta: float) -> void:
	if can_regenerating and regenerating_flag:
		regenerating_flag = false
		await self.get_tree().create_timer(1).timeout
		if randi_range(1, 3) == 1:
			GlobalVariables.player_hp += 1
		regenerating_flag = true


func _on_regenerating_timer_timeout() -> void:
	can_regenerating = true
