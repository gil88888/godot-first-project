extends AnimatedSprite2D
@onready var despawn_timer: Timer = $"../despawn timer"
var despawn_flag: bool = false

func despawn_animation() -> void:
	for i in range(1000):
		if i % 2 == 0:
			visible = true
			print("invisible")
		else:
			print("visible")
			visible = false
		await get_tree().create_timer(0.25).timeout
	
func _ready() -> void:
	var tween = self.create_tween()
	tween.set_loops()
	tween.tween_property(self, "position:y", 5, 0.7)
	tween.tween_property(self, "position:y", -5, 0.7)
	despawn_timer.start()

func _process(delta: float) -> void:
	if despawn_timer.time_left <= 3 and not despawn_flag:
		despawn_flag = true
		despawn_animation()
		
		
func _on_animation_finished() -> void:
	await self.get_tree().create_timer(1).timeout
	self.play()


func _on_despawn_timer_timeout() -> void:
	self.get_parent().queue_free()
	print("healing potion deleted")
