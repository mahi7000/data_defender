extends Node2D

var current_score: int = 0
var player_lives: int = 3
var current_level: int = 1
var game_running: bool = true

func _ready():
	EventBus.enemy_died.connect(_on_enemy_died)
	EventBus.file_hit.connect(_on_file_hit)
	EventBus.player_damaged.connect(_on_player_damaged)

func _on_enemy_died(enemy_type: String, position: Vector2, points: int):
	if !game_running: return
	current_score += points
	EventBus.score_changed.emit(current_score)
	EventBus.update_ui_score.emit(current_score)

func _on_file_hit(file):
	if !game_running: return
	current_score = max(0, current_score - 50)
	EventBus.score_changed.emit(current_score)
	EventBus.update_ui_score.emit(current_score)
	EventBus.show_message.emit("Protected File Hit! -50 points", 1.5)

func _on_player_damaged(damage: int):
	player_lives -= damage
	EventBus.update_ui_lives.emit(player_lives)
	
	if player_lives <= 0:
		game_running = false
		EventBus.game_over.emit(current_score)

func start_level(level: int):
	current_level = level
	EventBus.level_changed.emit(level)
