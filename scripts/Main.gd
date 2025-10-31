extends Node2D

@onready var ui_manager = $UIManager
@onready var background = $Background

func _ready():
	# Start with main menu state
	setup_test_environment()

func setup_test_environment():
	# Add some test elements to make the scene look alive
	add_test_entities()

func add_test_entities():
	# Add some placeholder entities to see how they'll look with UI
	for i in range(5):
		var enemy_marker = create_entity_marker("enemy", Color.RED)
		enemy_marker.position = Vector2(100 + i * 100, 200)
		add_child(enemy_marker)
	
	for i in range(3):
		var file_marker = create_entity_marker("file", Color.WHITE)
		file_marker.position = Vector2(150 + i * 120, 300)
		add_child(file_marker)

func create_entity_marker(type: String, color: Color) -> Node2D:
	var marker = Node2D.new()
	var sprite = Sprite2D.new()
	
	# Create a simple circle texture for placeholder
	var texture = create_circle_texture(16, color)
	sprite.texture = texture
	marker.add_child(sprite)
	
	# Add a label
	var label = Label.new()
	label.text = type
	label.position = Vector2(-15, 20)
	label.add_theme_color_override("font_color", color)
	marker.add_child(label)
	
	return marker

func create_circle_texture(radius: int, color: Color) -> Texture2D:
	var image = Image.create(radius * 2, radius * 2, false, Image.FORMAT_RGBA8)
	image.fill(Color.TRANSPARENT)
	
	var center = Vector2(radius, radius)
	for x in range(radius * 2):
		for y in range(radius * 2):
			var pos = Vector2(x, y)
			if pos.distance_to(center) <= radius:
				image.set_pixel(x, y, color)
	
	return ImageTexture.create_from_image(image)

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
