extends Control

@onready var lose_text: Label = $"you lose text"
@onready var score_text: Label = $"score text"
@onready var best_score_text: Label = $"best score text"
func _ready() -> void:
	var lose_text_tween = lose_text.create_tween()
	lose_text_tween.tween_property(lose_text, "global_position", Vector2(716, 800), 4)
	var score_text_tween = score_text.create_tween()
	score_text.text = "you got " + str(GlobalVariables.score) + " score"
	score_text_tween.tween_property(score_text, "global_position", Vector2(716, 300) , 3)
	best_score_text.text = "your best score: " + str(GlobalVariables.best_score)
	best_score_text.modulate.a = 0
	await self.get_tree().create_timer(3).timeout
	var best_score_text_tween = score_text.create_tween()
	best_score_text_tween.tween_property(best_score_text, "modulate:a", 1, 1)
