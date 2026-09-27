extends Sprite2D

var bullet_speed: int = 1000
var shoot_flag: bool = true
@onready var player: CharacterBody2D = $".."
@onready var timer: Timer = $reload_time
var gun_bullet_scene := preload("res://scenes/gun_bullet.tscn")

func _process(_delta: float) -> void:
	# if left click is pressed and the reload time flag is true
	if Input.is_action_pressed("shoot") and shoot_flag:
		# disable the reload flag until the gun is ready
		shoot_flag = false
		timer.start()
		
		# start creating the bullet
		var gun_bullet = gun_bullet_scene.instantiate()
		get_tree().current_scene.add_child(gun_bullet)
		gun_bullet.global_position = self.global_position
		gun_bullet.bullet_direction = global_position.direction_to(get_global_mouse_position())
		gun_bullet.bullet_rotation = gun_bullet.bullet_direction.angle()

					
# make the reload flag true again 
func _on_reload_time_timeout() -> void:
	shoot_flag = true
	
