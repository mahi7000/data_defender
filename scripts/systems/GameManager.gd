extends Node

var current_score: int = 0
var current_level: int = 1
var player_lives: int = 3
var game_state: String = "menu" # menu, playing, paused, game_over
var high_score: int = 0

func _ready():
	# Connect to events from your EventBus
	EventBus.enemy_died.connect(_on_enemy_died)
	EventBus.file_hit.connect(_on_file_hit)
	EventBus.player_damaged.connect(_on_player_damaged)
	EventBus.player_died.connect(_on_player_died)
	EventBus.level_complete.connect(_on_level_complete)
	
	# Load high score if saved
	load_high_score()

func start_game():
	current_score = 0
	current_level = 1
	player_lives = 3
	game_state = "playing"
	
	# Update UI through signals
	EventBus.update_ui_score.emit(current_score)
	EventBus.update_ui_lives.emit(player_lives)
	EventBus.level_changed.emit(current_level)
	EventBus.show_message.emit("LEVEL " + str(current_level), 2.0)

func change_score(amount: int):
	current_score += amount
	if current_score < 0:
		current_score = 0
	
	EventBus.score_changed.emit(current_score)
	EventBus.update_ui_score.emit(current_score)
	
	# Update high score if needed
	if current_score > high_score:
		high_score = current_score
		save_high_score()

func _on_enemy_died(enemy_type: String, position: Vector2, points: int):
	change_score(points)

func _on_file_hit(file):
	# Penalty for hitting files
	change_score(-50)
	EventBus.show_message.emit("Critical File Hit! -50", 1.5)

func _on_player_damaged(damage_amount: int):
	player_lives -= damage_amount
	EventBus.update_ui_lives.emit(player_lives)
	
	if player_lives <= 0:
		player_lives = 0
		EventBus.player_died.emit()

func _on_player_died():
	game_over()

func _on_level_complete():
	current_level += 1
	EventBus.level_changed.emit(current_level)
	EventBus.show_message.emit("LEVEL " + str(current_level) + " COMPLETE!", 3.0)

func game_over():
	game_state = "game_over"
	EventBus.game_over.emit(current_score)
	EventBus.show_message.emit("GAME OVER - Final Score: " + str(current_score), 5.0)

func get_current_level() -> int:
	return current_level

func save_high_score():
	var config = FileAccess.open("user://highscore.save", FileAccess.WRITE)
	config.store_32(high_score)

func load_high_score():
	if FileAccess.file_exists("user://highscore.save"):
		var config = FileAccess.open("user://highscore.save", FileAccess.READ)
		high_score = config.get_32()
		
func show_level_intro():
	EventBus.show_message.emit("LEVEL " + str(current_level), 2.0)
	# You can add more intro sequences here

func show_powerup_message(powerup_type: String):
	var messages = {
		"firewall": "FIREWALL ACTIVATED!",
		"speed": "SPEED BOOST!",
		"shield": "SHIELD ACTIVATED!"
	}
	EventBus.show_message.emit(messages.get(powerup_type, "POWER UP!"), 2.0)

# Call this when Coder B implements powerups
func _on_powerup_collected(powerup_type: String):
	show_powerup_message(powerup_type)
	# Handle powerup logic here
