extends Node2D
var bullet_hp: int = 30
var bullet_out_of_screen: bool = false
@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("player") 

func _process(_delta: float) -> void:
	if bullet_out_of_screen:
		self.queue_free()
		

func _on_area_2d_area_entered(area: Area2D) -> void:
	# hit the player and deal damage if it enter the player
	if area.is_in_group("player"):
		Playerhp.hurt_player(20)
	# delete the bullet and add score if the player hit that with his gun
	if area.is_in_group("gun bullet"):
		bullet_hp -= randi_range(10, 20)
		if bullet_hp <= 0:
			self.queue_free()
		GlobalVariables.score += randi_range(3, 20)


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	$"VisibleOnScreenNotifier2D/out of screen timer".start()


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	$"VisibleOnScreenNotifier2D/out of screen timer".stop()


func _on_out_of_screen_timer_timeout() -> void:
	bullet_out_of_screen = true
