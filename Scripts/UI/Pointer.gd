extends TextureRect


var Target

func _ready():
	visible = false

func _process(delta):
	var target = EventManager.GetDestination()
	if is_instance_valid(target):

		var player = EventManager.GetPlayer()
		var distance = player.global_position.distance_to(target.global_position)
		$"../Label".text = "%0.3f km" % (distance/7500)

		if distance > 500:
			visible = true
			rotation = (target.global_position - player.global_position).angle()
			$"../Label".global_position = global_position - Vector2(0,32)
		else:
			visible = false
		$"../Label".visible = visible
	else:
		visible = false
		$"../Label".visible = visible


