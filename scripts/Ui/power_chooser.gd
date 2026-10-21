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
			label_1.text = "make the game 10% more slower"
			button_1.text = "time slower"
		"ghost_mode":
			label_1.text = "pressing R active ghost mode \nwhen activating ghost mode the player hitbox is disabled,  make the time slower and gun charge is faster for some seconds \nwhen the ability is ended the player return to the place they used the abilty"
			button_1.text = "ghost mode"
		"extra_max_hp":
			label_1.text = "add to the player 50 max hp"
			button_1.text = "extra max hp"
		"extra_max_hp_plus":
			label_1.text = "add to the player 50 max hp"
			button_1.text = "extra max hp+"
		"better_healing_potion":
			label_1.text = "healing potion now heals +15 hp"
			button_1.text = "better healing potion"
		"better_healing_potion_plus":
			label_1.text = "healing potion now heals +30 hp"
			button_1.text = "better healing potion+"
		"ranged_attack":
			label_1.text = "the gun bullets are now deal 5 damage instead of 10\nevery frame the bullet is traveling it gain 0.75 more damage"
			button_1.text = "ranged attacks"
		"piercing":
			label_1.text = "the player bullets gain piercing ability that make the bullte pierce through enemies\n every enemy the bullet pierce it damage divided by 2"
			button_1.text = "piercing"
		"piercing_plus":
			label_1.text = "the bullets damage now multiply by 1.5 damage per enemy it pierce"
			button_1.text = "piercing plus"
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
			label_2.text = "make the game 10% more slower"
			button_2.text = "time slower"
		"ghost_mode":
			label_2.text = "pressing R active ghost mode \nwhen activating ghost mode the player hitbox is disabled,  make the time slower and gun charge is faster for some seconds \nwhen the ability is ended the player return to the place they used the abilty"
			button_2.text = "ghost mode"
		"extra_max_hp":
			label_2.text = "add to the player 50 max hp"
			button_2.text = "extra max hp"
		"extra_max_hp_plus":
			label_2.text = "add to the player 50 max hp"
			button_2.text = "extra max hp+"
		"better_healing_potion":
			label_2.text = "healing potion now heals +15 hp"
			button_2.text = "better healing potion"
		"better_healing_potion_plus":
			label_2.text = "healing potion now heals +30 hp"
			button_2.text = "better healing potion+"
		"ranged_attack":
			label_2.text = "the gun bullets are now deal 5 damage instead of 10\nevery frame the bullet is traveling it gain 0.75 more damage"
			button_2.text = "ranged attacks"
		"piercing":
			label_2.text = "the player bullets gain piercing ability that make the bullte pierce through enemies\n every enemy the bullet pierce it damage divided by 2"
			button_2.text = "piercing"
		"piercing_plus":
			label_2.text = "the bullets damage now multiply by 1.5 damage per enemy it pierce"
			button_2.text = "piercing plus"
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
	if GlobalVariables.danger_level >= 3 and not GlobalVariables.abilities["ghost_mode"]:
		GlobalVariables.abilities["ghost_mode"] = false
	if GlobalVariables.abilities.get("extra_max_hp") and not GlobalVariables.abilities["extra_max_hp_plus"]:
		GlobalVariables.abilities["extra_max_hp_plus"] = false
	if GlobalVariables.abilities.get("better_healing_potion") and not GlobalVariables.abilities["better_healing_potion_plus"]:
		GlobalVariables.abilities["better_healing_potion_plus"] = false
	if GlobalVariables.abilities.get("piercing") and not GlobalVariables.abilities["piercing_plus"] and GlobalVariables.danger_level >= 4:
		GlobalVariables.abilities["piercing_plus"] = false
		
func _on_button_1_pressed() -> void:
	if ability_1 == "dash" or ability_1 == "dash+" or ability_1 == "invincible_dash":
		get_tree().get_first_node_in_group("dashing timer").stop()
		get_tree().get_first_node_in_group("dashing timer").timeout.emit()
	GlobalVariables.abilities[ability_1] = true
	self.get_tree().get_first_node_in_group("pause button").process_mode = Node.PROCESS_MODE_ALWAYS
	GlobalVariables.game_stopped = false
	Playerhp.player_invincible(4)
	self.set_meta("delete", true)


func _on_button_2_pressed() -> void:
	if ability_2 == "dash" or ability_2 == "dash+" or ability_2 == "invincible_dash":
		get_tree().get_first_node_in_group("dashing timer").stop()
		get_tree().get_first_node_in_group("dashing timer").timeout.emit()
	GlobalVariables.abilities[ability_2] = true
	self.get_tree().get_first_node_in_group("pause button").process_mode = Node.PROCESS_MODE_ALWAYS
	GlobalVariables.game_stopped = false
	Playerhp.player_invincible(4)
	self.set_meta("delete", true)
