extends Node2D
@onready var reload_timer: Timer = $"reload timer"
var can_attack = true
@onready var sword_sprite: Sprite2D = $Sprite2D
@onready var sword_sfx: AudioStreamPlayer = $sword_sfx
func _process(_delta: float) -> void:
	# change the place that the sword is facing to if the attack ended
	if reload_timer.is_stopped():
		if get_global_mouse_position().x > $"..".global_position.x:
			sword_sprite.position.x = 155
			sword_sprite.flip_h = false
			$hitbox.position.x = 221
		elif get_global_mouse_position().x < $"..".global_position.x:		
			sword_sprite.position.x = -155
			sword_sprite.flip_h = true
			$hitbox.position.x = -221

	if Input.is_action_just_pressed("slash") and can_attack:
		attack()


func attack() -> void:
	#var attack_animation_tween = create_tween()
	#attack_animation_tween.tween_property(sword_sprite, "rotation" , PI, 0.25)
	sword_sfx.pitch_scale = randf_range(0.75, 1.25)
	#sword_sfx.play()
	self.visible = true
	$hitbox/CollisionShape2D.disabled = false
	can_attack = false
	reload_timer.start()
	await self.get_tree().create_timer(0.25).timeout
	self.visible = false
	$hitbox/CollisionShape2D.disabled = true
	sword_sprite.rotation = 0
	# if the player have the faster sword recharge
	if GlobalVariables.abilities.get("faster_sword_recharge"):
		reload_timer.wait_time = 0.25

func _on_reload_timer_timeout() -> void:
	can_attack = true
