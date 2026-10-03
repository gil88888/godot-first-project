extends Label

var last_player_hp: int = GlobalVariables.player_hp

func _ready() -> void:
	text = "hp: " + str(GlobalVariables.player_hp)

func _process(_delta: float) -> void:
	if last_player_hp != GlobalVariables.player_hp:
		last_player_hp = GlobalVariables.player_hp
		if GlobalVariables.player_hp > GlobalVariables.player_max_hp:
			GlobalVariables.player_hp = GlobalVariables.player_max_hp
		else:
			text = "hp: " + str(GlobalVariables.player_hp)
