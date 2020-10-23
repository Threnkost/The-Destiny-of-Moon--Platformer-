extends RigidBody2D

func _ready() -> void:
	apply_impulse(Vector2.ZERO, Vector2(10, 60))
