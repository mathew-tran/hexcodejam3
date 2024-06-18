extends Panel

func Show(rewardData):
	if is_instance_valid(rewardData) == false:
		return
	$VBoxContainer/TextureRect.texture = rewardData.GetRewardTexture()
	$VBoxContainer/Label2.text = rewardData.GetRewardText()
	visible = true

func _on_close_button_button_up():
	visible = false
