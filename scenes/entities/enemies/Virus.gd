extends CharacterBody2D

const SPEED = 70.0
const DAMAGE: int = 10
const DAMAGE_COOLDOWN: float = 1.0

var health: int = 1
var points: int = 100
var player: Node2D = null
var enemy_type: String = "virus"
var can_attack: bool = true

func _ready():
	player = get_tree().get_first_node_in_group("player")
	add_to_group("enemies")
	print("Virus spawned at position: ", global_position)

func _physics_process(delta: float) -> void:
	if player == null:
		player = get_tree().get_first_node_in_group("player")
		if player:
			print("Found player at: ", player.global_position)
		return
	
	# Debug: print positions to see what's happening
	if Engine.get_frames_drawn() % 60 == 0:  # Print once per second
		print("Virus at: ", global_position, " | Player at: ", player.global_position)
	
	# Move toward player
	var direction_to_player = (player.global_position - global_position).normalized()
	velocity = direction_to_player * SPEED
	
	print("Virus velocity: ", velocity)  # Debug velocity
	
	# Move and check for collisions
	move_and_slide()
	
	# Check if we collided with the player
	check_player_collision()

func check_player_collision():
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var body = collision.get_collider()
		
		if body and body.is_in_group("player") and can_attack:
			damage_player(body)
			break

func damage_player(player_node):
	if can_attack:
		print("Virus damaging player!")
		if EventBus.has_signal("player_damaged"):
			EventBus.player_damaged.emit(DAMAGE)
		
		can_attack = false
		await get_tree().create_timer(DAMAGE_COOLDOWN).timeout
		can_attack = true

func take_damage(amount: int):
	print("Virus taking damage! Health before: ", health)
	health -= amount
	print("Health after: ", health)
	if health <= 0:
		die()

func die():
	print("Virus dying and queue_free() called!")
	if EventBus.has_signal("enemy_died"):
		EventBus.enemy_died.emit(enemy_type, global_position, points)
	queue_free()
