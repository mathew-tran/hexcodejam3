extends Button


@export var DroneData : PlayerSkinData


func Update():
	$TextureRect.texture = DroneData.GetSkin()
	if DroneData.IsOwned():
		$TextureRect.modulate = Color.WHITE
		$Label.text = DroneData.GetSkinName()
	else:
		$TextureRect.modulate = Color.BLACK
		$Label.text = "???"



func _on_button_up():
	if DroneData.IsOwned():
		EventManager.ChangePlayerSkin.emit(DroneData.GetSkin())
