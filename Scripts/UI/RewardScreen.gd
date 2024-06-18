extends Panel

func Show(rewardData):
	$VBoxContainer/TextureRect.texture = rewardData.GetRewardTexture()
	$VBoxContainer/Label2.text = rewardData.GetRewardText()
	visible = true

func _on_close_button_button_up():
	visible = false
