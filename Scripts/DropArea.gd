extends Area2D


func _on_body_entered(body):
	if body.is_in_group("Box"):
		body.queue_free()
		EventManager.ClearDestination()
		queue_free()
