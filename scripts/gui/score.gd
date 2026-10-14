extends Label

var score_adder_scene := preload("res://scenes/score_adder.tscn")
var next_ability_score_goal: int = 2000
var power_chooser_scene = preload("res://scenes/power_chooser.tscn")
var power_chooser
func _ready() -> void:
	GlobalVariables.score_label = self
	
# update the score text infinitly
func _process(_delta: float) -> void:
	self.text = "score: " + str(GlobalVariables.score)
	# check if the player reach the next score goal if so pop-up the power chooser screen
	if GlobalVariables.score >= next_ability_score_goal:
		$"../../..".modulate.a = 0.3 # game transperency
		# ui visible:
		$"../hp".visible = false
		$".".visible = false
		$"../dash meter".visible = false
		$"../pause button".visible = false
		power_chooser = power_chooser_scene.instantiate()
		if GlobalVariables.danger_level != 4:
			GlobalVariables.danger_level += 1
		next_ability_score_goal += 2000
		GlobalVariables.game_stopped = true
		$"../pause button".process_mode = Node.PROCESS_MODE_DISABLED
		self.get_parent().add_child(power_chooser)
	if power_chooser != null:
		if power_chooser.get_meta("delete"):
			$"../../..".modulate.a = 1 # game transperency
			# ui visible:
			$"../hp".visible = true
			$".".visible = true
			$"../dash meter".visible = true
			$"../pause button".visible = true
			power_chooser.queue_free()
		
func add_score(score) -> void:
	# make the text appear and add the score
	GlobalVariables.score += score
	if GlobalVariables.score > GlobalVariables.best_score:
		GlobalVariables.best_score = GlobalVariables.score
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
