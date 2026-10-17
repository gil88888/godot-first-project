extends Node


var player_max_hp: int = 100
var player_hp: int = 100
var player_invincible: bool = false
var danger_level: int = 0
var score: int = 0
var best_score: int = 0
var score_label: Label # needed
var player_collide_with_borders: bool = false
var player_can_move: bool = true
var game_stopped: bool = false
# false for no abilty true for ability and null for unlockable abilty 
var abilities: Dictionary = {
	time_slower = false, # false
	ghost_mode = true, # null
	dash = false, # false
	dash_plus = null, # null
	invincible_dash = null, # null
	stop_velocity = false, # false
	#exploding_shots = false,
	regenerating = false, # false
	regenerating_plus = null, # null
	size_down = false, # false
	size_down_plus = null, # null
	#ranged_attack = false,
	#increased_knockback = false,
	#land_mines = false
}
