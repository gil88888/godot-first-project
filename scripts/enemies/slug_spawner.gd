extends Marker2D

var slug_scene = preload("res://scenes/slug_enemy.tscn")
var slug = null
var animation_finished_counter: int = 0
var enemy_to_spawn: String = "slug"
@onready var respawn_timer: Timer = $respawn_timer
@onready var enemy_spawn_location_node: Node2D = $"../spawn locations" # the node that contain all the locations that the enemy can spawn
var spawn_locations_list: Array = [] # a list to contain all the areas that the enemy can spawn in
var spawn_location # the location that got chosen
func _ready() -> void:
	spawning_enemy()

	
func spawning_enemy() -> void:
	for location in enemy_spawn_location_node.get_children():
		spawn_locations_list.append(location)
	spawn_location = spawn_locations_list.pick_random().get_node("CollisionShape2D")
	var size = (spawn_location.shape as RectangleShape2D).size
	var random_x = randf_range(spawn_location.global_position.x - size.x / 2,spawn_location.global_position.x + size.x / 2)
	print("spawn location(enemy): " + str(spawn_location))
	self.global_position.y = spawn_location.global_position.y
	self.global_position.x = random_x
	spawn_enemy()

func spawn_enemy() -> void:
	match GlobalVariables.danger_level:
		0:
			respawn_timer.wait_time = randi_range(10, 12)
		1:
			respawn_timer.wait_time = randi_range(9, 12)
		2:
			respawn_timer.wait_time = randi_range(9, 11)
		3:
			respawn_timer.wait_time = randi_range(8, 11)
		4:
			respawn_timer.wait_time = randi_range(8, 10)
		5:
			respawn_timer.wait_time = randi_range(6, 8)
		6:
			respawn_timer.wait_time = 5
		7:
			respawn_timer.wait_time = 4
		8:
			respawn_timer.wait_time = 3
	if enemy_to_spawn == "slug":
		slug = slug_scene.instantiate()
		get_parent().add_child.call_deferred(slug)
		slug.global_position = self.global_position
		print("slug created in" , slug.global_position)

func _process(_delta: float) -> void:
	if len(self.get_tree().get_nodes_in_group("slug")) <= 10 and respawn_timer.is_stopped():
		respawn_timer.start()


func _on_animated_sprite_2d_animation_looped() -> void:
	animation_finished_counter += 1


func _on_respawn_timer_timeout() -> void:
	spawning_enemy()
