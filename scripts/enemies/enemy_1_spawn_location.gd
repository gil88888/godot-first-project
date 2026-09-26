extends Marker2D

var enemy_1_scene = preload("res://scenes/enemy_1.tscn")
var enemy_1 = null
var animation_finished_counter: int = 0
@onready var spawn_animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var respawn_timer: Timer = $respawn_timer
func _ready() -> void:
	spawning_enemy()

	
func spawning_enemy() -> void:
	var random_x = randi_range(-2714, 3425)
	self.global_position.y = 385
	self.global_position.x = random_x
	spawn_animation.visible = true
	spawn_animation.play()

func spawn_enemy() -> void:
	enemy_1 = enemy_1_scene.instantiate() # copy the scene(the enemy) into a var called enemy_1
	get_parent().add_child(enemy_1) # add the enemy_1 to the enemies node
	enemy_1.global_position = self.global_position # make the enemy_1 position the marker position
	print("enemy_1 created in " , enemy_1.global_position)
	match GlobalVariables.danger_level:
		0:
			respawn_timer.wait_time = randi_range(6, 12)
		1:
			respawn_timer.wait_time = randi_range(4, 10)
		2:
			respawn_timer.wait_time = randi_range(3, 7)
		3:
			respawn_timer.wait_time = randi_range(2, 5)
		4:
			respawn_timer.wait_time = randi_range(1, 3)
		
	respawn_timer.start()

func _process(_delta: float) -> void:
	if animation_finished_counter == 3:
		spawn_animation.stop()
		animation_finished_counter = 0
		spawn_animation.visible = false
		spawn_enemy()



func _on_animated_sprite_2d_animation_looped() -> void:
	animation_finished_counter += 1


func _on_respawn_timer_timeout() -> void:
	spawning_enemy()
