extends Node


var player_max_hp: int = 100
var player_hp: int = 100
var player_invincible: bool = false
var danger_level: int = 1
var score: int = 0
var score_label: Label # needed
var player_collide_with_borders: bool = false
var player_can_move: bool = true
