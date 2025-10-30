extends CanvasLayer

@onready var score_label = $HBoxContainer/ScoreLabel
@onready var lives_label = $HBoxContainer/LivesLabel
@onready var message_label = $MessageLabel

func _ready():
	EventBus.update_ui_score.connect(_on_update_score)
	EventBus.update_ui_lives.connect(_on_update_lives)
	EventBus.show_message.connect(_on_show_message)

func _on_update_score(score: int):
	score_label.text = "SCORE: %08d" % score

func _on_update_lives(lives: int):
	lives_label.text = "LIVES: %d" % lives

func _on_show_message(message: String, duration: float):
	message_label.text = message
	message_label.visible = true
	
	var tween = create_tween()
	tween.tween_interval(duration)
	tween.tween_callback(func(): message_label.visible = false)

func show_game_over(final_score: int):
	# You'll implement this later
	pass
