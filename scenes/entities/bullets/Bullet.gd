extends Area2D

@export var speed: float = 500.0
@export var damage: int = 100
var direction:Vector2 = Vector2.ZERO

func _ready():
	self.body_entered.connect(self._on_body_entered)

func _process(delta):
	position += direction * speed * delta

func _on_body_entered(body):
	print("Bullet hit: ", body.name, " - Groups: ", body.get_groups())
	
	if body.is_in_group("enemies"):
		print("Enemy hit! Enemy type: ", body.enemy_type)
		
		# Call take_damage FIRST
		body.take_damage(damage)
		
		# Don't emit enemy_died here - let the virus's die() function handle that
		# when health reaches 0
		
		queue_free()
	else:
		print("Hit something else, not an enemy")
