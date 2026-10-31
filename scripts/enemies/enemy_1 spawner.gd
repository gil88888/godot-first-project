extends Marker2D

var enemy_1_scene = preload("res://scenes/enemy_1.tscn")
var enemy_2_scene = preload("res://scenes/enemy_2.tscn")
var enemy_3_scene = preload("res://scenes/enemy_3.tscn")
var enemy = null
var animation_finished_counter: int = 0
var enemy_to_spawn: String
@onready var spawn_animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var respawn_timer: Timer = $respawn_timer
@onready var enemy_spawn_location_node: Node2D = $"../spawn locations" # the node that contain all the locations that the enemy can spawn
var spawn_locations_list: Array = [] # a list to contain all the areas that the enemy can spawn in
var spawn_location # the location that got chosen
	
func spawning_enemy() -> void:
	for location in enemy_spawn_location_node.get_children():
		spawn_locations_list.append(location)
	spawn_location = spawn_locations_list.pick_random().get_node("CollisionShape2D")
	var size = (spawn_location.shape as RectangleShape2D).size
	var random_x = randf_range(spawn_location.global_position.x - size.x / 2,spawn_location.global_position.x + size.x / 2)
	print("spawn location(enemy): " + str(spawn_location))
	self.global_position.y = spawn_location.global_position.y
	self.global_position.x = random_x
	spawn_animation.visible = true
	spawn_animation.play()

func spawn_enemy() -> void:
	match GlobalVariables.danger_level:
		0:
			enemy_to_spawn = "enemy_1"
			respawn_timer.wait_time = randi_range(18, 20)
		1:
			if randi_range(1, 15) == 1:
				enemy_to_spawn = "enemy_2"
			else:
				enemy_to_spawn = "enemy_1"
			respawn_timer.wait_time = randi_range(12, 14)
		2:
			if randi_range(1, 12) == 1:
				enemy_to_spawn = "enemy_2"
			else:
				enemy_to_spawn = "enemy_1"
			respawn_timer.wait_time = randi_range(11, 13)
		3:
			if randi_range(1, 8) == 1:
				enemy_to_spawn = "enemy_2"
			else:
				enemy_to_spawn = "enemy_1"
			respawn_timer.wait_time = randi_range(10, 12)
		4:
			if randi_range(1, 6) == 1:
				enemy_to_spawn = "enemy_2"
			else:	
				enemy_to_spawn = "enemy_1"
			respawn_timer.wait_time = randi_range(9, 11)
		5:
			if randi_range(1, 5) == 1:
				enemy_to_spawn = "enemy_2"
			else:
				enemy_to_spawn = "enemy_1"
			respawn_timer.wait_time = randi_range(6, 8)

	if enemy_to_spawn == "enemy_1":
		enemy = enemy_1_scene.instantiate() # copy the scene(the enemy) into a var called enemy_1
	elif enemy_to_spawn == "enemy_2":
		enemy = enemy_2_scene.instantiate() # copy the scene(the enemy) into a var called enemy_1
	elif enemy_to_spawn == "enemy_3":
		enemy = enemy_3_scene.instantiate() # copy the scene(the enemy) into a var called enemy_1
	
	get_parent().get_parent().add_child(enemy) # add the enemy_1 to the enemies node
	enemy.global_position = self.global_position
	print("enemy_1 created in " , enemy.global_position)
func _process(_delta: float) -> void:
	if len(self.get_tree().get_nodes_in_group("enemy_1")) <= 6 and respawn_timer.is_stopped():
		print(len(self.get_tree().get_nodes_in_group("enemy_1")))
		respawn_timer.start()
		
	if animation_finished_counter == 3:
		spawn_animation.stop()
		animation_finished_counter = 0
		spawn_animation.visible = false
		spawn_enemy()



func _on_animated_sprite_2d_animation_looped() -> void:
	animation_finished_counter += 1


func _on_respawn_timer_timeout() -> void:
	if animation_finished_counter != 3 and spawn_animation.is_visible_in_tree():
		animation_finished_counter = 3
	spawning_enemy()
