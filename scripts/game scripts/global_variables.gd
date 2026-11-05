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
	ghost_mode = null, # null
	dash = false, # false
	dash_plus = null, # null until having dash ability
	invincible_dash = null, # null until having dash ability
	stop_velocity = false, # false
	#exploding_shots = false,
	regenerating = false, # false
	regenerating_plus = null, # null until having regeneratig
	size_down = false, # false
	size_down_plus = null, # null until having size down
	extra_max_hp = false, # false
	extra_max_hp_plus = null, # null until having extra_max_hp
	better_healing_potion = false, # false
	better_healing_potion_plus = null, #null until having better_healing_potion
	ranged_attack = false, # false
	piercing = false, # false
	piercing_plus = null, # null until having piercing and in wave 4
	faster_sword_recharge = false, # false
	fly_assistant = null, # null until wave 4
	homing_shots = null, # null until wave 5
	#increased_knockback = false,
	#land_mines = false
}
