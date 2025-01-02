extends RigidBody2D

# Bullet speed
@export var speed: float = 600.0

func _process(delta: float) -> void:
	# Move the bullet forward
	apply_impulse(Vector2(100,0))
	

