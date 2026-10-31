extends Node2D
var moving: bool = false
const speed: int = 200
@onready var moving_place: Area2D = $"moving place"
@onready var despawn_timer: Timer = $"despawn timer"
var enemies_detected = []
var bullets_detected: Array = []
var animation_flag: bool = false
var distance = null
var duration = null
var place_to_move = null
var enemy_to_bait = null
var bullet_to_bait = null
var crash_detector_1 = 0
var crash_detector_2 = 0
var crash_detector_3 = 0

func despawn_animation() -> void:
	for i in range(1000):
		if i % 2 == 0:
			visible = true
		else:
			visible = false
		await get_tree().create_timer(0.1).timeout

func get_random_position() -> Vector2:
	var shape: CircleShape2D = moving_place.get_node("CollisionShape2D").shape
	var random_position = Vector2.RIGHT.rotated(randf_range(0.0, TAU)) * sqrt(randf()) * shape.radius

	return moving_place.to_global(random_position)

func move_fly(tween: Tween, place, duration_time) -> void:
	tween.tween_property(self, "global_position", place, duration_time)
	
func _process(_delta: float) -> void:

	if moving:
		moving = false
		var moving_tween = create_tween()
		#print("enemies detected " + str(len(enemies_detected)))
		if len(enemies_detected) == 0:
			place_to_move = get_random_position()
			while place_to_move.x > get_meta("place_positon").x + 500 or place_to_move.x < get_meta("place_positon").x - 500 or place_to_move.y > get_meta("place_positon").y + 500 or place_to_move.y < get_meta("place_positon").y - 500 :
				place_to_move = get_random_position()
				crash_detector_1 += 1
				if crash_detector_1 > 1000:
					push_error("place error")
					return
			if not crash_detector_1 > 1000:
				distance = global_position.distance_to(place_to_move)
				duration = distance / speed
			else:
				crash_detector_1 = 0
		elif len(bullets_detected) != 0:
			place_to_move = bullet_to_bait.global_position
			if place_to_move.x > get_meta("place_positon").x + 500 or place_to_move.x < get_meta("place_positon").x - 500 or place_to_move.y > get_meta("place_positon").y + 500 or place_to_move.y < get_meta("place_positon").y - 500 :
				place_to_move = bullet_to_bait.global_position
				crash_detector_2 += 1
				if crash_detector_2 > 1000:
					push_error("bullet error")
			if not crash_detector_2 > 1000:
				distance = global_position.distance_to(place_to_move)
				duration = (distance / speed) / 4
			else:
				crash_detector_2 = 0
		else:
			place_to_move = enemy_to_bait.global_position
			if place_to_move.x > get_meta("place_positon").x + 500 or place_to_move.x < get_meta("place_positon").x - 500 or place_to_move.y > get_meta("place_positon").y + 500 or place_to_move.y < get_meta("place_positon").y - 500 :
				place_to_move = enemy_to_bait.global_position
				crash_detector_3 += 1
				if crash_detector_3 > 1000:
					push_error("enemy error")
			if not crash_detector_3 > 1000:
				distance = global_position.distance_to(place_to_move)
				duration = (distance / speed) / 2
			else:
				crash_detector_3 = 0
		move_fly(moving_tween, place_to_move, duration)
		await moving_tween.finished
		$"movement cooldown".start()

func _on_movement_cooldown_timeout() -> void:
	moving = true

func _on_moving_place_area_entered(area: Area2D) -> void:
	if area.is_in_group("detectable_bullet"):
		bullets_detected.append(area)
		bullet_to_bait = bullets_detected.pick_random()
		
	if area.is_in_group("enemies area"):
		enemies_detected.append(area)
		enemy_to_bait = enemies_detected.pick_random()
	
	
func _on_moving_place_area_exited(area: Area2D) -> void:
	if area.is_in_group("detectable_bullet"):
		bullets_detected.erase(area)
		if bullets_detected != []:
			bullet_to_bait = bullets_detected.pick_random()
			
	if area.is_in_group("enemies area"):
		enemies_detected.erase(area)
		if enemies_detected != []:
			enemy_to_bait = enemies_detected.pick_random()

func _on_despawn_timer_timeout() -> void:
	despawn_animation()
	await get_tree().create_timer(3).timeout
	queue_free()
