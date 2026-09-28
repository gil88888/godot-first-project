extends Label

var score_adder_scene := preload("res://scenes/score_adder.tscn")


func _ready() -> void:
	GlobalVariables.score_label = self
	
# update the score text infinitly
func _process(_delta: float) -> void:
		self.text = "score: " + str(GlobalVariables.score)
		
func add_score(score) -> void:
	# make the text appear and add the score
	GlobalVariables.score += score
	var score_adder = score_adder_scene.instantiate()
	self.get_parent().add_child(score_adder)
	score_adder.global_position = Vector2(1070, 50)
	score_adder.text = "+" + str(score)
	score_adder.scale = Vector2(2, 2)
	score_adder.rotation = -45
	# change the color according to the amount of score:

	if 0 < score and score < 4:
		score_adder.visible = false
	elif 3 < score and score < 20:
		score_adder.modulate = Color(255.0, 255.0, 61.0, 1.0)
	else:
		score_adder.modulate = Color(1.0, 1.0, 0.239, 1.0)
		
	# make the text animation
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(score_adder, "global_position" ,score_adder.global_position + Vector2(50, 50),0.4)
	tween.tween_property(score_adder, "modulate:a", 0, 0.4)
	tween.set_parallel(false)
	tween.tween_callback(score_adder.queue_free)
