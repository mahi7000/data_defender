extends Node2D

@onready var game_manager = $GameManager
@onready var ui = $UI

func _ready():
	EventBus.game_over.connect(_on_game_over)
	
func _on_game_over(final_score):
	ui.show_game_over(final_score)
