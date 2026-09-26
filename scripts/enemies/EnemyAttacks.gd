class_name Enemy1Attacks
extends RefCounted

var enemy: Node2D

func _init(enemy_ref: Node2D) -> void:
	enemy = enemy_ref
	

func attack_pattern(starting_place: Vector2, ending_place: Vector2, bullet: Node2D, bullet_speed):
	enemy.get_tree().current_scene.add_child(bullet)
	bullet.global_position = starting_place
	var target_place = null
	if ending_place.x > bullet.global_position.x:
		target_place = ending_place + Vector2(10000, 10000)
	else:
		target_place = ending_place + Vector2(-10000, 10000)
	var distance_y = abs(bullet.global_position.y - target_place.y)
	var distance_x = abs(bullet.global_position.x - target_place.x)
	var duration_y = distance_y / bullet_speed
	var duration_x = distance_x / bullet_speed
	bullet.get_node("Sprite2D").rotation = bullet.global_position.angle_to_point(target_place)
	await enemy.get_tree().create_timer(0.5).timeout
	var tween = bullet.create_tween()
	tween.tween_property(bullet, "global_position:y", target_place.y, duration_y)
	tween.parallel().tween_property(bullet, "global_position:x", target_place.x, duration_x)
