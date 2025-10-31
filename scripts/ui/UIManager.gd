extends CanvasLayer

# References to all UI elements
@onready var hud = $HUD
@onready var score_container = $HUD/ScoreContainer
@onready var score_label = $HUD/ScoreContainer/ScoreLabel
@onready var lives_container = $HUD/LivesContainer
@onready var lives_label = $HUD/LivesContainer/LivesLabel
@onready var level_container = $HUD/LevelContainer
@onready var level_label = $HUD/LevelContainer/LevelLabel
@onready var message_label = $HUD/MessageLabel
@onready var game_over_screen = $GameOverScreen
@onready var final_score_label = $GameOverScreen/MarginContainer/VBoxContainer/FinalScoreLabel
@onready var high_score_label = $GameOverScreen/MarginContainer/VBoxContainer/HighScoreLabel
@onready var restart_button = $GameOverScreen/MarginContainer/VBoxContainer/RestartButton

func _ready():
	# Connect signals
	EventBus.update_ui_score.connect(_on_update_score)
	EventBus.update_ui_lives.connect(_on_update_lives)
	EventBus.level_changed.connect(_on_level_changed)
	EventBus.game_over.connect(_on_game_over)
	EventBus.show_message.connect(_on_show_message)
	
	# Initial setup
	game_over_screen.visible = false
	message_label.visible = false
	
	# Apply cyber theme
	_apply_cyber_theme()
	
	# Start with initial values
	_on_update_score(0)
	_on_update_lives(3)
	_on_level_changed(1)

func _apply_cyber_theme():
	# Style panels
	var panel_style = _create_panel_style()
	score_container.add_theme_stylebox_override("panel", panel_style)
	lives_container.add_theme_stylebox_override("panel", panel_style)
	level_container.add_theme_stylebox_override("panel", panel_style)
	game_over_screen.add_theme_stylebox_override("panel", panel_style)
	
	# Style labels
	_style_label(score_label, 24)
	_style_label(lives_label, 24)
	_style_label(level_label, 20)
	_style_label(message_label, 32)
	_style_label(final_score_label, 28)
	_style_label(high_score_label, 24)
	
	# Position HUD elements
	score_container.position = Vector2(20, 20)
	lives_container.position = Vector2(20, 80)
	level_container.position = Vector2(20, 140)
	message_label.position = Vector2(400, 50)

func _create_panel_style() -> StyleBoxFlat:
	var style = StyleBoxFlat.new()
	style.bg_color = Color("0A0A2A80")  # Semi-transparent dark blue
	style.border_color = Color("00FFFF")
	style.border_width_left = 2
	style.border_width_top = 2
	style.border_width_right = 2
	style.border_width_bottom = 2
	style.corner_radius_top_left = 8
	style.corner_radius_top_right = 8
	style.corner_radius_bottom_right = 8
	style.corner_radius_bottom_left = 8
	style.shadow_color = Color("00FFFF40")
	style.shadow_size = 4
	return style

func _style_label(label: Label, font_size: int):
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", Color("00FFFF"))
	label.add_theme_color_override("font_outline_color", Color("0A0A2A"))
	label.add_theme_constant_override("outline_size", 2)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER

# Rest of your existing functions remain the same...
func _on_update_score(score: int):
	score_label.text = "SCORE: " + str(score)
	_animate_score_change()

func _on_update_lives(lives: int):
	lives_label.text = "LIVES: " + str(lives)
	_animate_lives_change(lives)

func _on_level_changed(level: int):
	level_label.text = "LEVEL " + str(level)
	_animate_level_up()

func _on_game_over(final_score: int):
	final_score_label.text = "FINAL SCORE: " + str(final_score)
	high_score_label.text = "HIGH SCORE: " + str(final_score + 500)  # Placeholder
	game_over_screen.visible = true
	_animate_game_over()

func _on_show_message(message: String, duration: float):
	if message_label:
		message_label.text = message
		message_label.visible = true
		_animate_message_appear()
		
		# Create timer and connect properly
		var timer = get_tree().create_timer(duration)
		timer.timeout.connect(_hide_message)

func _hide_message():
	_animate_message_disappear()
	await get_tree().create_timer(0.5).timeout
	if message_label:
		message_label.visible = false

# Animation functions (keep your existing ones)
func _animate_score_change():
	var tween = create_tween()
	tween.tween_property(score_label, "scale", Vector2(1.2, 1.2), 0.1)
	tween.tween_property(score_label, "scale", Vector2(1.0, 1.0), 0.1)

func _animate_lives_change(lives: int):
	if lives_label and lives < 3:
		var tween = create_tween()
		tween.tween_property(lives_label, "modulate", Color.RED, 0.1)
		tween.tween_property(lives_label, "modulate", Color.WHITE, 0.3)

func _animate_level_up():
	if level_label:
		var tween = create_tween()
		tween.tween_property(level_label, "scale", Vector2(1.3, 1.3), 0.2)
		tween.tween_property(level_label, "scale", Vector2(1.0, 1.0), 0.2)

func _animate_message_appear():
	if message_label:
		message_label.scale = Vector2(0.5, 0.5)
		message_label.modulate = Color.TRANSPARENT
		var tween = create_tween()
		tween.parallel().tween_property(message_label, "scale", Vector2(1.0, 1.0), 0.3)
		tween.parallel().tween_property(message_label, "modulate", Color.WHITE, 0.3)

func _animate_message_disappear():
	if message_label:
		var tween = create_tween()
		tween.parallel().tween_property(message_label, "scale", Vector2(0.5, 0.5), 0.3)
		tween.parallel().tween_property(message_label, "modulate", Color.TRANSPARENT, 0.3)

func _animate_game_over():
	if game_over_screen:
		game_over_screen.scale = Vector2(0.8, 0.8)
		game_over_screen.modulate = Color.TRANSPARENT
		var tween = create_tween()
		tween.parallel().tween_property(game_over_screen, "scale", Vector2(1.0, 1.0), 0.5)
		tween.parallel().tween_property(game_over_screen, "modulate", Color.WHITE, 0.5)
