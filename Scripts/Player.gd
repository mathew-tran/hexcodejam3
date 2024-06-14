extends RigidBody2D


func _process(delta):
	if Input.is_action_pressed("mouse_click"):
		apply_force(Vector2.UP * 100, Vector2.ZERO)
