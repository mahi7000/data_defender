extends CharacterBody2D

@export var speed: float = 300.0
@export var bullet_scene: PackedScene

@onready var gun_tip = $GunTip

func _ready():
	# Placeholder - will be implemented by Coder B
	pass

func _physics_process(delta):
	# Placeholder movement
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input_dir * speed
	move_and_slide()
	
	# Rotate to face mouse
	look_at(get_global_mouse_position())
	
	# Shooting
	if Input.is_action_just_pressed("shoot"):
		shoot()

func shoot():
	if bullet_scene:
		var bullet = bullet_scene.instantiate()
		bullet.position = gun_tip.global_position
		bullet.rotation = global_rotation
		get_parent().add_child(bullet)
