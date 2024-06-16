extends HBoxContainer

var PlayerTimesNotMoved = 0

var bShowButtons = false
# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("animateIn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_player_move_check_timer_timeout():
	var player = EventManager.GetPlayer() as Player

	if player:
		if player.IsMoving():
			PlayerTimesNotMoved = 0
			if bShowButtons == true:
				$AnimationPlayer.play("animateIn")
				bShowButtons = false
		else:
			PlayerTimesNotMoved += 1
			if PlayerTimesNotMoved >= 2:
				if bShowButtons == false:
					bShowButtons = true
					$AnimationPlayer.play_backwards("animateIn")
