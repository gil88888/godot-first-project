extends Marker2D

var enemy_1_scene = preload("res://scenes/enemy_1.tscn")
var enemy_1 = null

var enemy_1_is_on_screen: bool = false
var spawn_loc_on_screen: bool = false


func _ready() -> void:
	call_deferred("spawn_enemy")


func _process(_delta: float) -> void:
	# if enemy_1 is not a valid thing, restart the function
	if not is_instance_valid(enemy_1):
		return
	# enemy_1_is_on_screen is now equal to the variable enemy_1_on_screen in the visible on screen notfier node
	enemy_1_is_on_screen = enemy_1.get_node(
		"VisibleOnScreenNotifier2D"
	).enemy_1_on_screen


func spawn_enemy() -> void:
	# if enemy_1 is not a valid thing, stop the function
	if is_instance_valid(enemy_1):
		return

	enemy_1 = enemy_1_scene.instantiate() # copy the scene(the enemy) into a var called enemy_1
	get_parent().add_child(enemy_1) # add the enemy_1 to the enemies node
	enemy_1.global_position = self.global_position # make the enemy_! position the marker position

# if the enemy and the mark is not on the screen and enemy is a valid thing remove enemy
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	spawn_loc_on_screen = false
	if not enemy_1_is_on_screen and is_instance_valid(enemy_1):
		enemy_1.queue_free()
		enemy_1 = null

# if the enemy and the mark is *on* the screen and enemy is *not* a valid thing add an enemy
func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	# if 
	spawn_loc_on_screen = true

	if not is_instance_valid(enemy_1):
		call_deferred("spawn_enemy")
