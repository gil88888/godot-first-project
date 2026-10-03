extends Marker2D
var flying_enemy_scene = preload("res://scenes/flying_enemy.tscn")
var flying_enemy = null
var spawn_locations_list: Array = [] # a list to contain all the areas that the enemy can spawn in
var spawn_location = null# the location that got chosen
var move_enemy_on_spawn = false


func spawn_enemy() -> void:
	for location in $"../spawn locations2".get_children():
		spawn_locations_list.append(location)
	spawn_location = spawn_locations_list.pick_random().get_node("CollisionShape2D")
	var size = (spawn_location.shape as RectangleShape2D).size
	var random_x = randf_range(spawn_location.global_position.x - size.x / 2,spawn_location.global_position.x + size.x / 2)
	self.global_position.y = spawn_location.global_position.y - 1000
	self.global_position.x = random_x
	move_enemy_on_spawn = true
	flying_enemy = flying_enemy_scene.instantiate() # copy the scene(the potion) into a var called healing_potion
	get_parent().add_child(flying_enemy) # add the potion to the spawners node
	flying_enemy.global_position = self.global_position # make the healing_potion position the marker position
	print("spawned")
	
func _process(delta: float) -> void:
	if spawn_location != null and flying_enemy != null:
		if move_enemy_on_spawn:
			flying_enemy.global_position = flying_enemy.global_position.move_toward(Vector2(self.global_position.x, spawn_location.global_position.y), (400 * delta))
		if flying_enemy.global_position.y == spawn_location.global_position.y:
			move_enemy_on_spawn = false
	if self.get_tree().get_nodes_in_group("flying enemy") == [] and $"respawn timer".is_stopped():
		print("start")
		$"respawn timer".start()

func _on_respawn_timer_timeout() -> void:
	spawn_enemy()
