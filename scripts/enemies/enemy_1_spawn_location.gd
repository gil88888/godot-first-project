extends Marker2D

var enemy_1_scene = preload("res://scenes/enemy_1.tscn")
var enemy_1 = null
var enemy_1_is_on_screen: bool = false
var spawn_loc_on_screen: bool = false
@onready var respawn_time: Timer = $"respawn time"
	
func _ready() -> void:
	call_deferred("spawn_enemy")


func _process(_delta: float) -> void:
	## if enemy_1 is not a valid thing, restart the function
	#if not is_instance_valid(enemy_1):
		#return
	#if not enemy_1_is_on_screen:
			#spawn_loc_on_screen = false
			#if not enemy_1.get_node("VisibleOnScreenNotifier2D").enemy_1_on_screen and is_instance_valid(enemy_1):
				#respawn_time.start()
				#print("started")
			#print(not enemy_1.get_node("VisibleOnScreenNotifier2D").enemy_1_on_screen , is_instance_valid(enemy_1))
	#else:
		#spawn_loc_on_screen = true
		#respawn_time.stop()
		#if not is_instance_valid(enemy_1):
			#call_deferred("spawn_enemy")
	# unsynced
	if not enemy_1.get_node("VisibleOnScreenNotifier2D").enemy_1_on_screen and is_instance_valid(enemy_1) and spawn_loc_on_screen:
		respawn_time.start()
		print("started")
	if is_instance_valid(enemy_1):
		print(not enemy_1.get_node("VisibleOnScreenNotifier2D").enemy_1_on_screen, spawn_loc_on_screen)


func spawn_enemy() -> void:
	# if enemy_1 is not a valid thing, stop the function
	if is_instance_valid(enemy_1):
		return

	enemy_1 = enemy_1_scene.instantiate() # copy the scene(the enemy) into a var called enemy_1
	get_parent().add_child(enemy_1) # add the enemy_1 to the enemies node
	enemy_1.global_position = self.global_position # make the enemy_! position the marker position
	print("created")

# if the enemy and the mark is not on the screen and enemy is a valid thing start a timer that remove the enemy
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	spawn_loc_on_screen = false

# if the enemy and the mark is *on* the screen and enemy is *not* a valid thing add an enemy
func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	spawn_loc_on_screen = true
	respawn_time.stop()
	if not is_instance_valid(enemy_1):
		call_deferred("spawn_enemy")
		
# if the enemy is still not on the screen and also the the spawn location delete the enemy
func _on_respawn_time_timeout() -> void:
	if is_instance_valid(enemy_1):

		if not enemy_1.get_node("VisibleOnScreenNotifier2D").enemy_1_on_screen:
			enemy_1.queue_free()
			enemy_1 = null
			print("deleted")
