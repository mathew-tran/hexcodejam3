extends Area2D


func _on_body_entered(body):
	if body.is_in_group("Box"):
		var explosion = load("res://Prefabs/Effects/DropExplosion.tscn").instantiate()
		explosion.global_position = global_position
		EventManager.GetItemsGroup().add_child(explosion)
		EventManager.GiveReward()
		body.queue_free()
		EventManager.ClearDestination()

		queue_free()
