extends Node2D

@export var spawn_area: Rect2 = Rect2(50, 50, 700, 500)
@export var max_enemies: int = 10

var current_enemies: int = 0
var enemy_scenes: Dictionary = {
	"virus": preload("res://scenes/entities/enemies/virus.tscn"),
	#"trojan": preload("res://scenes/entities/enemies/trojan.tscn"),
	#"worm": preload("res://scenes/entities/enemies/worm.tscn")
}

func _ready():
	EventBus.enemy_died.connect(_on_enemy_died)
	start_wave()

func start_wave():
	# Spawn initial enemies for level 1
	var enemy_count = min(5 + (GameManager.current_level * 2), max_enemies)
	
	for i in enemy_count:
		spawn_enemy("virus", get_random_spawn_position())
	
	#if GameManager.current_level >= 2:
		#for i in range(GameManager.current_level - 1):
			#spawn_enemy("trojan", get_random_spawn_position())

func spawn_enemy(type: String, position: Vector2) -> Node2D:
	if enemy_scenes.has(type) and current_enemies < max_enemies:
		var enemy_instance = enemy_scenes[type].instantiate()
		enemy_instance.position = position
		add_child(enemy_instance)
		current_enemies += 1
		EventBus.enemy_spawned.emit(enemy_instance)
		return enemy_instance
	return null

func get_random_spawn_position() -> Vector2:
	return Vector2(
		randf_range(spawn_area.position.x, spawn_area.end.x),
		randf_range(spawn_area.position.y, spawn_area.end.y)
	)

func _on_enemy_died(enemy_type: String, position: Vector2, points: int):
	current_enemies -= 1
	
	# Spawn new enemy if we're below threshold
	if current_enemies < max_enemies / 2:
		call_deferred("_delayed_spawn")

func _delayed_spawn():
	await get_tree().create_timer(1.0).timeout
	spawn_enemy("virus", get_random_spawn_position())

func get_spawn_area() -> Rect2:
	return spawn_area
