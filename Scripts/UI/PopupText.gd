extends Node2D


func Setup(amount):
	$HBoxContainer/Label.text = str(amount)
	$AnimationPlayer.play("anim")
	$HBoxContainer.visible = true

func _on_animation_player_animation_finished(anim_name):
	queue_free()
