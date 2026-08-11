extends Node2D


@onready var screen_ui =  $"../../CanvasLayer/Control"
@onready var label = screen_ui.get_node("Label")
@onready var texture_rect = screen_ui.get_node("TextureRect")

func show_hp() -> void:
	texture_rect.position = texture_rect.position.move_toward(Vector2(0, 123), 500)
	label.position = label.position.move_toward(Vector2(0, 123), 500)	
	print("work")
	
func _ready():
	#show_hp()
	label.text = str(GlobalVariables.player_hp)
	pass
