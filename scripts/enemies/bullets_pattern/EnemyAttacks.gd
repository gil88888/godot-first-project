class_name Enemy1Attacks
extends RefCounted

var enemy: Node2D
var tree
var tween

func _init(enemy_ref: Node2D) -> void:
	enemy = enemy_ref
	tree = enemy.get_tree()


func attack_pattern(starting_place: Vector2, ending_place: Vector2, bullet: Node2D, bullet_speed: int, stop_in_the_air_time: float ,infinite_x: bool = false, infinite_y: bool = false, rotate: bool = false, move_x: bool = true, move_y: bool = true) -> Tween:
	tree.current_scene.add_child(bullet)
	
	bullet.global_position = starting_place
	var target_place: Vector2
	if ending_place.x > bullet.global_position.x:
		if infinite_x and infinite_y:
			target_place = ending_place + Vector2(10000, 10000)
		elif infinite_x:
			target_place = ending_place + Vector2(10000, 0)
		elif infinite_y:
			target_place = ending_place + Vector2(0, 10000)
		else:
			target_place = ending_place
	else:
		if infinite_x and infinite_y:
			target_place = ending_place + Vector2(-10000, 10000)
		elif infinite_x:
			target_place = ending_place + Vector2(-10000, 0)
		elif infinite_y:
			target_place = ending_place + Vector2(0, 10000)
		else:
			target_place = ending_place
	
	var distance_y = abs(bullet.global_position.y - target_place.y)
	var distance_x = abs(bullet.global_position.x - target_place.x)
	var duration_y = distance_y / bullet_speed
	var duration_x = distance_x / bullet_speed
	if rotate:
		bullet.get_node("Sprite2D").rotation = bullet.global_position.angle_to_point(target_place)
	await tree.create_timer(stop_in_the_air_time).timeout
	if is_instance_valid(bullet):
		tween = bullet.create_tween()
		if move_y:
			tween.tween_property(bullet, "global_position:y", target_place.y, duration_y)
		if move_x:
			tween.parallel().tween_property(bullet, "global_position:x", target_place.x, duration_x)
	else:
		print("deleted")
	return tween
