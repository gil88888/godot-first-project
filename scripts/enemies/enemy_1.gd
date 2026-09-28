extends Area2D
@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("player") 
var speed: int = 100
var enemy_hp: int
var enemy_hit_animation_flag: bool = true
var enemy_flipped: bool = false
var movement_cooldown_flag: bool = false
@onready var attack_class = Enemy1Attacks.new(self)
var bullet_1_scene := preload("res://scenes/bullet_1.tscn")

func _ready() -> void:
	self.set_meta("id", randi_range(1, 10000000000000))
	if GlobalVariables.danger_level == 0:
		enemy_hp = 80
	elif GlobalVariables.danger_level == 1:
		enemy_hp = 100
	elif GlobalVariables.danger_level == 2:
		enemy_hp = 120
	elif GlobalVariables.danger_level == 3:
		enemy_hp = 140
	elif GlobalVariables.danger_level == 4:
		enemy_hp = 160

func attack() -> void:
	var bullet_1 = bullet_1_scene.instantiate()
	var bullet_x = self.global_position.x + randi_range(-500, 500)
	var bullet_y = player.global_position.y - 300
	attack_class.attack_pattern(Vector2(bullet_x, bullet_y), player.global_position , bullet_1, 1500, 0.5, self.get_meta("id"))
		
func _process(delta: float) -> void:
	# check if the enemy is dead
	if enemy_hp <= 0:
		GlobalVariables.score_label.add_score(randi_range(100, 200))
		self.get_parent().queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player") and GlobalVariables.player_invincible == false:
		GlobalVariables.player_hp -= 30
		PlayerInvincible.player_invincible(2)
	if area.is_in_group("gun bullet"):
		enemy_hp -= 10
		GlobalVariables.score_label.add_score(randi_range(5, 15))
		if enemy_hit_animation_flag:
			self.get_node("Sprite2D").modulate = Color(90, 90, 0)
			enemy_hit_animation_flag = false
			$"hit animation".start()
			

func _on_hit_animation_timeout() -> void:
		enemy_hit_animation_flag = true
		self.get_node("Sprite2D").modulate = Color(253, 0, 0)
		

		
# check if the player is in the attack range
func _on_area_attack_view_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		$"area attack view/attack_cooldown".start()

func _on_area_attack_view_area_exited(area: Area2D) -> void:
	if area.is_in_group("player"):
		$"area attack view/attack_cooldown".stop()

# on the attack cooldown end
func _on_attack_cooldown_timeout() -> void:
	attack()
