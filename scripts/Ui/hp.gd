extends Label

var last_player_hp: int = GlobalVariables.player_hp

func _ready() -> void:
	text = "hp: " + str(GlobalVariables.player_hp)

func _process(_delta: float) -> void:
	if GlobalVariables.abilities.get("extra_max_hp_plus"):
		GlobalVariables.player_max_hp = 200	
	elif GlobalVariables.abilities.get("extra_max_hp"):
		GlobalVariables.player_max_hp = 150
	else:
		GlobalVariables.player_max_hp = 100
	if last_player_hp != GlobalVariables.player_hp:
		last_player_hp = GlobalVariables.player_hp
		if GlobalVariables.player_hp > GlobalVariables.player_max_hp:
			GlobalVariables.player_hp = GlobalVariables.player_max_hp
		else:
			text = "hp: " + str(GlobalVariables.player_hp)
