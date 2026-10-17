extends Node2D
@onready var teleporter1: Area2D = $teleporter1
@onready var teleporter2: Area2D = $teleporter2
@onready var player: CharacterBody2D = $"../../../Character/Player body"
@onready var portal_open_sprite = preload("res://resources/sprites/teleporter open.png")
@onready var portal_close_sprite = preload("res://resources/sprites/teleporter close.png")
var can_teleport: bool = false
var portals_active: bool = true
func teleport_player(location: Vector2) -> void:
	GlobalVariables.player_can_move = false
	player.visible = false
	portals_active = false
	await get_tree().create_timer(1).timeout
	player.global_position = location
	GlobalVariables.player_can_move = true
	player.visible = true
	await get_tree().create_timer(3).timeout
	portals_active = true

func _process(delta: float) -> void:
	if portals_active:
		print("open")
		$teleporter1/Sprite2D.texture = portal_open_sprite
		$teleporter2/Sprite2D.texture = portal_open_sprite
	else:
		print("close")
		$teleporter1/Sprite2D.texture = portal_close_sprite
		$teleporter2/Sprite2D.texture = portal_close_sprite

func _on_teleporter_1_area_entered(area: Area2D) -> void:
	if area.is_in_group("player") and portals_active and can_teleport:
		teleport_player(teleporter2.get_node("CollisionShape2D").global_position)



func _on_teleporter_2_area_entered(area: Area2D) -> void:
	if area.is_in_group("player") and portals_active and can_teleport:
		teleport_player(teleporter1.get_node("CollisionShape2D").global_position)

		

func _on_teleporter_1_anti_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		can_teleport = false


func _on_teleporter_1_anti_hitbox_area_exited(area: Area2D) -> void:
	if area.is_in_group("player"):
		can_teleport = true

func _on_teleporter_2_anti_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		can_teleport = false

func _on_teleporter_2_anti_hitbox_area_exited(area: Area2D) -> void:
	if area.is_in_group("player"):
		can_teleport = true
