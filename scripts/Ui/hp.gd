extends ProgressBar

var last_player_hp: int = GlobalVariables.player_hp

func _ready() -> void:
	value = float(GlobalVariables.player_hp)
	
func _process(_delta: float) -> void:
	# check if the player have ability that increase max hp
	if GlobalVariables.abilities.get("extra_max_hp_plus"):
		GlobalVariables.player_max_hp = 200
		max_value = 200
	elif GlobalVariables.abilities.get("extra_max_hp"):
		GlobalVariables.player_max_hp = 150
		max_value = 150
	else:
		GlobalVariables.player_max_hp = 100
	# check if the player hp has been changed
	if last_player_hp != GlobalVariables.player_hp:
		last_player_hp = GlobalVariables.player_hp
		if GlobalVariables.player_hp > GlobalVariables.player_max_hp:
			GlobalVariables.player_hp = GlobalVariables.player_max_hp
		else:
			var progress_tween = create_tween()
			progress_tween.tween_property(self, "value", float(GlobalVariables.player_hp), 0.1)
