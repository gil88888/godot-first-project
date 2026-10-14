extends Control

@onready var label_1 = $"label 1"
@onready var label_2 = $"label 2"
@onready var button_1 = $"button 1"
@onready var button_2 = $"button 2"
var ability_1
var ability_2
var crash_saver = 0
func _ready() -> void:
	while true:
		crash_saver += 1
		if crash_saver == 10000:
			break
		ability_1 = GlobalVariables.abilities.keys()[randi_range(0, GlobalVariables.abilities.size() -1)]
		ability_2 = GlobalVariables.abilities.keys()[randi_range(0, GlobalVariables.abilities.size() -1)]
		if ability_1 == ability_2:
			continue
		if GlobalVariables.abilities[ability_1] == null or GlobalVariables.abilities[ability_2] == null:
			continue
		if GlobalVariables.abilities[ability_1] == true or GlobalVariables.abilities[ability_2] == true:
			continue
		break
		
	
	match ability_1:
		"dash":
			label_1.text = "make the player now have the option to dash press the button F to dash the dash have a charging bar that recharge every 10 seconds"
			button_1.text = "dash"
		"invincible_dash":
			label_1.text = "now when the player dash they are get invincibility for 1.5\nthe invincibly is active when the dash is happend and also after"
			button_1.text = "invincibility dash"
		"dash_plus":
			label_1.text = "now the dash ability is charging only 4 seconds"
			button_1.text = "dash+"
		"stop_velocity":
			label_1.text = "make the player able to press W to stop themself mid air for 1 second\nthe player can release the W button early to continue the fall\nthe ability takes 5 seconds to recharge"
			button_1.text = "air stoping"
		"exploding_shots":
			pass
		"size_down":
			label_1.text = "make the player smaller by 10%"
			button_1.text = "size down"
		"size_down_plus":
			label_1.text = "make the player even more smaller by 10%"
			button_1.text = "size down+"
		"regenerating":
			label_1.text = "add self regenerating that can happend every second"
			button_1.text = "regenerating"
		"regenerating_plus":
			label_1.text = "the regenerating now can happend every half a second"
			button_1.text = "regenerating+"
		"time_slower":
			label_1.text = "make the game 10% more slower \n note: make the player and bullet charging and stuff like this slower too"
			button_1.text = "time slower"
	match ability_2:
		"dash":
			label_2.text = "make the player now have the option to dash press the button F to dash the dash have a charging bar that recharge every few seconds"
			button_2.text = "dash"
		"invincible_dash":
			label_2.text = "now when the player dash they are get invincibility for 1.5\nthe invincibly is active when the dash is happend and also after"
			button_2.text = "invincibility dash"
		"dash_plus":
			label_2.text = "now the dash ability is charging only 4 seconds"
			button_2.text = "dash+"
		"stop_velocity":
			label_2.text = "make the player able to press W to stop themself mid air for 1 second\nthe player can release the W button early to continue the fall\nthe ability takes 5 seconds to recharge"
			button_2.text = "air stoping"
		"exploding_shots":
			pass
		"size_down":
			label_2.text = "make the player smaller by 10%"
			button_2.text = "size down"
		"size_down_plus":
			label_2.text = "make the player even more smaller by 10%"
			button_2.text = "size down+"
		"regenerating":
			label_2.text = "add self regenerating that can happend every second"
			button_2.text = "regenerating"
		"regenerating_plus":
			label_2.text = "the regenerating now can happend every half a second"
			button_2.text = "regenerating+"
		"time_slower":
			label_2.text = "make the game 10% more slower \n note: make the player and bullet charging and stuff like this slower too"
			button_2.text = "time slower"
			
func _process(_delta: float) -> void:
	# check if the player have an ability that unlock another ability
	if GlobalVariables.abilities.get("dash") and not GlobalVariables.abilities["invincible_dash"]:
		GlobalVariables.abilities["invincible_dash"] = false
	if GlobalVariables.abilities.get("dash") and not GlobalVariables.abilities["dash_plus"]:
		GlobalVariables.abilities["dash_plus"] = false
	if GlobalVariables.abilities.get("size_down") and not GlobalVariables.abilities["size_down_plus"]:
		GlobalVariables.abilities["size_down_plus"] = false
	if GlobalVariables.abilities.get("regenerating") and not GlobalVariables.abilities["regenerating_plus"]:
		GlobalVariables.abilities["regenerating_plus"] = false
	
func _on_button_1_pressed() -> void:
	print(ability_1)
	GlobalVariables.abilities[ability_1] = true
	self.get_tree().get_first_node_in_group("pause button").process_mode = Node.PROCESS_MODE_ALWAYS
	GlobalVariables.game_stopped = false
	self.set_meta("delete", true)


func _on_button_2_pressed() -> void:
	GlobalVariables.abilities[ability_2] = true
	self.get_tree().get_first_node_in_group("pause button").process_mode = Node.PROCESS_MODE_ALWAYS
	GlobalVariables.game_stopped = false
	self.set_meta("delete", true)
