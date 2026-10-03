extends Node2D

var healing_potion_scene = preload("res://scenes/healing_potion.tscn")
var healing_potion = null
var spawn_locations_list: Array = [] # a list to contain all the areas that the potion can spawn in
var spawn_location # the location that got chosen
var animation_finished_counter: int = 0 # for the animation


func spawning_potion() -> void:
	for location in $"../spawn locations".get_children():
		spawn_locations_list.append(location)
	spawn_location = spawn_locations_list.pick_random().get_node("CollisionShape2D")
	var size = (spawn_location.shape as RectangleShape2D).size
	var random_x = randf_range(spawn_location.global_position.x - size.x / 2,spawn_location.global_position.x + size.x / 2)
	self.global_position.y = spawn_location.global_position.y - 30
	self.global_position.x = random_x
	$AnimatedSprite2D.visible = true
	$AnimatedSprite2D.play()
	
func spawn_potion() -> void:
		healing_potion = healing_potion_scene.instantiate() # copy the scene(the potion) into a var called healing_potion
		get_parent().add_child(healing_potion) # add the potion to the spawners node
		healing_potion.global_position = self.global_position # make the healing_potion position the marker position
		match GlobalVariables.danger_level:
			0:
				$respawn_timer.wait_time = randi_range(12, 20)
			1:
				$respawn_timer.wait_time = randi_range(14, 23)
			2:
				$respawn_timer.wait_time = randi_range(16, 26)
			3:
				$respawn_timer.wait_time = randi_range(18, 29)
			4:
				$respawn_timer.wait_time = randi_range(20, 32)
		$respawn_timer.start()
		
		
func _process(_delta: float) -> void:
	if animation_finished_counter == 3:
		$AnimatedSprite2D.stop()
		animation_finished_counter = 0
		$AnimatedSprite2D.visible = false
		spawn_potion()
		
		
		
		
func _on_animated_sprite_2d_animation_looped() -> void:
	animation_finished_counter += 1


func _on_respawn_timer_timeout() -> void:
	spawning_potion()
