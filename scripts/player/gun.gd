extends Sprite2D

var bullet_speed: int = 1000
var reload_time: float = 0.3 # 0.5
var shoot_flag: bool = true
@onready var player: CharacterBody2D = $".."
@onready var timer: Timer = $reload_time
#@export var gun_bullet_scene: PackedScene
var gun_bullet_scene := preload("res://scenes/gun_bullet.tscn")

func _process(_delta: float) -> void:
	# if left click is pressed and the reload time flag is true
	if Input.is_action_pressed("shoot") and shoot_flag:
		# disable the reload flag until the gun is ready
		shoot_flag = false
		timer.wait_time = reload_time
		timer.start()
		
		# start creating the bullet
		var gun_bullet = gun_bullet_scene.instantiate()
		get_tree().current_scene.add_child(gun_bullet)
		gun_bullet.global_position = self.global_position
		gun_bullet.bullet_direction = global_position.direction_to(get_global_mouse_position())
		gun_bullet.bullet_rotation = gun_bullet.bullet_direction.angle()
		# check where is your mouse pointing to
		#if get_global_mouse_position().x > player.global_position.x:
			#gun_bullet.direction = Vector2.RIGHT
			#for child in player.get_children():
				#if child is Sprite2D:	
					#child.flip_h = false
		#else:
			#gun_bullet.direction = Vector2.LEFT
			#for child in player.get_children():
				#if child is Sprite2D:	
					#child.flip_h = true
					
# make the reload flag true again 
func _on_reload_time_timeout() -> void:
	shoot_flag = true
	
