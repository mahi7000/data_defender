extends Node2D

@export var max_enemies: int = 10
@export var total_enemies_to_spawn: int = 15
@export var screen_margin: float = 50.0  # How far outside screen to spawn

var current_enemies: int = 0
var total_enemies_spawned: int = 0
var screen_rect: Rect2
var enemy_scenes: Dictionary = {
	"virus": preload("res://scenes/entities/enemies/Virus.tscn")
}

func _ready():
	# Wait a frame to ensure everything is loaded
	await get_tree().process_frame
	# Get the screen size
	var viewport = get_viewport()
	screen_rect = Rect2(Vector2.ZERO, viewport.get_visible_rect().size)
	
	EventBus.enemy_died.connect(_on_enemy_died)
	start_wave()

func start_wave():
	var enemy_count = min(5, max_enemies)
	print("Starting wave with ", enemy_count, " enemies")
	
	for i in enemy_count:
		spawn_enemy("virus", get_spawn_position_outside_screen())
	
	current_enemies = enemy_count

func spawn_enemy(type: String, position: Vector2) -> Node2D:
	if total_enemies_spawned >= total_enemies_to_spawn:
		print("Reached total spawn limit of ", total_enemies_to_spawn)
		return null
	
	if enemy_scenes.has(type) and current_enemies < max_enemies:
		var enemy_instance = enemy_scenes[type].instantiate()
		enemy_instance.position = position
		get_parent().add_child(enemy_instance)
		current_enemies += 1
		total_enemies_spawned += 1
		print("Spawned ", type, " at position: ", position, " - Current enemies: ", current_enemies, " - Total spawned: ", total_enemies_spawned)
		
		if EventBus.has_signal("enemy_spawned"):
			EventBus.enemy_spawned.emit(enemy_instance)
		return enemy_instance
	return null

func get_spawn_position_outside_screen() -> Vector2:
	# Choose a random side (0=top, 1=right, 2=bottom, 3=left)
	var side = randi() % 4
	var pos = Vector2()
	
	match side:
		0: # Top
			pos.x = randf_range(-screen_margin, screen_rect.size.x + screen_margin)
			pos.y = -screen_margin
		1: # Right
			pos.x = screen_rect.size.x + screen_margin
			pos.y = randf_range(-screen_margin, screen_rect.size.y + screen_margin)
		2: # Bottom
			pos.x = randf_range(-screen_margin, screen_rect.size.x + screen_margin)
			pos.y = screen_rect.size.y + screen_margin
		3: # Left
			pos.x = -screen_margin
			pos.y = randf_range(-screen_margin, screen_rect.size.y + screen_margin)
	
	return pos

func _on_enemy_died(enemy_type: String, position: Vector2, points: int):
	current_enemies -= 1
	print("Enemy died: ", enemy_type, " - Remaining enemies: ", current_enemies, " - Total spawned: ", total_enemies_spawned)
	
	if current_enemies < max_enemies / 2 and total_enemies_spawned < total_enemies_to_spawn:
		call_deferred("_delayed_spawn")
	elif total_enemies_spawned >= total_enemies_to_spawn and current_enemies == 0:
		print("🎉 All enemies defeated! Wave complete!")
		if EventBus.has_signal("level_complete"):
			EventBus.level_complete.emit()

func _delayed_spawn():
	await get_tree().create_timer(1.0).timeout
	if current_enemies < max_enemies and total_enemies_spawned < total_enemies_to_spawn:
		spawn_enemy("virus", get_spawn_position_outside_screen())
