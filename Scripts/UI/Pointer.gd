extends TextureRect


var Target

func _ready():
	visible = false

func _on_timer_timeout():
	var target = EventManager.GetDestination()
	if is_instance_valid(target):

		var player = EventManager.GetPlayer()
		if player.global_position.distance_to(target.global_position) > 500:
			visible = true
			rotation = (target.global_position - player.global_position).angle()
		else:
			visible = false
	else:
		visible = false
