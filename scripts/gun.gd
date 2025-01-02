extends Node2D

@export var fire_rate: float = 0.25
var time_since_last_shot: float
@export var BulletScene: PackedScene

func _physics_process(delta):
	time_since_last_shot += delta
	if Input.is_action_pressed("ui_accept") and fire_rate <= time_since_last_shot:
		shoot()
		print("shooted")
		time_since_last_shot = 0.0


func shoot() -> void:
	# Create a new bullet instance
	var bullet = BulletScene.instantiate()
	var rposition : Vector2
	# Set bullet position
	rposition = $RightBullet.position
	print(rposition)
	bullet.global_position = rposition
	# Add the bullet to the scene
	add_child(bullet)
