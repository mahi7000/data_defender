extends Area2D

@export var speed: float = 500.0
var direction:Vector2 = Vector2.ZERO

func _ready():
	# Connect the signal properly using a Callable
	self.body_entered.connect(self._on_body_entered)

func _process(delta):
	position += direction * speed * delta

func _on_body_entered(body):
	if body.is_in_group("enemies"):
		# Emit the enemy_died signal via EventBus
		EventBus.emit_signal("enemy_died", body.get_enemy_type(), body.global_position)
		body.take_damage(1) # or some damage amount
		queue_free()
