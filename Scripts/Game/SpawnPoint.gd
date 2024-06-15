extends Sprite2D

func _ready():
	EventManager.RegisterPoint(global_position + Vector2(0, 135))
	queue_free()
