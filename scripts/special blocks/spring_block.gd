extends StaticBody2D

@onready var spring_sprite: AnimatedSprite2D = $"spring animation sprites"
@onready var spring_block_hitbox: CollisionShape2D = self.get_node("hitbox")
var spring_pressed: bool = false
var area_entered: bool = false
var area2_entered: bool = false
var spring_ready: bool = false # for the player body file

func _process(_delta: float) -> void:
	if area2_entered and area_entered:
		spring_sprite.play()
		spring_pressed = true
	else:
		spring_sprite.stop()
		spring_sprite.frame = 0
		spring_block_hitbox.position.y = 3100000
		spring_pressed = false
		spring_ready = false
	if spring_pressed:
		spring_block_hitbox.position.y += 1


func _on_jumping_place_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		area_entered = true
		print("area")
func _on_jumping_place_hitbox_area_exited(area: Area2D) -> void:
	if area.is_in_group("player"):
		area_entered = false
		print("unarea")
		
func _on_spring_animation_sprites_frame_changed() -> void:
	if spring_sprite.frame == 4:
		spring_block_hitbox.position.y = 3100000
		spring_ready = true


func _on_player_position_check_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		area2_entered = true

func _on_player_position_check_area_exited(area: Area2D) -> void:
	if area.is_in_group("player"):
		area2_entered = false
