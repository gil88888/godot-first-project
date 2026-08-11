extends Area2D

var   jump_block_disabled: bool = false
var can_jump: bool = false
@onready var timer = $Timer
var timer_flag: bool = true
@onready var animation = $AnimatedSprite2D
var velocity_y: int = -1200
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("jump") and can_jump:
		jump_block_disabled = true

	if jump_block_disabled == true and timer_flag:
		timer_flag = false
		animation.animation = "jump_block_disabled_anim"
		timer.start()




func _on_area_exited(area: Area2D) -> void:
	if area.is_in_group("player"):
		can_jump = false

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		can_jump = true


func _on_timer_timeout() -> void:
	jump_block_disabled = false
	timer_flag = true
	animation.animation = "jump_block_enabled_anim"
