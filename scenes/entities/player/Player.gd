extends CharacterBody2D

@export var speed: float = 300.0
@export var bullet_scene: PackedScene = preload("res://scenes/entities/bullets/Bullet.tscn")
@onready var bullet_spawn = $BulletSpawnPoint
# @onready var gun_tip = $GunTip

func _ready():
	EventBus.player=self
	if bullet_spawn == null:
		print("⚠️ BulletSpawnPoint not found!")
	add_to_group("player")
#	if gun_tip == null:
	#	print("⚠️ GunTip not found!")

func _physics_process(_delta):
	# 1️⃣ Movement
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input_dir * speed
	move_and_slide()

	# 2️⃣ Rotate to face mouse
	look_at(get_global_mouse_position())

func _input(event):
	# 3️⃣ Shooting with left mouse click
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		shoot()

func shoot():
	if bullet_scene and bullet_spawn:
		var bullet = bullet_scene.instantiate()
		bullet.global_position = bullet_spawn.global_position
		bullet.direction = (get_global_mouse_position() - global_position).normalized()
		get_tree().current_scene.add_child(bullet)
	else:
		print("⚠️ Bullet scene or spawn point missing!")
		
func take_damage(amount: int):
	print("Player taking damage: ", amount)
