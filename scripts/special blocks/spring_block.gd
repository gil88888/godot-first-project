extends StaticBody2D

@onready var spring_sprite: AnimatedSprite2D = $"spring animation sprites"
@onready var spring_block_hitbox: CollisionShape2D = $hitbox
var spring_pressed: bool = false
var spring_ready: bool = false

func _process(_delta: float) -> void:
	if spring_pressed:
		spring_block_hitbox.global_position.y += 1
	

func _on_jumping_place_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		spring_sprite.play()
		spring_pressed = true
		
func _on_jumping_place_hitbox_area_exited(area: Area2D) -> void:
	if area.is_in_group("player"):
		spring_sprite.stop()
		spring_sprite.frame = 0
		spring_block_hitbox.position.y = +3100000
		spring_pressed = false
		spring_ready = false

func _on_spring_animation_sprites_frame_changed() -> void:
	if spring_sprite.frame == 4:
		spring_block_hitbox.position.y = +3100000
		spring_ready = true
