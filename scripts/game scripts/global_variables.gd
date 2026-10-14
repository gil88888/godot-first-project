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

var abilities: Dictionary = {
	time_slower = false,
	dash = false,
	dash_plus = null,
	invincible_dash = null,
	stop_velocity = false,	
	#exploding_shots = false,
	regenerating = false,
	regenerating_plus = null,
	size_down = false,
	size_down_plus = null,
	#ranged_attack = false,
	#increased_knockback = false,
	#land_mines = false
}
