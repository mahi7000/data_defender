extends Node2D

@onready var ui_manager = $UIManager
@onready var background = $Background
@onready var player = $Player
@onready var spawn_manager = $SpawnSystem  # Add SpawnManager node to your scene

func _ready():
	# Start with main menu state
	setup_game_environment()

func setup_game_environment():
	# Clear any test entities
	clear_test_entities()
	
	# Setup player
	setup_player()
	
	# Start enemy spawning through spawn manager
	if spawn_manager:
		print("Spawn manager ready - starting game")
	else:
		print("⚠️ SpawnManager not found!")

func setup_player():
	if player:
		# Configure player properties
		player.speed = 300.0
		# Make sure the player is visible and active
		player.show()
		player.set_process(true)
		player.set_physics_process(true)
		player.set_process_input(true)
		
		# Position player in a safe spot
		player.position = Vector2(400, 300)
	else:
		print("⚠️ Player node not found in main scene!")

func clear_test_entities():
	# Remove any test markers
	for child in get_children():
		if "enemy" in child.name.to_lower() or "file" in child.name.to_lower() or "marker" in child.name.to_lower():
			child.queue_free()

func _input(event):
	# Test controls to simulate game flow
	if event.is_action_pressed("ui_accept"):
		simulate_gameplay_events()
	elif event.is_action_pressed("ui_cancel"):
		simulate_game_over()

func simulate_gameplay_events():
	# Simulate gameplay events to test UI
	print("Simulating gameplay events...")
	
	# Simulate score changes
	for i in range(5):
		await get_tree().create_timer(0.5).timeout
		EventBus.update_ui_score.emit(100 * (i + 1))
		EventBus.show_message.emit("VIRUS ELIMINATED +100", 1.0)
	
	# Simulate level complete
	await get_tree().create_timer(2.0).timeout
	EventBus.level_changed.emit(2)
	EventBus.show_message.emit("LEVEL 2 - INTRUDERS DETECTED", 3.0)

func simulate_game_over():
	print("Simulating game over...")
	EventBus.game_over.emit(1500)
